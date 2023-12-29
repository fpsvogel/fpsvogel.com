---
title: Coming to grips with JS
subtitle: a Rubyist's deep dive
description: Follow along as a Rubyist thoroughly learns JavaScript, from the language itself to practice/projects, functional JS, and Web APIs like web components.
---

- [Why JavaScript?](#why-javascript)
- [The learning resources](#the-learning-resources)
- [Learning JS, re-learning Ruby](#learning-js-re-learning-ruby)
  - [Object destructuring](#object-destructuring)
  - [Object literals](#object-literals)
- [A word on JS frameworks](#a-word-on-js-frameworks)

tl;dr I'm systematically learning JS using [these resources](https://github.com/fpsvogel/learn-ruby#js).

## Why JavaScript?

Because it's inescapable in web development.

Sure, you can use any number of JS-avoidance libraries. I'm a fan of [Turbo](https://turbo.hotwired.dev/), but there's also [htmx](https://htmx.org/), [Unpoly](https://unpoly.com/), [Alpine](https://alpinejs.dev/), [swup](https://swup.js.org/), [barba.js](https://barba.js.org/), [hyperscript](https://hyperscript.org/), and probably others.

Then there are stack-specific libraries: [StimulusReflex](https://docs.stimulusreflex.com/) for Rails, [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view), [Laravel Livewire](https://laravel-livewire.com/), [Django Unicorn](https://www.django-unicorn.com/), [Django Tetra](https://www.tetraframework.com/), [.NET Blazor](https://dotnet.microsoft.com/en-us/apps/aspnet/web-apps/blazor), … and the list goes on.

You get the picture. Lots of people would rather not build a JS front end.

I myself avoided the JS ecosystem a few years ago when it would have been the default choice for me as a beginning second-career developer. I was going the self-taught route, so **I needed an ecosystem with strong conventions**. I didn't know how to choose from a dozen popular frameworks, and within each of them countless decisions to be made about how to put together an app.

It was in the Ruby ecosystem that I found the conventions I needed. Plus, Ruby was (and is) more enjoyable to write.

But now I know enough to circle back and learn JS seriously.

Not that I can't get around in JS. At my last job, I was comfortable building full-stack features in Rails and React.

Oh, and speaking of *my last job*—recently I was laid off, as part of a 44% reduction in force. (And that was after a 25% RIF earlier this year.)

Being unemployed and seeing so many jobs involving a JS front end… well, that gives me extra motivation to get serious about JS.

## The learning resources

I'm using the resources in [the "JS" section](https://github.com/fpsvogel/learn-ruby#js) of my learning road map. [Here's how that section looks at the time of writing](https://github.com/fpsvogel/learn-ruby/tree/239a86362fb94c5c074fb1e44d7e1fdd75286ff7#js); the latest version may have evolved from that.

Besides a comprehensive look at JS syntax, I made sure to include a few other areas:

- **Guided practice** and projects, to turn *knowledge* into *skills*.
- **Web APIs**, especially the DOM, forms, and web components.
- **Deep dives** into how JS works, and the rationale behind its quirks.
- **Functional JS**, because I'm interested in functional programming. I recently [started learning Haskell](/posts/2023/rubyist-learns-haskell-getting-started), but JS will be useful as an example of how to apply functional concepts in a not-really-functional language.

## Learning JS, re-learning Ruby

Interestingly, learning JS has helped me re-learn Ruby features that I rarely use. Here are two examples.

### Object destructuring

In JS:

```js
const obj = { first: "Willard", middle: "Wilbur", last: "Wonka" }
const { first, last } = obj
```

Did you know Ruby can do something similar with hash destructuring?

```ruby
obj_hash = { first: "Willard", middle: "Wilbur", last: "Wonka" }
obj_hash => { first:, last: } # `=>` is the rightward assignment operator.
```

This is thanks to Ruby's pattern matching, which is actually a lot more flexible than JS destructuring. (For more complex examples, see ["Everything You Need to Know About Destructuring in Ruby 3"](https://www.fullstackruby.dev/ruby-3-fundamentals/2021/01/06/everything-you-need-to-know-about-destructuring-in-ruby-3).)

Note, however, that there is [a proposal to add pattern matching to JS](https://github.com/tc39/proposal-pattern-matching).

### Object literals

In JS:

```js
const obj = {
  first: "Willard",
  last: "Wonka",
  full() {
    return `${this.first} ${this.last}`;
  },
}
```

In Ruby, every object has a class, so there's no concise way to define a one-off object, right?

My first attempt was to add a method to an `OpenStruct`:

```ruby
require "ostruct"

# Doesn't work as intended! The `obj#full` method doesn't exist.
obj = OpenStruct.new(first: "Willard", last: "Wonka") do
  def full = "#{first} #{last}"
end
```

It turns out this only works with a `Struct`:

```ruby
Person = Struct.new(:first, :last) do
  def full = "#{first} #{last}"
end

obj = Person.new(first: "Willard", last: "Wonka")
```

But this is more like an explicit class definition, than a JS-style one-off object.

OK, then how about we expand `OpenStruct` to do something with that block?

```ruby
require "ostruct"

class OpenStruct
  def self.create_with_methods(**kwargs, &methods)
    open_struct = new(**kwargs)
    open_struct.instance_eval(&methods)

    open_struct
  end

  # Add a shortcut syntax.
  class << self
    alias_method :[], :create_with_methods
  end
end

# Or, OpenStruct.create_with_methods(...)
obj = OpenStruct[first: "Willard", last: "Wonka"] do
  def full = "#{first} #{last}"
end
```

This still doesn't look as uniform as JS object literals. That's because **it goes against the grain of Ruby**, where classes play a central role, as distinct from instances of them. In JS, "classes" are syntactic sugar, and *individual objects* underlie the object model to a greater extent than in Ruby.

But we shouldn't overstate the difference: the JS object model is actually similar to Ruby's in many ways, in how dynamic both of them are. This makes Ruby-to-JS compilers like [Opal](https://opalrb.com/) easier to implement, [according to an Opal maintainer](https://www.reddit.com/r/ruby/comments/146damh/comment/jnqqe8u).

So, learning more JS has given me a deeper appreciation of both JS and Ruby. JS for the ingeniously simple idea behind its object model, and Ruby… for everything else 😁

## A word on JS frameworks

You may be wondering why my learning plan doesn't include any JS frameworks. No React deep dives? Not even the more hip Vue or Svelte??

I do plan on familiarizing myself with popular front-end frameworks, including the parts of React that I haven't used.

But I'd rather focus on JS itself, as well as official standards like web components, because I feel that's a more worthwhile investment. JS frameworks come and go, whereas JS the language and Web APIs change more slowly.
