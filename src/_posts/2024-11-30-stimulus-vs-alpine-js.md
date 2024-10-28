---
title: Alpine.js as a Stimulus alternative
subtitle: JS sprinkles without the tedious DOM manipulation
description: Alpine.js is like Stimulus plus declarative templating, and can be a better choice if you're willing to use an ecosystem other than Hotwire.
---

- [The context](#the-context)
- [Stimulus is incomplete on its own](#stimulus-is-incomplete-on-its-own)
- [Alpine.js](#alpinejs)
- [Examples of Stimulus vs. Alpine](#examples-of-stimulus-vs-alpine)
  - [Example 1: toggle menu](#example-1-toggle-menu)
  - [Example 2: filterable list](#example-2-filterable-list)
- [But what if I need Turbo?](#but-what-if-i-need-turbo)
- [Conclusion](#conclusion)

Recently I discovered [Alpine.js](https://alpinejs.dev/) as an alternative to [Stimulus](https://stimulus.hotwired.dev/) for conveniently sprinkling JavaScript into a server-rendered website—and it may even be a *better* alternative.

## The context

At my job, I work on a fairly vanilla Rails app. One of its oddities, though, is that it uses [Stimulus](https://stimulus.hotwired.dev/) but not [Turbo](https://turbo.hotwired.dev/). The two are sibling libraries in the [Hotwire](https://hotwired.dev/) suite.

One reason for Turbo's absence is that before my team was formed earlier this year, the customer-facing part of the app hadn't been seriously worked on in a few years. Back then, Turbo either wasn't released yet or was brand new.

What about Turbo's predecessor [Turbolinks](https://github.com/turbolinks/turbolinks)? It's not in the app either, at least not anymore. A Git log search ([`git log -S`](https://git-scm.com/docs/git-log#Documentation/git-log.txt--Sltstringgt)) reveals that the developers back in 2016 removed it, with commit messages like `Get your stupid Turbolinks outta my house` 😂

Whatever the historical reasons, the point is that Stimulus is currently our only tool for creating real-time UI functionality, **and it hurts**.

## Stimulus is incomplete on its own

My gripe with Stimulus is that **it's imperative, not declarative.** In most modern JS front-end libraries (React, Vue, Lit, etc.), you have a template that is automatically re-rendered based on changes to state that's stored in JS. But in Stimulus, as in jQuery or vanilla JS, state is stored in the DOM, and you have to manually change the DOM in response to events. It gets tedious fast.

But here's the thing: Stimulus was *intentionally* designed this way so that would work well alongside Turbo. To quote the [Stimulus Handbook](https://stimulus.hotwired.dev/handbook/origin#how-stimulus-differs-from-mainstream-javascript-frameworks):

> Stimulus also differs on the question of state. Most frameworks have ways of maintaining state within JavaScript objects, and then render HTML based on that state. Stimulus is the exact opposite. State is stored in the HTML, so that controllers can be discarded between page changes *[such as HTML fragments morphed in via Turbo]*, but still reinitialize as they were when the cached HTML appears again.

In other words, Stimulus discourages storing state in JS because that state disappears whenever an element with an attached Stimulus controller is replaced by Turbo.

Consequently, **Stimulus wasn't designed for building elaborate front-end features**. Turbo does the heavy lifting, and Stimulus handles the leftover bits: small, generic components or behaviors. See the examples in the Stimulus Handbook ([a copy button](https://stimulus.hotwired.dev/handbook/building-something-real#implementing-a-copy-button) and [a slideshow](https://stimulus.hotwired.dev/handbook/managing-state#building-a-slideshow)), advice in articles on Stimulus ([1](https://thoughtbot.com/blog/taking-the-most-out-of-stimulus#prefer-general-purpose-controllers), [2](https://boringrails.com/articles/better-stimulus-controllers/#what-may-go-wrong)), and [open-source Stimulus controllers](https://www.stimulus-components.com/).

… But like I said, we don't use Turbo at work. In addition to the historical reasons I mentioned earlier, we heavily use web components from our in-house design system in a way that Turbo (with its server-centric mindset) would be an awkward fit. I thought a better starting point would be to find a "JS sprinkles" library that is more capable on its own than Stimulus.

## Alpine.js

[Alpine.js](https://alpinejs.dev/) is similar to Stimulus in a couple of ways:

- **It's small.** The bundle sizes of Stimulus and Alpine, respectively, are [10.9 kB](https://bundlephobia.com/package/stimulus@3.2.2) and [15.2 kB](https://bundlephobia.com/package/alpinejs@3.14.3).
- **It's SSR-friendly.** Both Alpine and Stimulus are used in server-rendered templates via special HTML attributes.

Unlike Stimulus, Alpine:

- **Is fundamentally declarative.** Alpine’s HTML attributes allow a declarative style (such as [`x-show`](https://alpinejs.dev/directives/show) to conditionally show an element, and [`x-bind`](https://alpinejs.dev/directives/bind) to set an HTML attribute from JS), while Stimulus’s HTML attributes are limited to an imperative approach based on responding to events.
- **Can be written inline—*but doesn’t have to!*** Almost all of the examples in the Alpine docs have the JS written inline in the HTML attributes. But as we’ll see in the examples below, the JS can be put in its own separate file just as in Stimulus.

Regarding this second point, some other comparisons of Stimulus and Alpine ([1](https://buttondown.com/bhumi/archive/what-is-alpinejs-and-how-does-it-compare-to/), [2](https://www.youtube.com/watch?v=W8RrkW1ooGY)) claim that Alpine lacks structure because of its use of inline JS, and consequently doesn't scale well in bigger projects. This doesn't *have* to be true! Again, the JS can be put in a separate file just as in Stimulus.

In fact, you can use Alpine in a way extremely similar to Stimulus. Using the mappings below, you can write JS with Alpine that looks the same as Stimulus, apart from the different names for things:

- [`x-ref`](https://alpinejs.dev/directives/ref) is like Stimulus [targets](https://stimulus.hotwired.dev/reference/targets)
- [`x-on`](https://alpinejs.dev/directives/on) is like Stimulus [actions](https://stimulus.hotwired.dev/reference/actions)
- Where Stimulus has [lifecycle callbacks](https://stimulus.hotwired.dev/reference/lifecycle-callbacks), Alpine has these:
  - [`init()`](https://alpinejs.dev/globals/alpine-data#init-functions) is like Stimulus `connect()` and `[name]TargetConnected()`.
  - [`destroy()`](https://alpinejs.dev/globals/alpine-data#destroy-functions) is like Stimulus `disconnect()` and `[name]TargetDisconnected()`.
  - A plain `constructor()` in an Alpine data class is like Stimulus `initialize()`.
- I've never used Stimulus [outlets](https://stimulus.hotwired.dev/reference/outlets), so I can't confidently say whether they can be emulated in Alpine. But you probably wouldn't need them.
- Plain data attributes can stand in for Stimulus [values](https://stimulus.hotwired.dev/reference/values). Or if data attributes become cumbersome, see my examples below for an `x-props` custom directive in Alpine.
- [`x-bind`](https://alpinejs.dev/directives/bind#binding-styles) for Stimulus [CSS classes](https://stimulus.hotwired.dev/reference/css-classes).

So Alpine is more or less a superset of Stimulus. The benefit it offers over Stimulus is that instead of being limited to granular DOM manipulation, as in *"on X event add a 'hidden' class to elements A and B, on Y event remove the 'hidden' class from elements A and B"*, Alpine has allow a declarative style, as in *"show elements A and B if Z is true"* (see [`x-show`](https://alpinejs.dev/directives/show)).

**This shift from imperative to declarative style can make your JS so much more readable, maintainable, and bug-resistant.** As an experiment, at work I did a Stimulus-to-Alpine conversion of an "Edit Mailing Address" form built around an in-house web component for address autocomplete. I was shocked at the difference:

- The Stimulus controller was **207 lines long**, filled with logic that was difficult for me to follow even though I'd written it myself just a few weeks ago—and writing it had been a nightmare of continually finding yet another bug in my code.
- The JS class for the Alpine component was **only 60 lines long**, easier to write, and actually possible to understand at a glance.

## Examples of Stimulus vs. Alpine

The blog post ["Alpine.js vs Stimulus"](https://brianschiller.com/blog/2021/11/05/alpine-stimulus-js/) by Brian Schiller compares two examples in Stimulus and Alpine. Rather than making up my own new examples here, I'll just link to those and add on an alternate Alpine version of each that keeps the JS out of the HTML.

In my versions of the examples, I used [the CSP build of Alpine](https://alpinejs.dev/advanced/csp), where inline JS is actually impossible. This nicely serves as a form of no-inline-JS linting, but it does introduce some minor inconveniences, including:

- Passing [initial parameters](https://alpinejs.dev/globals/alpine-data#initial-parameters) into a data object is impossible. No big deal: you can just use data attributes or (if that becomes clunky) a custom `x-props` directive, which you can see in my second example below, near the bottom of the JS.
- [`x-model`](https://alpinejs.dev/directives/model) doesn't work in the CSP build. The workaround is to use the two directives that `x-model` is a shortcut for: instead of `<input x-model:"myProperty">`, use `<input :value="myProperty" @input="setMyProperty">`. `:value` is short for `x-bind:value` ([docs](https://alpinejs.dev/directives/bind)), and `@input` is short for `x-on:input` ([docs](https://alpinejs.dev/directives/on)). This workaround makes an appearance in my second example below.

### Example 1: toggle menu

This is Brian Schiller's second example, but I'm putting it first because it's the simpler of the two.

- Brian's Stimulus version: [CodePen](https://codepen.io/bgschiller/pen/jOLLNpj), [Brian's notes](https://brianschiller.com/blog/2021/11/05/alpine-stimulus-js/#stimulus-1)
- Brian's Alpine version: [CodePen](https://codepen.io/bgschiller/pen/WNEzvLj), [Brian's notes](https://brianschiller.com/blog/2021/11/05/alpine-stimulus-js/#alpinejs-1)
- My Alpine CSP version: [CodePen](https://codepen.io/fpsvogel/pen/dyxdVoz)

**My notes:** The HTML is cleanest with Alpine CSP, and the JS file is still super short.

### Example 2: filterable list

- Brian's Stimulus version: [CodePen](https://codepen.io/bgschiller/pen/YzxQoPj), [Brian's notes](https://brianschiller.com/blog/2021/11/05/alpine-stimulus-js/#stimulus)
- Brian's Alpine version: [CodePen](https://codepen.io/bgschiller/pen/LYjdEzj), [Brian's notes](https://brianschiller.com/blog/2021/11/05/alpine-stimulus-js/#alpinejs)
- My Alpine CSP version: [CodePen](https://codepen.io/fpsvogel/pen/xxvYEdb)

**My notes:**

- Once again the HTML is cleanest with Alpine CSP, but the JS file is not so satisfyingly short this time. One reason is that I threw in the `x-props` custom Alpine directive, not because it was needed but just for the sake of example.
- I didn't love that I had to pull in an extra package to access a parent component's data.

## But what if I need Turbo?

Earlier I pointed out that Stimulus is designed as it is in order to be compatible with [Turbo](https://turbo.hotwired.dev/). Does that mean you can't use Alpine with Turbo?

Yes and no. If you've already built your app using Stimulus and Turbo, it might not make sense to switch from Stimulus to Alpine. Turbo is probably handling most of the real-time interactivity anyway.

But if all you want is *something like Turbo*, i.e. a way to take HTML fragments sent from the server and morph them into the page, here are Alpine-friendly options for you:

- [htmx](https://htmx.org/), which has an [alpine-morph](https://v1.htmx.org/extensions/alpine-morph/) extension.
- [Alpine AJAX](https://alpine-ajax.js.org/) has [a similar morph feature](https://alpine-ajax.js.org/reference/#morphing).

I'd probably pick Alpine AJAX, but more importantly *I wouldn't reach for morphing without considering other approaches first*, because morphing is complex and has limitations and edge cases. For example:

- [a critique of htmx](https://chrisdone.com/posts/htmx-critique/#most-interesting-web-apps-cannot-replace-wholesale-a-dom-element) and [the htmx author's reply](https://news.ycombinator.com/item?id=41782094) that it's a work in progress
- [a similar critique of Turbo](https://thomascannon.me/guides/fixing-the-rails-networking-stack#turbo-adds-excessive-complexity-and-reimplements-the-browser)

## Conclusion

I'll piggyback on Brian's post one more time and repeat its conclusion here:

> I can enthusiastically choose Alpine over Stimulus. Stimulus seems to have skipped the lessons of the past 7-8 years. It’s better than jQuery, but ignores the things that are good about React, Vue, etc: reactivity and declarative rendering. Meanwhile, Alpine manages to pack a ton of useful functionality into a smaller bundle size than Stimulus.

Alpine's bundle size has now grown slightly larger than that of Stimulus, but otherwise I wholeheartedly agree with that conclusion.

And I'll add this: for anyone who is concerned about the maintainability of inline JS in HTML and prefers clean markup, a clear separation of concerns, TypeScript, etc. … **you can do all that with Alpine!** I think Alpine is the best of both worlds, between "all-in" JS frameworks that handle rendering (React et al.) and vanilla JS: declarative and template-friendly like React et al., but at the same time, simple and usable in any SSR web framework.
