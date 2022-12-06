---
title: OOP vs. services for organizing business logic
subtitle: is there a third way?
---

- [The good old days](#the-good-old-days)
- [Then along came Rails](#then-along-came-rails)
- [Two philosophical camps?](#two-philosophical-camps)
- [Service object skepticism](#service-object-skepticism)
- [Second-guessing myself; more study needed](#second-guessing-myself-more-study-needed)
  - [Inductive study: open-source Rails codebases](#inductive-study-open-source-rails-codebases)
  - [Deductive study: books, talks, and gems](#deductive-study-books-talks-and-gems)
- [Conclusion: to be continued…](#conclusion-to-be-continued)

*Disclaimer: In this blog post I raise many questions and give few answers. At the bottom I list resources which I'm exploring in search of an answer, so [skip down](#second-guessing-myself-more-study-needed) if that's all you care about.*

**Business logic.** Everyone has it, and no one seems to agree on where to put it in a Rails app. Some people stuff it all in Active Record models, others throw it out into service objects, and still others put it in POROs. (But then [where do you put the POROs](https://twitter.com/JacobDaddario/status/1578083937787707392)?)

In all these debates, there's probably an element of different answers coming from different needs: people who work with **small apps** don't stray far from The Rails Way of MVC (models, views, and controllers), whereas those who work with **larger apps** might feel the need for a more sophisticated architecture.

That being said, I sense that these disagreements also reflect a more fundamental question: ***How should the app interact with the database?*** Or in other words, should database tables be near the surface, ***or*** should we put in the effort to hide the data model that is reflected in database tables?

I may have lost you already, so before I wade too deep into philosophy, let tell the story of why I'm struggling with these questions.

## The good old days

Before I learned Rails, I knew Ruby. I loved it. It made sense. Propelled by Sandi Metz's talks and books, I could write a plain Ruby app in the most beautiful and satisfying OOP style. Life was good.

But I knew I couldn't linger in those enchanted woods forever.

## Then along came Rails

I learned Rails and got my first programming job working on a Rails app of over two hundred thousand lines of Ruby code, plus React views. **Suddenly things didn't make so much sense anymore.** I often didn't (and still don't) know where a piece of code belongs. Let's even set aside React views and the duplication of backend logic that I find hard to resist when writing a React view. Let's focus **only on backend Ruby code**: *even there* I find myself indecisive when trying to decide where to put a new piece of code.

The most convenient place for that new bit of code is an existing Active Record model, but when I'm crawling through a huge model I'm reminded that maybe I should think hard about where to put this code. So I turn to alternative places, but then I'm faced with a jungle of service objects and variously-located POROs 😵‍💫

I usually find a tolerable solution, but in the end I always wonder: where does business logic really belong? 🤔

## Two philosophical camps?

As I looked through discussions of this question in the Ruby community, I noticed that most answers came from one of two "sides": **advocates** and **opponents** of service objects. In reality it's a bit more nuanced than that: advocates might propose a pattern that is a more sophisticated version of service objects, and many opponents admit that careful OOP design is important to augment Rails' MVC structure.

But the reason I lump them into two camps is that **each has a different approach** to the fundamental question I posed earlier: ***How should the app interact with the database?*** In the context of Rails, this question can be rephrased like this: ***What should an Active Record model represent?***

Advocates of service objects often [think of Active Record models as **models of database tables**](https://youtu.be/CRboMkFdZfg?t=319), and therefore not an appropriate place to put business logic. The other camp sees Active Record models as **models of domain objects** that just happen to be backed by a database table, and therefore a perfectly suitable place for business logic.

## Service object skepticism

For several months I thought the anti-service-object camp was right, end of discussion. It seemed clear to me that Active Record models are intended to be domain models:

<!-- omit in toc -->
#### It's spelled out in the Rails Guides.

[See for yourself.](https://guides.rubyonrails.org/active_record_basics.html#what-is-active-record-questionmark)

<!-- omit in toc -->
#### Martin Fowler, who first described the Active Record pattern, agrees.

To quote [his article on the Active Record pattern](https://www.martinfowler.com/eaaCatalog/activeRecord.html):

> "An object carries both data and behavior. Much of this data is persistent and needs to be stored in a database. Active Record uses the most obvious approach, putting data access logic in the domain object."

So an Active Record object is intended to be fundamentally a domain object, with database access added for convenience, not the other way around. Probably that's why it seems against the grain of Rails when service objects are ***the*** place where business logic goes.

Fowler directly criticizes service objects in [his article on anemic domain models](https://www.martinfowler.com/bliki/AnemicDomainModel.html). In reference to putting domain logic in services, he says:

> "The fundamental horror of this anti-pattern is that it's so contrary to the basic idea of object-oriented design; which is to combine data and process together. The anemic domain model is really just a procedural style design."

And:

> "In general, the more behavior you find in the services, the more likely you are to be robbing yourself of the benefits of a domain model. If all your logic is in services, you've robbed yourself blind."

<!-- omit in toc -->
#### Conversely, domain models don't have to be Active Record models; they can be PORO models.

Taking advantage of this can alleviate many of the "fat model" problems that service objects seek to solve.

Martin Fowler [proposes refactoring a service object into a PORO](https://gist.github.com/blaix/5764401), and he's not alone: some in the Ruby community have written the same ([1](https://www.codewithjason.com/code-without-service-objects/), [2](https://www.fullstackruby.dev/object-orientation/rails/2018/03/06/why-service-objects-are-an-anti-pattern#concerns-and-poros-are-your-friends), [3](https://alexbarret.com/blog/2020/service-object-alternative)).

There are lots of patterns that can be used in POROs around Active Record models. For example, if a record is created from complex form input, you could use [a form object](https://thoughtbot.com/blog/activemodel-form-objects) instead of a service object.

Also, some versions of service objects ***are*** somewhat object-oriented when [they reject the notion that service objects should have only a `#call` method](https://youtu.be/CRboMkFdZfg?t=1576) and when [they share code within the same class](https://youtu.be/CRboMkFdZfg?t=1322). In these cases, a service object is a bit more like a purpose-built PORO.

So why not just take the next step and put these services in the `app/models` folder, and refactor them from procedures into actual domain models? To take an example from the last link above: `SalesTeamNotifier.send_daily_notifications` could be changed to `Internal::Notification.new(receiver: 'sales').send`.

So yeah, **I was a convinced service object skeptic**, firm in dismissing even the need for anything but classic OOP. When I tried to be fair and play devil's advocate, I only got as far as conceding that OOP is harder to get right than procedures, and OOP done wrong can result in a lot of moving parts and less clarity about what actually happens when. I could even appreciate the simplicity of services, in the sense that making one is as easy as copy-pasting a long model method.

## Second-guessing myself; more study needed

Fast forward a few months. I still don't like service objects, and I still like OOP. But now I'm less certain that the cure-all for badly organized business logic is "just do more OOP, end of story."

After all, if so many people **feel the need** for service objects, and if OOP is evidently **so hard to get right**, aren't these signs that **something** is missing? ***Maybe*** that missing something is just better OOP, but in that case good OOP is hard to come by and we at least need a more accessible way to do it.

So I've set out to explore the problem of organizing business logic from more angles than before, using the resources listed below. These lists are excerpted from [my "Learning Ruby" road map](https://github.com/fpsvogel/learn-ruby) which I often update, so you may want to find these lists there if this post is old at the time of your reading it. The sections corresponding to the lists below are, at the time of writing, ["Rails codebases"](https://github.com/fpsvogel/learn-ruby#rails-codebases-to-study) and ["Rails architecture"](https://github.com/fpsvogel/learn-ruby#rails-architecture).

### Inductive study: open-source Rails codebases

I rarely read a lot of code outside of work, but I plan to change that. Below are Rails projects that I've seen mentioned more than once as good examples to learn from, ***or*** they are sufficiently active and well-known as to be good candidates for study.

- **Small codebases:** Less than 50k lines of Ruby code.
  - [github.com/codetriage/codetriage](https://github.com/codetriage/codetriage) (6k lines): *Issue tracker for open-source projects.*
  - [github.com/joemasilotti/railsdevs.com](https://github.com/joemasilotti/railsdevs.com) (12k lines): *The reverse job board for Ruby on Rails developers.*
  - [github.com/lobsters/lobsters](https://github.com/lobsters/lobsters) (13k lines): *Hacker News clone.*
  - [github.com/thoughtbot/upcase](https://github.com/thoughtbot/upcase) (14k lines): *Learning platform for developers.*
  - [github.com/houndci/hound](https://github.com/houndci/hound) (14k lines): *Automated code review for GitHub PRs.*
  - [github.com/rubygems/rubygems.org](https://github.com/rubygems/rubygems.org) (26k lines): *Where Ruby gems are hosted.*
- **Larger codebases:** More than 50k lines of Ruby code.
  - [github.com/solidusio/solidus](https://github.com/solidusio/solidus) (72k lines): *E-commerce platform.*
  - [github.com/mastodon/mastodon](https://github.com/mastodon/mastodon) (75k lines): *Like Twitter but self-hosted and federated.*
  - [github.com/forem/forem](https://github.com/forem/forem) (103k lines): *Powers the blogging site [dev.to](https://dev.to/).*
  - [github.com/alphagov/whitehall](https://github.com/alphagov/whitehall) (117k lines): *Publishes government content on [gov.uk](https://www.gov.uk/).*
  - [github.com/discourse/discourse](https://github.com/discourse/discourse) (322k lines): *Discussion forum platform.*
  - [github.com/instructure/canvas-lms](https://github.com/instructure/canvas-lms) (745k lines): *A popular LMS (learning management system).*
  - [gitlab.com/gitlab-org/gitlab](https://gitlab.com/gitlab-org/gitlab) (1.8 million lines): *Like GitHub but with CI/CD and DevOps features built in. Has great [docs on architecture](https://docs.gitlab.com/ee/development/architecture.html).*

### Deductive study: books, talks, and gems

Here are some resources that I hope will shed light on the question of organizing business logic better, both in terms of solutions ***and*** in terms of **when (under what conditions) these alternative approaches are beneficial** as opposed to simple OOP with Rails defaults. This list is not exhaustive; in particular I came across gems that were essentially service objects in a fancier package, which for the most part I've omitted.

- **Domain-Driven Design**, which aims to augment OOP to prevent problems such as fat models. It's intended for large, complex domains. Resources: ["Getting modules right with Domain-driven Design"](https://www.youtube.com/watch?v=Q_0XW46IlHY) (talk), [*Learning Domain-Driven Design*](https://www.oreilly.com/library/view/learning-domain-driven-design/9781098100124/) (book).
- **Other approaches** that are more lightweight and have some of the same goals:
  - [*Data Oriented Web Development with Ruby*](https://solnic.podia.com/data-oriented-web-development-with-ruby) (upcoming book) by Peter Solnica, who is on the [Hanami](https://hanamirb.org/) core team. Learning Hanami wouldn't be a bad idea either.
  - [*Maintainable Rails*](https://leanpub.com/maintain-rails) (book), which uses gems that are part of the Hanami ecosystem.
  - ["Organizing business logic in Rails with contexts"](https://nts.strzibny.name/business-logic-in-rails-with-contexts/) (blog post).
  - Learn more about the repository pattern: [article](https://engineering.solarisbank.com/the-repository-pattern-in-ruby-with-the-active-record-library-f0445fa282c), [talk](https://www.youtube.com/watch?v=36LB8bfEeVc).
- **Relevant gems** that seem worth learning from:
  - [dry-transaction](https://dry-rb.org/gems/dry-transaction)
  - [Interactor](https://github.com/collectiveidea/interactor)
  - [Sequent](https://www.sequent.io/) – CQRS and event sourcing
  - [Rails Event Store](https://github.com/RailsEventStore/rails_event_store) – for an event-driven architecture
  - [Ventable](https://github.com/kigster/ventable) – a variation of the Observer design pattern
  - [Wisper](https://github.com/krisleech/wisper) – the Publish-Subscribe design pattern
  - [Packwerk](https://github.com/Shopify/packwerk) – to enforce boundaries and modularize Rails applications

## Conclusion: to be continued…

In a year or two I may be able to give something more like an answer to the questions I've raised here. For now, I've made a start by processing my thoughts in writing and making note of some promising resources. If any of this helps you as well, dear reader, then all the better!
