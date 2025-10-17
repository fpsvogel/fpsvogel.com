---
title: RVTWS
subtitle: a Ruby stack for modern web apps
description: My dream Ruby stack is Rails/Roda, ViewComponent, Turbo, web components, and StimulusReflex. I still need to learn most of those 😂
---

- [Rails or Roda](#rails-or-roda)
- [ViewComponent](#viewcomponent)
- [Turbo](#turbo)
- [Web components](#web-components)
- [StimulusReflex](#stimulusreflex)
- [Conclusion](#conclusion)

When I started my career switch into software development two years ago, I decided to focus my efforts on Ruby. I did this for [a few reasons](/posts/2021/why-learn-ruby), but one of them is that Rails offers great "bang for the buck": there's a lot that I can build with just Rails, HTML, and CSS.

However, this minimal vanilla stack becomes limiting when two factors come into play:

1. The MVC architecture of Rails won't always be enough to keep your code organized. You'll notice it painfully if your app ever grows beyond a small project.
2. For your app to feel modern, the front end will need to act like an SPA (Single-Page Application). The "official" way to do this is now [Hotwire](https://hotwired.dev), but there are other tools worth keeping in the toolbelt. More on that below.

Making a new acronym for your favorite tech stack is a popular thing these days, so I'll coin a new acronym: **RVTWS**… pronounced "erv toes"? Yes, this is great. It will go viral in no time.

Joking aside, I'm using this acronym here only as an outline for this blog post, rather than for any marketing value. The "V" (ViewComponent) addresses point #1 above, and "TWS" are concerned with #2.

- **R**ails or Roda
- **V**iewComponent: *for front-end architecture*
- **T**urbo: *for an SPA feel, using the server*
- **W**eb Components: *for an SPA feel, using the client*
- **S**timulusReflex: *for more complex front-end magic*

## Rails or Roda

There's not much to say about [Rails](https://rubyonrails.org): it's boring tech, and therefore a good choice for most web apps.

[Roda](http://roda.jeremyevans.net) is also worth considering. Unlike the batteries-included philosophy of Rails, Roda is bare-bones by default but highly extensible. This makes Roda apps fast and more architecturally flexible. Besides [the docs](http://roda.jeremyevans.net/documentation.html), here are some places to get started with Roda:

- [An interview](https://topenddevs.com/podcasts/ruby-rogues/episodes/building-with-just-what-you-need-using-roda-with-jeremy-evans-ruby-507) with its creator Jeremy Evans.
- [Roda + Sequel app skeleton](https://github.com/jeremyevans/roda-sequel-stack), which has a similar purpose to the `rails new` command.
- [A post on Bridgetown's ongoing Roda integration](https://www.fullstackruby.dev/fullstack-development/2022/06/03/what-would-it-take-for-roda-to-win), which is making Roda more accessible thanks to Bridgetown's batteries-included approach.

## ViewComponent

[Partials](https://guides.rubyonrails.org/layouts_and_rendering.html#using-partials) are the standard Rails way to define distinct parts of a view. Partials provide a way to separate out part of a template, but they don't provide a way to separate out view-related logic, which often ends up being thrown into models and/or controllers. This is one reason why models and controllers in Rails can so easily become huge and messy.

[ViewComponent](https://viewcomponent.org) provides a home for this view-related logic. [This post on the Code with Jason blog](https://www.codewithjason.com/the-problem-that-viewcomponent-solves-for-me) explains it best. In short, ViewComponent fills a big gap in MVC architecture.

Some readers may be wondering, *"Is that all? What about other architectural improvements, like service objects?"* It's true that certain types of apps have problems best solved with certain design patterns, and maybe a very large app needs a specialized architecture. But in general, Rails models designed in a careful, object-oriented way can take you very far, and I think the popularity of service objects is unjustified because they can easily muddle up a codebase. Food for thought:

- [Why Service Objects are an Anti-Pattern](https://www.fullstackruby.dev/object-orientation/rails/2018/03/06/why-service-objects-are-an-anti-pattern) at Fullstack Ruby
- [How I Organize My Rails Apps](https://www.codewithjason.com/organize-rails-apps) at Code with Jason

## Turbo

On to the front end! [Turbo](https://turbo.hotwired.dev) is part of Hotwire, which now ships with Rails. Turbo makes it really easy to give server-rendered pages a snappy SPA feel, where parts of the page are updated instantly instead of a full page reload.

At the heart of Turbo is "HTML over the wire" (for which *HOTWire* is an acronym), which means the server sending HTML fragments for partial page updates, which (here's the big win) eliminates the need for client-side state management. There are [lots](https://htmldriven.dev/html-over-the-wire) of [tools](https://github.com/guettli/frow--fragments-over-the-wire) taking this approach now.

[Unpoly](https://unpoly.com) and [HTMX](https://htmx.org) are two of the most intriguing alternatives to Turbo because they are more framework-agnostic and have a flexible, concise syntax. Turbo, on the other hand, seems easier to get started with if you're in Rubyland.

Sidenote: If you're wondering why all these "HTML over the wire" tools came about and what they're pushing back against, take a look at these two comparisons of web app architecture from 2005 vs. ten years later: one from Unpoly ([2005](http://triskweline.de/unpoly-rugb/#/5) vs. [2015](http://triskweline.de/unpoly-rugb/#/11)), and another from the developer of Turbo's predecessor Turbolinks ([2005](https://youtu.be/SWEts0rlezA?t=273) vs. [2016](https://www.youtube.com/watch?v=SWEts0rlezA&t=397s)).

Besides Turbo, the other part of Hotwire is [Stimulus](https://stimulus.hotwired.dev), which typically is used for adding client-side reactivity in situations where you want to sprinkle in some JS. After all, you wouldn't want *every* user interaction to involve a round trip to the server. So why am I including only Turbo here and not Stimulus?

## Web components

Actually, Stimulus is pretty cool because you can [compose multiple pre-built behaviors](https://stimulus-use.github.io/stimulus-use) into one Stimulus controller, for a sort of functional approach to component behaviors. The tradeoff is that a growing web of Stimulus controllers (plus HTML data attributes associated with them) can become complex and hard to understand.

[Web components](https://developer.mozilla.org/en-US/docs/Web/Web_Components) are an architecturally simpler way to add client-side behaviors, and they also have the advantage that they're a web standard. [This blog post on Fullstack Ruby](https://www.fullstackruby.dev/fullstack-development/2022/01/04/how-ruby-web-components-work-together) shows the power of web components in the context of Ruby.

Also, as illustrated in that post, you can use [Ruby2JS](https://www.ruby2js.com) to write web components in Ruby. (You can likewise [write Stimulus controllers in Ruby](https://www.ruby2js.com/examples/stimulus).) In other words, you get the best of both worlds: the power of JavaScript on the front end, and all the conveniences of Ruby syntax 🤩

## StimulusReflex

Turbo + web components can take you a long way in making your Rails app feel modern, but there are other tools in this space that can complement them. I've already mentioned Stimulus, but there's also [StimulusReflex](https://docs.stimulusreflex.com) which is like Stimulus but on the server, and [CableReady](https://cableready.stimulusreflex.com/) which is somewhat like [Turbo Streams](https://turbo.hotwired.dev/handbook/streams) but more flexible. Be sure to give these a try if your app is highly interactive, or if you just want to expand your horizons beyond Hotwire.

Also, [the StimulusReflex Discord server](https://discord.com/invite/stimulus-reflex) is an amazing place even for discussing all the other tech mentioned in this post. (Which is very ironic. Ever since Hotwire's release, it has marketed itself as THE solution, not even mentioning the similar tools had already been coming out of the StimulusReflex community for two years. Even so, it's in this very community that you can find the best Hotwire support.)

## Conclusion

I've been thinking about this ideal Ruby stack because for the first time I'm working on a Rails app that has a React front end, and it's been a painful adjustment. Sometimes it feels like I'm writing logic twice, once on the back end and again on the front end. And what do I get for it? Smoother page transitions and buttons that do things without refreshing the page. That's nice, but do these simple enhancements have to involve so much extra work?

On the other extreme, the "vanilla Rails" approach to writing views [is clunky and outdated](https://www.fullstackruby.dev/fullstack-development/2022/06/03/what-would-it-take-for-roda-to-win#y-u-no-like-rails), and Hotwire doesn't fix all the omissions. It's no wonder that people go looking for outside front-end solutions such as React.

So I started dreaming about what front-end tools could give a smooth user experience *without* so much extra complexity, and this "RVTWS" stack is the result. (Yeah, I need to work on that acronym.)

On a final note, if you'd like to learn more about Hotwire, check out [the Hotwire resources that I've compiled in my "Learn Ruby" list](https://github.com/fpsvogel/learn-ruby/tree/aaff9dd800e1e43b2ec80ad8434ddfc63426b239#hotwire). *UPDATE: That link is to an old version of the list. The current version omits Hotwire because these days I'm more interested in other JS libraries. See the bottom of [the "JavaScript" section](https://github.com/fpsvogel/learn-ruby#javascript) in the list.*
