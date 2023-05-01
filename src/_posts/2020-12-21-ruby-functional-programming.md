---
title: Functional programming techniques in Ruby
subtitle: pipelines, callable objects, and other tools for cleaner code
description: Functional programming can make your Ruby code easier to understand. I made a gem for piping data through callable objects.
---

- [1. Pipe data …](#1-pipe-data-)
- [2. … through functions](#2--through-functions)
- [Conclusion](#conclusion)

***UPDATE:** I ended up not using this gem in my project, even though it was a byproduct of that project. In the end it seemed that the verbosity of plain Ruby was an acceptable price to pay for its complete clarity as to what methods are actually being called, which can be become unclear as a pipeline set up with this gem becomes more complex. Ah, well. It was good to learn how to make a gem and practice some metaprogramming, if nothing else.*

Until recently, I had a vague notion of functional programming as Ph.D.-level math embodied in code that is only useful for theoretical problems. On a clear day, I could almost catch a glimpse of it way up in the clouds, surrounded by a halo of theorems, undisturbed by the nitty-gritty, impure real world below. Then I watched these talks:

- [*Blending Functional and OO Programming in Ruby*](https://youtu.be/rMxurF4oqsc) by Piotr Solnica.
- [*Real-World Functional Ruby*](https://youtu.be/4p4LE9J5bWA) by Tim Riley.
- [*Boundaries*](https://www.destroyallsoftware.com/talks/boundaries) by Gary Bernhardt.

Here's what I learned:

1. Any domain can benefit from functional techniques.
2. These techniques can result in code that is simpler, more bug-proof, and more extensible.
3. Functional and object-oriented approaches are not exclusive; they can profitably work side by side.

So what are these techniques? Here are three that are already improving my code.

**DISCLAIMER:** These efforts of mine are *functional lite* or *baby functional*. For a more comprehensive approach, see [dry-rb](https://dry-rb.org/). But be careful not to go overboard with functional programming in Ruby. In the words of Avdi Grimm, "Functional programming ideas about preferring immutability and isolating interactions with the outside world can help us avoid the worst pitfalls of procedural and object-oriented coding. But trying to program in a *'fully FP'* style in Ruby can be like paddling a kayak with a canoe paddle. Upstream. […] Your best bet for effective development is to learn to 'code with the grain' [of the language you're using]. And when you get right down to it, Ruby's grain is object-oriented." ([source](https://github.com/yct21/observatory/issues/93#issuecomment-347175199))

**ANOTHER DISCLAIMER:** I'm new to Ruby, so if you see any glaring stupidities below, you can take comfort in the fact that in a few months I will be shaking my head right along with you. In the meantime, please let me know of anything that can be improved, either [via DM](https://www.reddit.com/message/compose/?to=fpsvogel) or by [raising an issue](https://github.com/fpsvogel/pipeful/issues).

## 1. Pipe data …

Thinking in terms of a data pipeline can be immensely clarifying. Here is the outermost layer of my current project, a CLI app that gives statistics on a reading log. Note that for this to work, I've created [the Pipeful gem](https://github.com/fpsvogel/pipeful) which redefines the `>>` operator and equips Array with a unary `+` operator to convert it to pipe arguments. The fact that it's so easy to do this is one of the many reasons I love Ruby. ❤️

```ruby
require "pipeful"
require_relative "errors"
# ... requires for the function classes below: LoadLibrary, etc.

module Readstat
  extend Pipeful

  @err_block = ->(err) { err.show }

  'C:\read_test.csv' >>
    LoadLibrary(&@err_block) >>
    EachInput do |input, lib|
      +[input, lib] >>
        Command >>
        ShowOutput
    rescue InputError => e; @err_block.call(e)
    end
rescue AppError => e; @err_block.call(e)
end
```

In other words, "Take this file path, load the library from there, then for each user input, take the input and library and run a command based on them, then output the results. Handle errors by showing them to the user. After input errors, keep asking for input. After more serious app errors, end execution. Errors during library loading will be handled there."

This is the vanilla-Ruby equivalent of my monkey-patched code above, first with regular, non-pipeline calls:

```ruby
module Readstat
  @err_block = ->(err) { err.show }

  EachInput.new.call(LoadLibrary.new('C:\read_test.csv').call(&@err_block)) do |input, lib|
    ShowOutput.new.call(Command.new(input).call(lib))
    rescue InputError => e; @err_block.(e)
  end
rescue AppError => e; @err_block.(e)
end
```

That's a bit confusing, with parts that seem backward. We can properly order the calls with `Object#then`:

```ruby
module Readstat
  @err_block = ->(err) { err.show }

  LoadLibrary.new('C:\read_test.csv').call(&@err_block)
    .then do |lib|
      EachInput.new.call(lib) do |input, lib|
        Command.new(input).call(lib)
          .then { |result| ShowOutput.new.call(result) }
        rescue InputError => e; @err_block.(e)
      end
    end
rescue AppError => e; @err_block.(e)
end
```

This *does* follow the same flow as my monkey-patched pipeline. But it is quite verbose, and that is why I made the Pipeful gem.

In any case, the important point is to *think in terms of a pipeline* to see where it could simplify your design.

## 2. … through functions

These pipelines are based on functions, which in Ruby means *callable objects*. Here are some examples, the first of which uses a pipeline of its own.

In `load_library.rb`:

```ruby
module Readstat
  class LoadLibrary
    include Pipeful

    def call(path, &err_block)
      path >>
        ReadSections >>
        ReadLines >>
        Item(&err_block) >>
        Library
    end
  end

  class ReadSections
    def call(path)
      # ...
    end
  end

  class ReadLines
    def call(sections)
      # ...
    end
  end
end
```

In `item.rb`:

```ruby
module Readstat
  class Item
    # ...

    def self.call(parsed_lines, &err_block)
      # create an array of Items from parsed_lines
    end

    # initialize and other methods ...
  end
end
```

In `library.rb`:

```ruby
module Readstat
  class Library
    # ...

    def initialize(items)
      @items = items
    end

    # ...
  end
end
```

Again, a pipeline helps to break down a task into simpler parts: "To load the library, take a given file path, then read its major sections (e.g. *currently reading*, *done reading*, and *want to read*), then parse each section's lines into item data, use that data to make a bunch of Item objects, then throw those into a new Library object. Pass along the error handling process to Item creation (since some missing Item fields should only generate warnings and not fatal errors)."

**NOTE:** The way I've redefined the `>>` operator, there is a chain of precedence for what the operator does with the object after it: `FunctClass.call` or (if that's not defined) `FunctClass.new.call` or (if that's not defined) `FunctClass.new`, in each case passing in the data from the pipe as arguments.

<h2><a id="state-mutation">3. Avoid state mutation</a></h2>

**NOTE:** For fuller treatments of this principle, see [*Object Design Style Guide* Chapter 4](https://livebook.manning.com/book/object-design-style-guide/chapter-4) and [*Unit Testing Principles, Practices, and Patterns* Chapter 6](https://livebook.manning.com/book/unit-testing/chapter-6).

The talks linked earlier do a good job of explaining why an object's state should be immutable wherever possible: if an object's state can be changed, then you can never be sure that its state is what you think it is. And thus bugs are born.

Whenever an object *does* need to be modified, you can often get around it by following Piotr Solnica's advice in the first video above: instead of changing the object's state, add a `with` method which returns a new object with the desired state.

Here's an example. For certain reading statistics, it is necessary to split an Item into smaller one-month parts: for example, calculating the average amount read per day in a given month. If an Item spans multiple months, only the part within the desired month(s) will be counted.

Here is a previous version, with state-mutating bits marked in comments. In the class `Item`:

```ruby
def split_months
  monthly_items = []
  monthly_items << shift_month while multi_month?
  # SELF HAS BEEN MUTATED! 😱
  monthly_items << self
end

# necessary for #dup to work properly
def initialize_copy(orig)
  self.state = orig.state
end

protected

def multi_month?
  date_started.abs_month < date_finished.abs_month
end
# in Date: def abs_month; year * 12 + month; end

# takes the first month out of self, with a new length to match
def shift_month
  end_of_month = Date.new(date_started.year,
                          date_started.month, -1)
  separated = dup
  separated.set_dates(date_started, end_of_month)
  separated.length = length *
    ((end_of_month - date_started).to_f + 1) /
    ((date_finished - date_started).to_f + 1)
  # SELF IS MUTATED! 😱
  self.length = length - separated.length
  # SELF IS MUTATED! 😱
  set_dates(end_of_month + 1, date_finished)
  separated
end
```

You can imagine how this could lead to a bug where the original Item is reused under the natural assumption that it still represents the entire, multi-month Item… an assumption that is sadly incorrect.

You might argue that any self-respecting coder would have avoided this problem from the start, but it was only for the sake of clarity that I chose this obviously problematic example. There are much more elusive ways that state changes can cause bugs.

Here's how I've refactored the above to eliminate unexpected state mutation:

```ruby
def split_months
  monthly_items = []
  remainder = self
  while remainder.multi_month?
    # NO MUTATION 👍
    first_month, remainder = remainder.partition_at_first_month
    monthly_items << first_month
  end
  monthly_items << remainder
end

protected

def multi_month?
  date_started.abs_month < date_finished.abs_month
end

# returns two Items:
# 1. a copy with self's date started and the given date finished (w/ adjusted length)
# 2. the remainder Item
def partition_at_first_month
  end_of_month = Date.new(date_started.year, date_started.month, -1)
  first_length = length *
                  ((end_of_month - date_started).to_f + 1) /
                  ((date_finished - date_started).to_f + 1)
  # NON-MUTATING 👍
  first = with_dates(date_started, end_of_month)
          .with_length(first_length)
  # NON-MUTATING 👍
  remainder = with_dates(end_of_month + 1, date_finished)
              .with_length(length - first.length)
  [first, remainder]
end
```

Here are the `with_x` methods that this refactoring relies on:

```ruby
def with_dates(new_start, new_finish)
  new_state = state({ dates_started: [new_start.dup],
                      dates_finished: [new_finish.dup] })
  self.class.new(new_state)
end

def with_length(new_length)
  new_state = state({ length: new_length })
  self.class.new(new_state)
end
```

And here is how state is defined, extracted, and set (not including validations):

```ruby
def self.fields
  %i[status
    rating
    format
    author
    title
    # ...
    ]
  end
end
fields.each { |field| attr_reader field }

def initialize(args)
  self.state = args
end

# ...

protected

def state=(fields_to_change)
  fields_to_change.each do |k, v|
    instance_variable_set("@#{k}", v)
  end
end

def state(updates = nil)
  copy = fields.map do |field|
    [field, instance_variable_get("@#{field}").dup]
  end.to_h
  updates.nil? ? copy : copy.merge(updates)
end
```

## Conclusion

If, like me, you'd love to learn Haskell *someday*, I hope I've given you some bits of functional programming that you can apply right away. I'm pleased with how these few simple concepts have done so much to clarify my code and (possibly) to prevent bug-induced headaches. On top of that, these functional techniques are concise and lightweight, not creeping over all of my code but ready at hand when I need to simplify a process. Not a bad first step for Baby Functional.

P.S. If you still doubt whether functional techniques can play nice with OOP, hear the words of Sandi Metz, one of OOP's greatest luminaries:

*"I only have a small bit of experience with functional languages, so I don't get to have much of an opinion. I can say, however, that immutability and no side-effects are great ideas, and that I've borrowed them for my OO. My initial goal for every new object I write is that it not change, and that it not have side effects. This obviously can't suit every object, but I've been pleasantly surprised about how much can be done under these constraints, and how much the constraints simplify code."* ([source](https://dev.to/sandimetz/im-sandi-metz-ask-me-anything-4ff9))
