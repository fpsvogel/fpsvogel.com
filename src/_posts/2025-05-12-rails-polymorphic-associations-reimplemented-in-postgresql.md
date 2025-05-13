---
title: Reimplementing polymorphic associations in the database
subtitle: a stricter alternative to what Rails offers
description: Ruby on Rails allows polymorphic associations, but did you know you can do the same thing in the database, more strictly with referential integrity?
---

- [Simple alternatives](#simple-alternatives)
- [But what if I want to actually re-implement polymorphic associations in the database?](#but-what-if-i-want-to-actually-re-implement-polymorphic-associations-in-the-database)
  - [Referential integrity](#referential-integrity)
  - [Avoiding orphaned records](#avoiding-orphaned-records)
- [Further work](#further-work)
- [Credits](#credits)

[Polymorphic associations](https://guides.rubyonrails.org/association_basics.html#polymorphic-associations) are one of those Rails features that can compress a lot of complexity into just a few lines of code. But as is often the case with Rails, the convenience comes at a cost.

Don't get me wrong, I'm not out on a personal vendetta against polymorphic associations. The only time I've felt the pain of them is once at work, when I renamed a model that was polymorphically associated and I forgot to do a corresponding data migration to update the class name stored in the `type` column. This resulted in a brief outage of parts of the app while I hastily reverted the name change.

Minor annoyances aside, the real risk of polymorphic associations is that **they go against how relational databases are supposed to work**, as noted in warnings against polymorphic associations [in the GitLab developer documentation](https://docs.gitlab.com/development/database/polymorphic_associations), [by the author of *SQL Antipatterns*](https://stackoverflow.com/a/922341), and [by other database experts](https://duhallowgreygeek.com/polymorphic-association-bad-sql-smell). Follow the links for details, but the tl;dr is that polymorphic associations bring performance and complexity costs at scale.

So what is the alternative?

## Simple alternatives

The suggestion in the GitLab developer docs is to ["use a separate table for every type you would otherwise store in the same table"](https://docs.gitlab.com/development/database/polymorphic_associations/#the-solution).

But what if you *really* want types instead of disparate tables?

A minimalist solution in PostgreSQL is [to use a table with a check constraint for each subtype](https://dba.stackexchange.com/a/330131). This is appropriate if you have just a handful of simple types that only slightly diverge from a common set of columns.

```sql
CREATE TABLE poly (
  poly_id    serial PRIMARY KEY  -- or IDENTITY
, poly_type  "char" NOT NULL REFERENCES poly_type  -- alternative: CHECK constraint
, common_col text               --  optional common column
, a_col1     text
, a_col2     text
, b_col3     text
-- more ?
, CONSTRAINT poly_allowed_cols_type_a CHECK (poly_type = 'a' OR (a_col1, a_col2) IS NULL)
, CONSTRAINT poly_allowed_cols_type_b CHECK (poly_type = 'b' OR (b_col3) IS NULL)
-- more ?
);
```

## But what if I want to actually re-implement polymorphic associations in the database?

OK, fine.

As an example, let's say we're building a project management app that has the tables `standup_updates` and `comments`, and we want to add reactions (👍, ❤️, etc.) that can be attached to either standup updates or comments.

The most commonly-suggested alternative to polymorphic associations is to add a *supertype table*, in this case `reactionables`:

![a diagram of database tables of standup updates, comments, and reactions using a subtype design instead of a polymorphic association](/images/standup-reactions-supertype-table-alternative-to-polymorphic-association.svg)

### Referential integrity

Now every reaction has a bona fide, [referentially-integral](https://en.wikipedia.org/wiki/Referential_integrity) association with a "reactionable", which in turn is associated with either a standup update or a comment.

But doesn't that just kick the can down the road? How do we know that the new reactionable-to-standup-update (or -to-comment) association upholds referential integrity?

We don't, yet, but we can add check constraints to ensure that. For PostgreSQL it would look something like this:

```ruby
# Maintain subtype exclusivity by enforcing a check constraint on each subtype
# table.
# Create a user-defined function that
# 1. Allows a reactionable subtype record to be inserted if there is a record in
#    the reactionables table with the target_id and target_type.
# 2. Does not allow a reactionable subtype record to be inserted if there isn't a
#    record in the reactionables table with the target_id and target_type.
class AddCheckConstraintFunction < ActiveRecord::Migration[8.0]
  def up
    add_check_reactionable_exists_function = <<-SQL
      CREATE OR REPLACE FUNCTION check_reactionable_exists(target_id bigint, target_type CHAR(1))
        RETURNS int
      AS '
        SELECT COALESCE(
          (SELECT 1 FROM reactionables
             WHERE reactionables.id   = target_id
             AND   reactionables.type = target_type),
          0
        );
      '
      LANGUAGE SQL;
    SQL

    execute add_check_reactionable_exists_function
  end

  def down
    remove_check_reactionable_exists_function = <<-SQL
      DROP FUNCTION check_reactionable_exists(bigint, character);
    SQL

    execute remove_check_reactionable_exists_function
  end
end

# For each subtype decide on the subtype indicator (e.g. 'S' for standup_updates),
# then add a check constraint which calls the function defined above to
# implement a custom referential integrity between the reactionables table and
# the subtype tables.
class AddCheckConstraintToStandupUpdates < ActiveRecord::Migration[8.0]
  def up
    add_check_reactionable_exists_constraint = <<-SQL
      ALTER TABLE standup_updates ADD CONSTRAINT supertype_check
        CHECK(check_reactionable_exists(standup_updates.reactionable_id, 'S') = 1);
    SQL

    execute add_check_reactionable_exists_constraint
  end

  def down
    remove_check_reactionable_exists_constraint = <<-SQL
      ALTER TABLE standup_updates DROP CONSTRAINT supertype_check;
    SQL

    execute remove_check_reactionable_exists_constraint
  end
end

# This migration is shown to demonstrate adding a new "reactionable" table.
class AddCheckConstraintToComments < ActiveRecord::Migration[8.0]
  def up
    add_check_reactionable_exists_constraint = <<-SQL
      ALTER TABLE comments ADD CONSTRAINT supertype_check
        CHECK(check_reactionable_exists(comments.reactionable_id, 'C') = 1);
    SQL

    execute add_check_reactionable_exists_constraint
  end

  def down
    remove_check_reactionable_exists_constraint = <<-SQL
      ALTER TABLE comments DROP CONSTRAINT supertype_check;
    SQL

    execute remove_check_reactionable_exists_constraint
  end
end
```

### Avoiding orphaned records

There's another limitation: without further work, this design could lead to orphaned `reactions` records. In other words, a standup update can be destroyed without first destroying the supertype reactionable record.

To solve this, we could add a `BEFORE DELETE` trigger for reactionable subtypes, so that the subtype record cannot be destroyed if an associated supertype reactionable record still exists.

```sql
-- Create a trigger function that attempts to destroy the supertype reactionable
-- record as well.
CREATE FUNCTION cascade_delete_reactionable() RETURNS trigger AS $$
BEGIN
	DELETE FROM reactionables
		WHERE reactionables.id=OLD.id;
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Allow the trigger to destroy the reactionable first. If the reactionable record
-- has associated reactions, then the transaction will fail and the reactionable
-- subtype will not be destroyed.
CREATE TRIGGER cascade_delete_standup_updates
	BEFORE DELETE ON standup_updates FOR EACH ROW
		EXECUTE PROCEDURE cascade_delete_reactionable();
```

Even better, we could add a trigger to automatically destroy the associated supertype reactionable record. I'll leave that as an exercise for the reader.

## Further work

Is this cumbersome? Yes. It would be much less effort to implement all of the above with a polymorphic association.

But at a large enough scale, and with a little more work around these check constraints and triggers, this kind of "polymorphic association in the database" could be worthwhile.

## Credits

I first explored this topic almost two years ago when I was in between jobs and briefly participated in a Ruby-focused mentorship program called The Agency of Learning. It was another participant, Won Rhim, who first came up with the idea of implementing "stricter polymorphic associations" in the database, and the last two code snippets above are Won's.

This post is based on part of a design proposal that Won and I wrote and got feedback on from others in the program. As of this writing [the design proposal is still publicly viewable](https://toyhammered.notion.site/WIP-Standup-Emoji-reactions-a9aa0913283847009bffed6f15c31cc5)—and if that link is broken, [here's an archived version](https://github.com/fpsvogel/fpsvogel.com/tree/main/src/_archive/polymorphic_associations_in_db). The part related to this post is under the heading *"B. Using a supertype table to represent “reactionable” subtype tables"*.
