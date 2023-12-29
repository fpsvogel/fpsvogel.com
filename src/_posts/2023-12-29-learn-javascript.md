---
title: Coming to grips with JS
subtitle: a Rubyist's deep dive
description: Follow along as a Rubyist thoroughly learns JavaScript, from the language itself to practice/projects, functional JS, and Web APIs like web components.
---

- [Why?](#why)
- [How?](#how)
- [A word on JS frameworks](#a-word-on-js-frameworks)
- [Learning JS, re-learning Ruby](#learning-js-re-learning-ruby)
  - [Object destructuring](#object-destructuring)
  - [Object literals](#object-literals)

tl;dr I'm systematically learning JavaScript using [these resources](#how).

## Why?

Because JS is inescapable in web development.

Sure, you can use any number of JS-avoidance libraries. I'm a fan of [Turbo](https://turbo.hotwired.dev/), and there's also [htmx](https://htmx.org/), [Unpoly](https://unpoly.com/), [Alpine](https://alpinejs.dev/), [hyperscript](https://hyperscript.org/), [swup](https://swup.js.org/), [barba.js](https://barba.js.org/), and probably others.

Then there are stack-specific libraries: [StimulusReflex](https://docs.stimulusreflex.com/) for Rails, [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view), [Laravel Livewire](https://laravel-livewire.com/), [Unicorn](https://www.django-unicorn.com/) and [Tetra](https://www.tetraframework.com/) for Django, [Blazor](https://dotnet.microsoft.com/en-us/apps/aspnet/web-apps/blazor) for .NET, … and the list goes on.

You get the picture. Lots of people would rather not build a JS front end.

I myself avoided the JS ecosystem a few years ago when it would have been the default path for me as a beginning second-career developer. But I was going the self-taught route, so **I needed an ecosystem with strong conventions**. I didn't know how to choose from a dozen popular JS frameworks. And none of them is an all-in-one, "batteries-included" framework, so it looked like I'd need to make many decisions about how to put together an app, which would mean (for me at that time, as a beginner who lacked context) **lots of frustration and stabbing in the dark**.

It was in the Ruby world that I found the conventions I needed. Plus, I found (and still find) Ruby to be more enjoyable.

But **now I've had enough web development experience** that I can circle back and learn JS thoroughly, confidently, and without wasting as much time on rabbit trails.

Not that I can't get around in JS. At my last job, I was comfortable building full-stack features in Rails and React.

Oh, and speaking of *my last job*—recently I was laid off as part of a massive reduction in force. (Stay tuned for a future post on my job search and what I'm learning from it.)

Being unemployed and **seeing so many jobs involving a JS front end**—that's ultimately what gave me the push I needed to get serious about JS.

That's what I mean when I say JS is "inescapable": not that we can't build anything without it—in fact, I quite enjoy making sites with minimal JS and plenty of dynamic interactivity. I only mean that **JS skills are mandatory for someone like me** who has only a few years of experience, and therefore fewer job options. Even if I *could* find a backend-only position (which is doubtful), I'm not sure I want to pigeonhole myself like that. Plus, I really do enjoy full-stack development.

## How?

I'm using the resources listed below. Almost all are free. Besides a comprehensive look at JS syntax, I made sure to include a few other areas:

- **Guided practice** and projects, to turn *knowledge* into *skills*.
- **Web APIs**, especially the DOM, forms, and web components.
- **Deep dives** into how JS works, and the rationale (or at least reasons) behind its quirks.
- **Functional JS**, because I'm interested in functional programming. I recently [started learning Haskell](/posts/2023/rubyist-learns-haskell-getting-started), but JS will be useful as an example of how to apply functional concepts in a not-really-functional language.

There's *a lot* in the bottom two-thirds of the list, only because I haven't gone through it yet and weeded out the less-than-awesome resources.

Also, note that this list is copied straight from [the "JS" section of my learning road map](https://github.com/fpsvogel/learn-ruby#js), and the latest version may have evolved from what you see here.

- **Basics:**
  - [JavaScript for impatient programmers](https://exploringjs.com/impatient-js/)
  - [Modern JavaScript Explained For Dinosaurs](https://peterxjang.com/blog/modern-javascript-explained-for-dinosaurs.html)
  - [What the heck is the event loop anyway?](https://youtube.com/watch?v=8aGhZQkoFbQ)
  - [MDN - JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
  - [lodash](https://lodash.com) and [You Might Not Need Lodash](https://youmightnotneed.com/lodash/)
- **Practice:**
  - [Exercism - JavaScript](https://exercism.org/tracks/javascript)
  - [JavaScript30](https://javascript30.com/)
- **DOM and forms:**
  - [The Modern JavaScript Tutorial - Browser: Document, Events, Interfaces](https://javascript.info/ui)
  - [MDN - Web forms](https://developer.mozilla.org/en-US/docs/Learn/Forms)
  - [web.dev - Learn Forms](https://web.dev/learn/forms)
- **Going deeper:**
  - [You Don't Know JS](https://github.com/getify/You-Dont-Know-JS)
  - [Deep JS](https://exploringjs.com/deep-js/toc.html)
  - [JavaScript: Understanding the Weird Parts](https://www.udemy.com/course/understand-javascript/)
  - [Just JavaScript](https://justjavascript.com/)
- **Functional JS:**
  - [Functional-Light JS](https://github.com/getify/Functional-Light-JS)
  - [Professor Frisby's Mostly Adequate Guide to Functional Programming](https://mostly-adequate.gitbook.io/mostly-adequate-guide/)
  - [JavaScript Allongé](https://leanpub.com/javascriptallongesix/read)
  - [Functional programming in JavaScript](https://www.youtube.com/playlist?list=PL0zVEGEvSaeEd9hlmCXrk5yUyqUag-n84) videos
  - [Mastering JavaScript Functional Programming](https://www.packtpub.com/product/mastering-javascript-functional-programming/9781839213069)
- **Web components:**
  - [Rob Eisenberg - "Hello Web Components"](https://eisenbergeffect.medium.com/hello-web-components-795ed1bd108e)
  - [Dave Rupert - HTML with Superpowers: The Guidebook](https://daverupert.com/2023/01/html-with-superpowers-the-guidebook/) or [the course version](https://frontendmasters.com/courses/web-components/)
  - [MDN - Web Components](https://developer.mozilla.org/en-US/docs/Web/API/Web_components)
  - [The Modern JavaScript Tutorial - Web Components](https://javascript.info/web-components)
  - [Web Components Today](https://webcomponents.today/)
  - Build a UI following [Jared White - How Ruby and Web Components Can Work Together](https://www.fullstackruby.dev/fullstack-development/2022/01/04/how-ruby-web-components-work-together/)
  - SSR web components in Ruby with the upcoming [Heartml](https://heartml-docs.onrender.com/) (see [this Spicy Web article](https://www.spicyweb.dev/web-components-ssr-node/) for context)
  - Experiment using [Turbo](https://turbo.hotwired.dev/) to drive front-end behavior: *"Turbo 7.2.0 (currently in beta) allows you to define your own Stream actions which can be any JS code you want. By combining a custom Stream action or two with web components, you can essentially drive reactive frontend behavior from the backend stupidly easily. Loooove it! 😍 […] For a turnkey example, you could check out https://github.com/hopsoft/turbo_ready "* —Jared White on [The Spicy Web](https://discord.com/channels/811491992285741077/811493083068760104/1019024338042761297) Discord

## A word on JS frameworks

You may be wondering why my learning plan doesn't include any JS frameworks. No React deep dives? Not even the more hip Vue or Svelte??

I do plan on familiarizing myself with popular front-end frameworks, including the parts of React that I haven't used. Learning the patterns that are common across frameworks will be valuable, I think.

But if there's anything I focus on, I want it to be JS itself (along with other web standards) because they're a more durable investment, changing more slowly than JS frameworks.

## Learning JS, re-learning Ruby

Readers who aren't into Ruby can feel free to leave now (it's OK, I won't feel bad), but I wanted to conclude by showing how **learning JS has helped me re-learn Ruby features that I rarely use**. Here are two examples.

### Object destructuring

In JS:

```js
const obj = { first: "Willard", middle: "Wilbur", last: "Wonka" }
const { first, last } = obj
```

Did you know Ruby can do something similar with hash destructuring?

```ruby
obj_hash = { first: "Willard", middle: "Wilbur", last: "Wonka" }
# `=>` is the rightward assignment operator.
obj_hash => { first:, last: }
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

My first attempt to prove this wrong was to add a method to an `OpenStruct`:

```ruby
require "ostruct"

obj = OpenStruct.new(first: "Willard", last: "Wonka") do
  def full = "#{first} #{last}"
end

# Uh oh, that didn't work as intended!
# The `#full` method isn't actually defined.
obj.full
# => nil
```

It turns out this only works with a `Struct`:

```ruby
Person = Struct.new(:first, :last) do
  def full = "#{first} #{last}"
end

obj = Person.new(first: "Willard", last: "Wonka")

obj.full
# => "Willard Wonka"
```

But now we're nearly in the territory of an explicit class definition, far from a JS-style one-off object.

OK, then just for fun, how about we expand `OpenStruct` so that it actually does something with that block?

```ruby
require "ostruct"

class OpenStruct
  def self.create_with_methods(**kwargs, &methods)
    open_struct = new(**kwargs)
    open_struct.instance_eval(&methods)

    open_struct
  end

  # Now add a shortcut syntax.
  class << self
    alias_method :[], :create_with_methods
  end
end

# Or, OpenStruct.create_with_methods(...)
obj = OpenStruct[first: "Willard", last: "Wonka"] do
  def full = "#{first} #{last}"
end
```

This still doesn't look as uniform as JS object literals, and performance-wise I'm sure Ruby is not optimized for this sort of object. That's because **it goes against the grain of Ruby**, where *classes* play a central role, as distinct from *instances* of them. In JS, with its prototype-based object model, "classes" are syntactic sugar, and *individual objects* are more central than in Ruby. (On how and why this is so, it's helpful to [read about JS's early history](https://auth0.com/blog/a-brief-history-of-javascript/).)

But we shouldn't overstate the difference: the JS and Ruby object models are actually similar in how dynamic both of them are. This makes Ruby-to-JS compilers like [Opal](https://opalrb.com/) easier to implement, [according to an Opal maintainer](https://www.reddit.com/r/ruby/comments/146damh/comment/jnqqe8u).

In the end, learning more JS has given me a deeper appreciation of both JS *and* Ruby: JS for the ingeniously simple idea behind its object model, and Ruby… for everything else 😄
