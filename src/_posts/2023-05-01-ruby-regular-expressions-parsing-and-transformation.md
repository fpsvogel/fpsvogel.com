---
title: Parsing text in Ruby, part 2
subtitle: parse and transform with regular expressions
---

- [Why not Parslet?](#why-not-parslet)
- [Overview of my parsing + transforming](#overview-of-my-parsing--transforming)
- [Separating parsing out from transforming](#separating-parsing-out-from-transforming)
- [Taming regular expressions](#taming-regular-expressions)
- [Conclusion: a feeling of lightness](#conclusion-a-feeling-of-lightness)


In [the first part of this series](/posts/2023/ruby-parslet-parsing-and-transformation) I described an epiphany that I had after discovering the [Parslet](https://kschiess.github.io/parslet) gem: **code for parsing text can become better-organized if I split off data transformation as a second step after parsing.**

In the end, though, a question remained. It was fun to use Parslet in a throwaway script, but **was I going to use Parslet in a real-world scenario?** (Namely, my [Reading](https://github.com/fpsvogel/reading) gem, which has a small but very dedicated user base of one, myself.)

In other words, would it be worthwhile to rip out my messy-but-working parsing code to replace it with Parslet? Or was there a more incremental approach where I could use some of my existing code while still reaping the benefits of separate parse and transform steps?

## Why not Parslet?

I decided to rework my existing code rather than use Parslet, for a few reasons:

- My Reading gem doesn't depend on any other gems, and I wanted to keep it that way.
- Writing a parser with Parslet can be frustrating due to the fact that if the input doesn't match the rules you've set up, the parsing will fail entirely, throwing an error instead of giving parsed output, and it's up to you to figure out why. With regular expressions, it's more common to get wrong output that can give clues as to what went wrong.
- I had a feeling that I'd learn more by rolling my own solution. And I think I was right!

If you want to skip all the technical bits and go straight to [my conclusion below](#conclusion-a-feeling-of-lightness), please feel free. I realize not everyone is as excited as I am about the minutiae of parsing a reading list 😂

## Overview of my parsing + transforming

Here's an overview of how my custom two-step parsing-and-transforming, copied from a comment [in the top-level file of the gem](https://github.com/fpsvogel/reading/blob/main/lib/reading.rb):

```ruby
# Architectural overview:
#
#                 (CSV input)                    (Items)   (filtered Items)
#                      |                          Λ   |           Λ
#                      |                          |   ·---.       |
#                      |                          |       |       |
#                      V                          |       V       |
#                   ::parse                       |     ::filter  |
#                      |                          |          |    |
#                      |            .----------> Item        Filter
#  Config,             |           /             / \
#  errors.rb ----- Parsing::CSV --·    Item::View  Item::TimeLength
#                     / \
#      Parsing::Parser  Parsing::Transformer
#             |                 |
#       parsing/rows/*   parsing/attributes/*
#
```

In a nutshell, input from a CSV file is fed into `Reading::parse`, which passes it on to `Parsing::CSV`, where `Parsing::Parser` is used to produce an intermediate hash (with a structure mirroring the CSV columns), then `Parsing::Transformer` is used to transform it into a final hash (with a structure based on item attributes and not CSV columns). An array of these attribute-based hashes, each representing an item, is returned from `Reading::parse`.

We don't need to worry about the right side of the diagram here, because that's what happens after parsing and transforming in order to make their output more convenient for the user.

Now let's take a closer look at `Parsing::Parser`. This is the first half of the two-step parse-and-transform, and it's inspired by Parslet's [Parser](https://kschiess.github.io/parslet/parser.html). I won't get into the second step `Parsing::Transformer` only because it's essentially my old code minus a bunch of strictly parsing code that's been moved elsewhere, so that all that's left is tidying up the parser output. That's a big improvement, but there's not much else to say about it. So let's turn to the more interesting half of the equation: parsing.

## Separating parsing out from transforming

[`Parsing::Parser`](https://github.com/fpsvogel/reading/blob/main/lib/reading/parsing/parser.rb) is where I added most of the new code. To reiterate a point I made in my last post, the problem with my parsing code was that **it mixed up parsing and transforming into one big muddled mess**. For each item attribute (title, author, length, etc.), the parser reached into the CSV row (sometimes across multiple columns) to grab the relevant substrings and process them to get the desired output. What made the code so hard to understand is that the grabbing and the processing (i.e. the parsing and the transforming) happened all together.

For example, [here](https://github.com/fpsvogel/reading/blob/v0.6.0/lib/reading/attribute/variants/variants_attribute.rb) is the old parsing code for the *variants* attribute of an item (which can represent different editions of a book, the audiobook vs. the ebook, etc.). The only reason that file is reasonably short is that most of the work is delegated out to four other files, each being equally long as this one. Splitting up messy code into smaller chunks of messy code is better than nothing, but I still often struggled to understand some of this code that I myself had written, so I knew it needed more work.

Now that I've separated parsing out from transforming that same file for the *variants* attribute has **only 77 lines, as opposed to the 293 lines from before** (counting the lines from the formerly required files). It's not only shorter, but also easier to understand since it doesn't mix finding CSV row substrings (parsing) with tidying them up (transforming).

Where did all those extra lines go? As I pulled out code that was strictly for parsing a CSV row, I noticed that my CSV columns share certain characteristics. I abstracted those into a [`Column`](https://github.com/fpsvogel/reading/blob/main/lib/reading/parsing/rows/column.rb) class which has a subclass for each of the columns. This way, instead of the parsing code being partially duplicated for each item attribute, all the parsing can happen in one place (in `Parsing::Parser`) with variations determined by the `Column` subclasses.

A simple example is the Genres column, whose main distinguishing characteristic is that it's a comma-separated list:

```ruby
module Reading
  module Parsing
    module Rows
      module Regular
        # See https://github.com/fpsvogel/reading/blob/main/doc/csv-format.md#genres-column
        class Genres < Column
          def self.segment_separator
            /,\s*/
          end

          def self.regexes(segment_index)
            [%r{\A
              (?<genre>.+)
            \z}x]
          end
        end
      end
    end
  end
end
```

At this point you may be thinking: *Wait, this whole thing is built on regular expressions? 😱* Yes! Now I actually like regular expressions more than I did before, because this approach solved another problem with my old code: **the unruliness of regular expressions.**

## Taming regular expressions

As you can see in the example above, each `Column` subclass contains all the regular expressions needed for that column's parsing. This is a big improvement over my previous approach of having regular expressions scattered throughout the parsing code and (better but still confusingly) in a config file.

What's more, I made use of the `\x` multiline modifier to make regular expressions more readable with line breaks, indentation, and comments. I also stored re-used parts of regular expressions in constants and then interpolated them, using the `\o` modifier to force the interpolation to be done only once, for efficiency's sake.

The extreme example of a long regular expression is [in the History column](https://github.com/fpsvogel/reading/blob/v0.8.0/lib/reading/parsing/rows/regular_columns/history.rb#L44-L108), home of a regular expression that is **a whopping 83 lines long**, counting the lines from an interpolated regular expression.

If I sound boastful of my monstrously long regular expression, it's because I'm proud that it's still readable, at least to me, and **that was not the case** even with much shorter one-line regular regular expressions in my old code, simply because it's hard to visually parse a regular expression on a single line if it has even two or three capturing groups or other elements within parentheses.

For example, here is one of the simpler regular expressions, the one for the Length column, jammed into one line:

```ruby
/\A(((?<length_pages>\d+)p?|(?<length_time>\d+:\d\d))(\s+|\z))((?<each>each)|(x(?<repetitions>\d+)))?\z/
```

No mere mortal could read that regular expression. Breaking it up and adding comments makes a world of difference:

```ruby
%r{\A
  # length
  (
    (
      (?<length_pages>\d+)p?
      |
      (?<length_time>\d+:\d\d)
    )
    (\s+|\z)
  )
  # each or repetitions, used in conjunction with the History column
  (
    # each
    (?<each>each)
    |
    # repetitions
    (
      x
      (?<repetitions>\d+)
    )
  )?
\z}x
```

Now we can see that it's made up of two halves: the length (in pages or time) and then either "each" or a number of repetitions. So it could look something like `200p` or `1:30 each` or `0:20 x14`.

You could argue that regular expressions don't look as clean as Parslet's DSL ([here's a nice example of it](https://kschiess.github.io/parslet/)), but for me that's outweighed by how much more convenient regular expressions are, both because I already know them well and because they're easier to debug, especially with a regular expression sandbox like [Rubular]([rubular.com/](https://rubular.com/)).

## Conclusion: a feeling of lightness

I'm afraid this might be my most pedantic and tedious blog post to date, covering in great detail a very obscure project—which, again, has known a user base of one. So I wanted to close by telling *why* this refactoring was significant enough for me to wax eloquent about it in this post.

Until recently, my progress in my Reading gem was stalled. I had one more column that needed to be implemented with parsing code, the History column. But that column was **so complex**, encompassing various ways of tracking your progress in a podcast, a book, or whatever else you read, listen to, or watch. [Here's more](https://github.com/fpsvogel/reading/blob/v0.8.0/doc/csv-format.md#history-column) on what the History column looks like, if you're curious, but my point here is that I was paralyzed and couldn't bring myself to implement History column parsing because of how **messy and hard to follow** the parsing code was for the simpler columns that I'd already implemented. I shuddered to think of how long and unenjoyable it would be to implement the History column, and how impenetrable the code would be to me just a few days later.

And then I found Parslet, and it was like a beam of light breaking through dark clouds. *(Cue uplifting choral music.)* It showed me a way to organize my parsing (and now transforming) code in a way that not only made me **excited** to implement that last column, but also now **makes me feel like a burden has been lifted**, whose weight I felt every time I looked at my parsing code in my Reading gem. The code was a slog to read and to change, and I wasn't happy with it despite my best efforts to clean it up. Now, post-refactor, I actually enjoy re-reading my code, and it all feels a lot lighter even with that massive History column added in.

Thanks for reading and following along in my adventure. I hope it inspires you to write code that gives you that same feeling of lightness when you read and re-read it.
