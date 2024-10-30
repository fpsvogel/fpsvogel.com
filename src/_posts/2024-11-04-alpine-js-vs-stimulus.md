---
title: Alpine.js as a Stimulus alternative
subtitle: how to avoid inline JS with Alpine CSP
description: Alpine.js, with its declarative templating, is more capable than Stimulus but can be used similarly, with JS in separate files and not inline in the HTML.
---

- [First, the context](#first-the-context)
- [Why not Turbo?](#why-not-turbo)
- [Why not web components?](#why-not-web-components)
- [Stimulus is incomplete on its own](#stimulus-is-incomplete-on-its-own)
- [Alpine.js](#alpinejs)
  - [Alpine is like Stimulus!](#alpine-is-like-stimulus)
  - [Alpine is NOT like Stimulus!](#alpine-is-not-like-stimulus)
- [Examples](#examples)
  - [Example 1: toggle menu](#example-1-toggle-menu)
  - [Example 2: filterable list](#example-2-filterable-list)
- [But what if I need Turbo?](#but-what-if-i-need-turbo)
- [Conclusion](#conclusion)
- [Bonus: Alpine plugins](#bonus-alpine-plugins)

Recently I discovered [Alpine.js](https://alpinejs.dev/) as an alternative to [Stimulus](https://stimulus.hotwired.dev/) for conveniently sprinkling JavaScript into server-rendered pages—and it may even be a *better* alternative.

You may know of Alpine as that little JS library where you write inline JS in the HTML—*ewww!* That's all I knew about it too.

But it turns out that you can put the JS in separate files, as in Stimulus, and you can even *prohibit* inline JS with the [Alpine CSP build](https://alpinejs.dev/advanced/csp). But I'm getting ahead of myself…

## First, the context

At my job, I work on a fairly vanilla Rails app. One of its oddities, though, is that it uses [Stimulus](https://stimulus.hotwired.dev/) and not [Turbo](https://turbo.hotwired.dev/), its sibling library in the [Hotwire](https://hotwired.dev/) suite.

Below I go into why we don't use Turbo, but the point here is that Stimulus is currently our only tool for creating real-time UI functionality, **and it hurts**. No one at work really likes Stimulus, I think because we're expecting too much from it and using it in ways it wasn't designed for. (More on that below.)

Some teams are pushing to migrate the app to Angular. I'm doubtful whether that would be worth the effort, so I'm looking into Alpine to see if it would give us some of the conveniences of a framework like Angular, but without the huge migration and added complexity.

## Why not Turbo?

I mentioned that our app at work doesn't use Turbo. A Git log search ([`git log -S`](https://git-scm.com/docs/git-log#Documentation/git-log.txt--Sltstringgt)) reveals that the developers back in 2016 removed Turbo's predecessor [Turbolinks](https://github.com/turbolinks/turbolinks) from the app, with commit messages like `Get your stupid Turbolinks outta my house` 😂

Then, starting around the time Turbo was released in 2020, teams were rearranged and the customer-facing part of the app stopped being seriously worked on, until my team was formed earlier this year. During that interval, there wasn't much impetus to look for something better than just Stimulus.

Also, we heavily use Lit web components from our in-house design system in a way that Turbo (with its server-centric mindset) would be an awkward fit. It's easier for us to use a JS library that plays nicely with web components by operating on the client side, as Stimulus does.

## Why not web components?

The previous paragraph begs the question, *Why not just build your features in Lit?*

It's because I, along with the rest of my team, enjoy keeping Rails view templates server-side. Let's say I want to add real-time behavior to a view: if I have to move an ERB template into a Lit component and translate it into JS, it feels like I've left the realm of "JS sprinkles" and now it's more like "JS chunks".

If that feels like a meaningless distinction to you, and if you find Lit components to be perfectly usable in day-to-day feature work, then **go ahead and use Lit instead of Stimulus or Alpine!** I honestly wish I didn't feel as much friction as I do when making Lit components, because Lit is probably the more durable option since it's closer to web standards than Alpine.

Who knows, maybe in a few months I'll write a post titled *"Web components as an Alpine.js alternative"* 😂 I've seen efforts underway to more easily server-render web components (and not just in Node), so it may someday be possible to declare a web component within a server-side template such as ERB, using regular HTML with special attributes for the dynamic bits. In fact, I was looking for such an approach to web components when I ran across a comment saying *that's precisely what Alpine does*, minus the web components part.

<!-- For the future "Web components as an Alpine.js alternative" post, review replies that I got on The Spicy Web about my feelings about web components: https://discord.com/channels/811491992285741077/811492754218942494/1301189020402843701 -->

All that to say, my thoughts below are subject to change when web components become easier for this use case focused on non-Node SSR, or "keep your templates and sprinkle in dynamic behavior".

## Stimulus is incomplete on its own

My gripe with Stimulus is that **it's imperative, not declarative.** In most modern JS front-end libraries (React, Angular, Lit, etc.), you have a template that is automatically re-rendered based on changes to state that's stored in JS. But with Stimulus, as with jQuery, state is expected to be stored in the DOM, and you have to manually change the DOM in response to events. It gets tedious fast.

But here's the thing: Stimulus was *intentionally* designed this way so that it would work well alongside Turbo. To quote the [Stimulus Handbook](https://stimulus.hotwired.dev/handbook/origin#how-stimulus-differs-from-mainstream-javascript-frameworks):

> Stimulus also differs on the question of state. Most frameworks have ways of maintaining state within JavaScript objects, and then render HTML based on that state. Stimulus is the exact opposite. State is stored in the HTML, so that controllers can be discarded between page changes *[such as HTML fragments morphed in via Turbo]*, but still reinitialize as they were when the cached HTML appears again.

In other words, Stimulus discourages storing state in JS because that state disappears whenever an element with an attached Stimulus controller is replaced by Turbo.

Consequently, **Stimulus wasn't designed for building elaborate front-end features**. Turbo does the heavy lifting, and Stimulus handles the leftover bits: small, generic components or behaviors. See the examples in the Stimulus Handbook ([a copy button](https://stimulus.hotwired.dev/handbook/building-something-real#implementing-a-copy-button) and [a slideshow](https://stimulus.hotwired.dev/handbook/managing-state#building-a-slideshow)), advice in articles on Stimulus ([1](https://thoughtbot.com/blog/taking-the-most-out-of-stimulus#prefer-general-purpose-controllers), [2](https://boringrails.com/articles/better-stimulus-controllers/#what-may-go-wrong)), and [open-source Stimulus controllers](https://www.stimulus-components.com/).

… But we don't use Turbo at work, and for the reasons I gave earlier it would be complicated to use Turbo in our app. So I thought a better starting point would be to find a "JS sprinkles" library that's more capable on its own than Stimulus.

## Alpine.js

### Alpine is like Stimulus!

[Alpine.js](https://alpinejs.dev/) is similar to Stimulus in several ways:

- **It's small.** The bundle sizes of Stimulus and Alpine, respectively, are [10.9 kB](https://bundlephobia.com/package/stimulus@3.2.2) and [15.2 kB](https://bundlephobia.com/package/alpinejs@3.14.3).
- **It's SSR-friendly.** Both Alpine and Stimulus are used in server-rendered templates via special HTML attributes.
- **The JS *can* be in separate files.** This isn't obvious from the Alpine docs, where almost all of the examples have JS written inline in HTML attributes. But as we’ll see in the examples below, the JS can be put in its own separate files just as in Stimulus.
  - Because of Alpine's use of inline JS by default, some other comparisons of Stimulus and Alpine ([1](https://buttondown.com/bhumi/archive/what-is-alpinejs-and-how-does-it-compare-to/), [2](https://www.youtube.com/watch?v=W8RrkW1ooGY)) claim that Alpine lacks structure, and consequently doesn't scale well in bigger projects. But this doesn't *have* to be true!

In fact, you can use Alpine in a way very similar to Stimulus. Using the mappings below, you can write JS with Alpine that looks the same as Stimulus, apart from different syntax and naming:

- [`x-ref`](https://alpinejs.dev/directives/ref) is like Stimulus [targets](https://stimulus.hotwired.dev/reference/targets)
- [`x-on`](https://alpinejs.dev/directives/on) is like Stimulus [actions](https://stimulus.hotwired.dev/reference/actions)
- Where Stimulus has [lifecycle callbacks](https://stimulus.hotwired.dev/reference/lifecycle-callbacks), Alpine has these:
  - [`init()`](https://alpinejs.dev/globals/alpine-data#init-functions) is like Stimulus `connect()` and `[name]TargetConnected()`.
  - [`destroy()`](https://alpinejs.dev/globals/alpine-data#destroy-functions) is like Stimulus `disconnect()` and `[name]TargetDisconnected()`.
  - A plain `constructor()` in an Alpine data class is like Stimulus `initialize()`.
- I've never used Stimulus [outlets](https://stimulus.hotwired.dev/reference/outlets), so I can't confidently say whether they can be emulated in Alpine. But you probably wouldn't need them.
- Plain data attributes can stand in for Stimulus [values](https://stimulus.hotwired.dev/reference/values). Or if data attributes become cumbersome, see my examples below for an `x-props` custom directive in Alpine.
- [`x-bind`](https://alpinejs.dev/directives/bind#binding-styles) for Stimulus [CSS classes](https://stimulus.hotwired.dev/reference/css-classes).

So Alpine is more or less a superset of Stimulus.*

<small>\* Note: this is *not* true if you're using Stimulus specifically for its being a convenient wrapper around the MutationObserver API. I couldn't find a good example of what that looks like with Stimulus, but one scenario where you need MutationObserver is to make a web component react to DOM changes ([1](https://naildrivin5.com/blog/2024/10/01/custom-elements-reacting-to-changes.html), [2](https://www.spicyweb.dev/videos/2023/slotted-mutations-in-web-components/)).</small>

### Alpine is NOT like Stimulus!

Alpine goes beyond Stimulus in that **it's fundamentally declarative**.

Stimulus is limited to granular DOM manipulation, as in *"on X event add a 'hidden' class to elements A and B; on Y event remove the 'hidden' class from elements A and B"*

But Alpine allows a declarative style, as in *"show elements A and B when Z is true"* (see [`x-show`](https://alpinejs.dev/directives/show)).

**This shift from imperative to declarative style can make your JS so much more readable, maintainable, and bug-resistant.** As an experiment, at work I did a Stimulus-to-Alpine conversion of an "Edit Mailing Address" form built around an in-house web component for address autocomplete. The web component emits events that my JS captures and translates into error messages on the form. I was shocked at the difference:

- The Stimulus controller was **207 lines long**, filled with logic that was difficult for me to follow even though I'd written it myself just a few weeks ago—and writing it had been a nightmare of continually finding yet another bug in my code.
- The JS class for the Alpine component totalled **only 60 lines**, was easier to write, and is actually possible to understand at a glance.

## Examples

I can't actually show that example from work, so rather than making up my own new examples here, I'll just link to the two examples in Brian Schiller's post ["Alpine.js vs Stimulus"](https://brianschiller.com/blog/2021/11/05/alpine-stimulus-js/), and I'll add my own alternate Alpine versions that keep the JS out of the HTML.

In my versions of the examples, I used [the CSP build of Alpine](https://alpinejs.dev/advanced/csp), where inline JS is actually impossible. This nicely serves as a form of no-inline-JS linting. It also introduces some inconveniences, but they can be worked around:

- Passing [initial parameters](https://alpinejs.dev/globals/alpine-data#initial-parameters) into a data object is impossible. No big deal: you can just use data attributes or (if that becomes clunky) a custom `x-props` directive, which you can see in my version of the second example below.
- [`x-model`](https://alpinejs.dev/directives/model) doesn't work in the CSP build. The workaround is to use the two directives that `x-model` is a shortcut for:

        <!-- instead of this: -->
        <input x-model:"myProperty">

        <!-- do this: -->
        <input :value="myProperty" @input="setMyProperty">

  - `:value` is short for `x-bind:value` ([docs](https://alpinejs.dev/directives/bind)), and `@input` is short for `x-on:input` ([docs](https://alpinejs.dev/directives/on)). This workaround makes an appearance in my version of the second example below.

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

- Once again the HTML is cleanest with Alpine CSP, but the JS file is not so satisfyingly short this time. Partly that's due to how this example is more complex, but another reason is that I threw in the `x-props` custom Alpine directive, not because it was needed but just for the sake of example.
- I didn't love that I had to pull in an extra package to access a parent component's data.

## But what if I need Turbo?

Earlier I pointed out that the apparent shortcomings of Stimulus are by design, in order for it to be compatible with [Turbo](https://turbo.hotwired.dev/). Does that mean you can't use Alpine with Turbo?

Yes and no. If you've already built your app using Stimulus and Turbo, it might not make sense to switch from Stimulus to Alpine. Turbo is probably handling most of the real-time interactivity anyway.

But if all you want is *something like Turbo*, i.e. a way to take HTML fragments sent from the server and morph them into the page, here are Alpine-friendly options for you:

- [htmx](https://htmx.org/), which has an [alpine-morph](https://v1.htmx.org/extensions/alpine-morph/) extension.
- [Alpine AJAX](https://alpine-ajax.js.org/), which has [a similar morph feature](https://alpine-ajax.js.org/reference/#morphing).

I'd probably pick Alpine AJAX, but more importantly *I wouldn't reach for morphing without considering other approaches first*, because morphing is complex and has limitations and edge cases. For example:

- [a critique of htmx](https://chrisdone.com/posts/htmx-critique/#most-interesting-web-apps-cannot-replace-wholesale-a-dom-element) and [the htmx author's reply](https://news.ycombinator.com/item?id=41782094) that it's a work in progress
- [a similar critique of Turbo](https://thomascannon.me/guides/fixing-the-rails-networking-stack#turbo-adds-excessive-complexity-and-reimplements-the-browser)

## Conclusion

I'll piggyback on Brian's post one more time and repeat its conclusion here:

> I can enthusiastically choose Alpine over Stimulus. Stimulus seems to have skipped the lessons of the past 7-8 years. It’s better than jQuery, but ignores the things that are good about React, Vue, etc: reactivity and declarative rendering. Meanwhile, Alpine manages to pack a ton of useful functionality into a smaller bundle size than Stimulus.

Alpine's bundle size has now grown somewhat larger than that of Stimulus, but otherwise I wholeheartedly agree with that conclusion.

And I'll add this: for anyone who is concerned about the maintainability of inline JS in HTML and prefers clean markup, a clear separation of concerns, TypeScript, etc. … **you can do all that with Alpine!** I think Alpine is the best of both worlds, between "all-in" JS frameworks that handle rendering (React et al.) and vanilla JS: declarative and template-friendly like React et al., but at the same time, small and easy to sprinkle into your server-rendered templates.

## Bonus: Alpine plugins

Another nice thing about Alpine is how many plugins there are out there. I already mentioned [Alpine AJAX](https://alpine-ajax.js.org/); here are just a few others:

- The "plugins" nav section in [the Alpine docs](https://alpinejs.dev/start-here)
- [Form validation](https://github.com/markmead/alpinejs-form-validation) and [others by Mark Mead](https://github.com/markmead?tab=repositories&q=alpine), especially the [HyperJS](https://js.hyperui.dev/) collection
- [Requests](https://github.com/0wain/alpinejs-requests)
- [Clipboard](https://github.com/ryangjchandler/alpine-clipboard) and [others by Ryan Chandler](https://github.com/ryangjchandler?tab=repositories&q=alpine)
- [Autosize](https://github.com/marcreichel/alpine-autosize)
- [Auto animate](https://github.com/marcreichel/alpine-auto-animate)
- [`x-include` and `x-interpolate`](https://github.com/mvolkmann/alpine-plugins)

You can find lots more in lists like [Alpine Extensions](https://www.alpinetoolbox.com/extensions) and [Awesome Alpine Plugins](https://github.com/alpine-collective/awesome#extensions--plugins).
