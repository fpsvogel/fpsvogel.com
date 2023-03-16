---
title: Parsing text in Ruby, part 1
subtitle: Parslet transforming my world
---

- [Regular expressions: not the problem](#regular-expressions-not-the-problem)
- [Discovering Parslet](#discovering-parslet)
- [The part where I wanted to run crying back to regular expressions, until I learned to implement my parser incrementally](#the-part-where-i-wanted-to-run-crying-back-to-regular-expressions-until-i-learned-to-implement-my-parser-incrementally)
- [Takeaways](#takeaways)
- [Next steps](#next-steps)

I made a new Ruby gem: [Litter](https://github.com/fpsvogel/litter). It's for avid trash-picker-uppers like me who keep a log of interesting litter that I collect.

(*Surely* there are other people who do that… *\*does some googling\** [See?](https://sophieneville.net/2019/05/29/the-diary-of-a-lone-litter-picker-20-reasons-why-its-good-to-collect-trash/) I'm not alone!)

But I had another reason to make this odd gem: **I wanted to explore a more structured approach to text parsing** than what I've come up with on my own so far. So I used the [Parslet](https://kschiess.github.io/parslet/) gem, and I thought it would be worth writing this post on how it went.

## Regular expressions: not the problem

Here's the backstory. I'm building another gem called [Reading](https://github.com/fpsvogel/reading) that parses my CSV reading log. It has a custom-built parser that is quite messy, for reasons that I couldn't articulate until just now when I tried Parslet.

At first I thought the messiness came from the numerous regular expressions in my homespun parser. The well-known saying comes to mind:

> Some people, when confronted with a problem, think “I know, I'll use regular expressions.” Now they have two problems.
>
> – [Jamie Zawinski](regex.info/blog/2006-09-15/247)

It's true that some of my regular expressions are long and hard to read, but **I don't think regular expressions are the problem** because even if I broke them up and made them easier to read, that parser code would still be a mess.

The problem with my Reading parser, I now realize, is this: **it mixes up parsing and transformation** rather than separating them into two steps.

*Hold up, what is "transformation" and how is it different from parsing?* I didn't know either, before I tried Parslet. So let's take a look at Parslet to find out!

## Discovering Parslet

In the book [Text Processing with Ruby](https://pragprog.com/titles/rmtpruby/text-processing-with-ruby/) I found the structured parsing tool that I was looking for: Parslet. Below is an example similar to the one in the book.

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

To summarize, a two-step process happens here: first the `INPUT` string is parsed into an intermediate tree structure, and then the tree is transformed into the simpler hash as in `OUTPUT`.

Neat! This looks **a lot cleaner** than if I had mixed parsing and transformation together like I did in my Reading parser.

Impressed by this tidiness, I proceeded to build my litter log parser with Parslet.

## The part where I wanted to run crying back to regular expressions, until I learned to implement my parser incrementally

My enthusiasm was curbed as soon as I wrote my first attempt at a parser aaaand… I got a `Parslet::ParseFailed` error. It did tell me the input line where the problem occurred, but that doesn't help when there are many rules at play in one line and I don't know which of them needs to be adjusted. I was stumped.

This happened several times until I realized that instead of writing a bunch of rules and then testing them out together, I have to **write one rule at a time**, or even one bit of a rule at a time, and examine the output at each step. That way, if I get an error then I know it's because of the one change that I just made.

## Takeaways

In the end, [my parser](https://github.com/fpsvogel/litter/blob/7f51f311aad22c02067faef68a4e42162b9baf5f/lib/litter/parsing/parser.rb) and [transformation](https://github.com/fpsvogel/litter/blob/7f51f311aad22c02067faef68a4e42162b9baf5f/lib/litter/parsing/transform.rb) are definitely easier to understand than if I'd winged it and built an ad-hoc parser that (as before) doesn't separate transformation into a separate step.

In the tests you can see [example input](https://github.com/fpsvogel/litter/blob/7f51f311aad22c02067faef68a4e42162b9baf5f/test/parse_test.rb#L22-L32) and [example output](https://github.com/fpsvogel/litter/blob/7f51f311aad22c02067faef68a4e42162b9baf5f/test/parse_test.rb#L70-L87). Considering how different the input and output are, the amount of code that I had to write is fairly small.

You may have noticed that my transformation class doesn't use Parslet rules. That's because `Parslet::Transform` works best when a parsed tree is very predictable in its structure, and when the basic structure of the tree doesn't need to change. To quote Parslet's "Transformation" doc:

> Transformations are there for one thing: Getting out of the hash/array/slice mess parslet creates (on purpose) into the realm of your own beautifully crafted AST classes. Such AST nodes will generally correspond 1:1 to hashes inside your intermediary tree.

In my case, I needed to radically change the structure of the output (grouping item occurrences by item instead of by date of occurrence), so it made sense to iterate over the parsed output in my own way.

## Next steps

After this trial run with Parslet, I'm considering using it in my larger project Reading, where it could replace my ad-hoc parsing code. It would take a lot of work to replace what amounts to the majority of the code in that gem, but it might be worthwhile for a couple of reasons:

- I have a hard time understanding the parsing code in my Reading gem because, as I've mentioned, **parsing and transformation is all mixed up**. It's only after playing around with Parslet, which separates the two, that I'm finally able to perceive this problem.
- The column that I still need to implement is **the most complex of all** (the History column for fine-grained tracking of reading/watching), and I've been putting off implementing it because of how messy I imagine it will be with the old hodgepodge approach.

And, well, doing more Parslet (or taking a similar parse-and-transform approach) is the thing I'm most interested in right now, and I think that counts for *something* in my open-source project that no one uses besides me 😂

Before you go, here's a particularly trashy spot in the park where I've begun cleaning up. (That is a mattress in the upper-right corner. It will definitely find its way into my litter log.)

![trash strewn along a stream in my neighborhood park](/images/trash-in-park.jpg)
