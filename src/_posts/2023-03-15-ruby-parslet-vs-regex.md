---
title: Parsing a litter log
subtitle: trying out Parslet over regular expressions
---

- [Regular expressions: a problem?](#regular-expressions-a-problem)
- [Discovering Parslet](#discovering-parslet)
- [The part where I wanted to run crying back to regular expressions, until I learned to implement my parser incrementally](#the-part-where-i-wanted-to-run-crying-back-to-regular-expressions-until-i-learned-to-implement-my-parser-incrementally)
- [Takeaways](#takeaways)
- [Next steps](#next-steps)

I made a new Ruby gem: [Litter](https://github.com/fpsvogel/litter). It's for avid trash-picker-uppers like me who keep a log of interesting litter that I collect.

(*Surely* there are other people who do that… *\*does some googling\** [See?](https://sophieneville.net/2019/05/29/the-diary-of-a-lone-litter-picker-20-reasons-why-its-good-to-collect-trash/) I'm not alone!)

But I had another reason to make this odd gem: **I wanted to explore an approach to text parsing that doesn't rely so much on regular expressions.** So I used the [Parslet](https://kschiess.github.io/parslet/) gem, and I thought it would be worth writing this post on how it went.

## Regular expressions: a problem?

> Some people, when confronted with a problem, think “I know, I'll use regular expressions.” Now they have two problems.
>
> – [Jamie Zawinski](regex.info/blog/2006-09-15/247)

Here's the backstory. I'm building another gem called [Reading](https://github.com/fpsvogel/reading) that parses my CSV reading log. Its custom-built parser relies heavily on regular expressions, and it's a lot messier than I'd like. In particular, it's not easy to re-use code for similarly-parsed syntax that occurs in different places.

For example, extra information about a book (series, volume, publisher, etc.) can appear as part of one of two columns, depending on whether I've read the book in multiple editions. I've worked out different ways to re-use the parsing code in cases like this, but the solutions are not uniform or elegant.

**In short, regular expressions aren't in themselves very modular or composable**, and it's up to me to make up for it by building a neat and tidy parsing structure around them. And I haven't done a good job of that so far. (Then there's the separate problem that all but the simplest regular expressions are **hard to read and understand**.)

Before I set out on an epic quest to tame my regular expressions, I wanted to explore an alternative approach that is more structured and harder to make a mess of.

## Discovering Parslet

In the book [Text Processing with Ruby](https://pragprog.com/titles/rmtpruby/text-processing-with-ruby/) I found what I was looking for: Parslet. Below is a simple parser and transform similar to the example in the book.

A lot of the syntax is self-explanatory, and for the rest you can refer to Parslet's [Get Started](https://kschiess.github.io/parslet/get-started.html), [Parser](https://kschiess.github.io/parslet/parser.html), and [Transformation](https://kschiess.github.io/parslet/transform.html) guides.

```ruby
require "parslet"

# An example config file to be parsed.
INPUT = <<~EOM.freeze
  name = Felipe's website
  url = http://fpsvogel.com/
  cool = true
  post count = 37
EOM

# The output after parsing and transforming.
OUTPUT = {
  name: "Felipe's website",
  url: "http://fpsvogel.com/",
  cool: true,
  post_count: 37,
}

# Parses a string into a tree structure, which we'll then transform
# into the above output. (See the code at the bottom.)
class MyParser < Parslet::Parser
  rule(:whitespace) { match('[\s\t]').repeat(1) }
  rule(:newline) { str("\r\n") | str("\n") }

  # e.g. "name" or "url" in the example above.
  rule(:key) { match('[\w\s]').repeat(1).as(:key) }
  rule(:assignment) { str('=') >> whitespace.maybe }
  # e.g. "Felipe's website" in the example.
  # All characters until the end of the line.
  rule(:value) { (newline.absent? >> any).repeat.as(:string) }

  rule(:item) { key >> assignment >> value.as(:value) >> newline }

  rule(:document) { (item.repeat).as(:document) >> newline.repeat }

  root :document
end

# Transforms a parsed tree into a hash like OUTPUT above.
class MyTransform < Parslet::Transform
  rule(string: simple(:s)) {
    case s
    when "true"
      true
    when "false"
      false
    when /\A[0-9]+\z/
      s.to_i
    else
      s.to_s
    end
  }

  rule(key: simple(:k), value: simple(:v)) {
    [k.to_s.strip.gsub(" ", "_").to_sym,
      v]
  }

  rule(document: subtree(:i)) { i.to_h }
end

parsed = MyParser.new.parse(INPUT)
hash = MyTransform.new.apply(parsed)

puts hash == OUTPUT
# => true
```

Neat! This looks **a lot cleaner** than a bunch of regular expressions interspersed in DIY parsing code.

So I decided to build my litter log parser with Parslet.

## The part where I wanted to run crying back to regular expressions, until I learned to implement my parser incrementally

My enthusiasm was curbed as soon as I wrote my first attempt at a parser aaaand… I got a `Parslet::ParseFailed` error. It did tell me the input line where the problem occurred, but that doesn't help when there are many rules at play in one line and I don't know which of them needs to be adjusted. I was stumped.

This happened several times until I realized that instead of writing a bunch of rules and then testing them out together, I have to **write one rule at a time**, or even one bit of a rule at a time, and examine the output at each step. That way, if I get an error then I know it's because of the one change that I just made.

## Takeaways

In the end, [my parser](https://github.com/fpsvogel/litter/blob/7f51f311aad22c02067faef68a4e42162b9baf5f/lib/litter/parsing/parser.rb) and [transformation](https://github.com/fpsvogel/litter/blob/7f51f311aad22c02067faef68a4e42162b9baf5f/lib/litter/parsing/transform.rb) are quite pleasing to the eye, and I think more maintainable than if I'd used regular expressions plus custom parsing code.

In the tests you can see [example input](https://github.com/fpsvogel/litter/blob/7f51f311aad22c02067faef68a4e42162b9baf5f/test/parse_test.rb#L22-L32) and [example output](https://github.com/fpsvogel/litter/blob/7f51f311aad22c02067faef68a4e42162b9baf5f/test/parse_test.rb#L70-L87). Considering how different the input and output are, the amount of code that I had to write is fairly small.

You may have noticed that my transformation class doesn't use Parslet rules. That's because `Parslet::Transform` works best when a parsed tree is very predictable in its structure, and when the basic structure of the tree doesn't need to change. To quote Parslet's "Transformation" doc:

> Transformations are there for one thing: Getting out of the hash/array/slice mess parslet creates (on purpose) into the realm of your own beautifully crafted AST classes. Such AST nodes will generally correspond 1:1 to hashes inside your intermediary tree.

In my case, I needed to radically change the structure of the output (grouping item occurrences by item instead of by date of occurrence), so it made sense to iterate over the parsed output in my own way.

## Next steps

After this trial run with Parslet, I've decided to use it in my larger project Reading, where it will replace my oversized regular expressions and ad-hoc parsing code. It will take a lot of work to replace what amounts to the majority of the code in that gem, but I think it's worthwhile for a couple of reasons:

- I have a hard time understanding the current code because **parsing and transformation is all mixed up**. It's only after playing around with Parslet, which separates the two, that I'm finally able to perceive this problem.
- The column that I still need to implement is **the most complex of all** (the History column for fine-grained tracking of reading/watching), and I've been putting off implementing it because of how messy I imagine it will be with the old hodgepodge approach.

And, well, doing more Parslet is the thing I'm most interested in right now, and I think that counts for *something* in my open-source project that no one uses besides me 😂
