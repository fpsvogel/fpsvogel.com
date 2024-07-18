---
title: A November of WTFs
subtitle: the hard parts of learning Rails
description: Not everything is easy for someone learning Ruby on Rails. Here are the parts that I've found to be the hardest in my first few months.
---

- [1. Authentication](#1-authentication)
- [2. Active Record and the database](#2-active-record-and-the-database)
- [3. JS bundling](#3-js-bundling)
- [Conclusion](#conclusion)

Ruby on Rails has a well-deserved reputation for being easy to get started with. Recently [I built my first Rails app in just a month](/posts/2021/first-rails-app-plain-reading)—something I couldn't have done in many other frameworks. I've also written about [why Ruby is a great choice for a self-taught developer](/posts/2021/why-learn-ruby), and Rails is part of that great choice. But that doesn't mean Rails is completely painless to learn. There are hard parts, and we shouldn't sweep them under the rug.

The temptation is there: as a beginner I want to say it's a piece of cake just to make myself look smart. Veterans, out of their love of Rails, might mention only the easy parts, or it's been so long that they've forgotten what was hard for them starting out.

But if I resist that temptation and candidly point out where I'm struggling as a beginner, a lot of good can come of it:

- **It's good for other beginners:** I'll avoid perpetuating a crushing expectation that beginners must understand everything right away. Also, other beginners might benefit from the solutions that I'm jotting down along with the struggles. Documentation might also improve as a result: just the other day I asked [a very basic question](https://discord.com/channels/629472241427415060/891395933089189918/905518927080226837) about importmaps in the StimulusReflex Discord channel. (If you're not on there yet, (a) WHY, and (b) [here's an invite to the StimulusReflex Discord](https://discord.com/invite/stimulus-reflex).) Not only did I got a great answer to my question, but also it resulted in [a helpful addition](https://github.com/rails/importmap-rails/pull/63/files) to the `importmap-rails` readme.
- **It's good for my learning:** When I admit my ignorance of an entire domain (see "the database" below), I can then start to educate myself and fill the knowledge gap (or chasm) that underlies a lot of the issues and shortcomings of my Rails app.
- **It's good for my future self:** As I progress further along [my study plan](https://github.com/fpsvogel/learn-ruby), I'll see how these things are done by the pros, and I'll be able to refer back to these notes to remind myself of what I thought was confusing at first. That way I'll more thoroughly clear up my confusion. Also, even when I'm more experienced I'll be able to remind myself of my early struggles, and maybe provide better help to beginners around me.

So here are the hard parts of Rails, based on my three months of experience so far. During that time, besides building my first app and improving it a bit, I've also gone through these guides:

- [*Rails for Beginners*](https://gorails.com/series/rails-for-beginners) on GoRails
- [*Ruby on Rails Tutorial*](https://www.railstutorial.org/) by Michael Hartl
- The official [Rails Guides](https://guides.rubyonrails.org/)
- And I've just started [*Full Stack Ruby on Rails* at The Odin Project](https://www.theodinproject.com/paths/full-stack-ruby-on-rails)

## 1. Authentication

In the *Ruby on Rails Tutorial*, 12 out of the 14 chapters are devoted to setting up a basic user account system with registration, login, and password resets. An entire chapter is spent adding a "Remember me" checkbox to the login page. At one point I was obediently reaching into the BCrypt source code, copying some of it into the sample app, and tweaking it for use in the authentication system. Something about all this felt wrong.

I'm not saying I disliked the *Ruby on Rails Tutorial*. To the contrary, it taught me the invaluable lessons of how to test a Rails app and how to properly use Git, along with many other nuggets along the way. I'm also not saying Rails should have built-in user authentication. Maybe it should, but I'm not really sure. After all, there are already popular third-party solutions like [Devise](https://github.com/heartcombo/devise). And anyway it's good to learn how to build an authentication system from scratch at some point.

But does it have to be so soon? There are other areas where I'm just as ignorant as I was about the inner workings of authentication (see "the database" below), and in these areas there's not a gem that can automatically solve the problem for me—which is what I've ended up doing for authentication in my own project: even though I *could* build authentication from scratch, instead I'm using an authentication gem because the effect is exactly the same, but with less code in my app for me to maintain. (Rather than Devise, I've chosen the more lightweight alternative [Sorcery](https://github.com/Sorcery/sorcery). It's simple enough that I can still understand and control the authentication flow, while also providing enough conveniences that I don't have to write out implementation details from scratch.)

*Update: Speaking of authentication from scratch, [here's a nice guide to building custom authentication](https://github.com/stevepolitodesign/rails-authentication-from-scratch).*

So I'm glad I know how authentication works, but I think there are other skills that are more important to learn early on. Which brings us to my next point…

## 2. Active Record and the database

There are certain things about Active Record and databases that are not intuitive for beginners. I realize that not everything can be intuitive, especially when it comes to an area as vast as databases, and for that reason I've undertaken to learn about databases and SQL systematically (more on that in a future post).

Still, it would be nice if beginner Rails guides had more on how to use the database wisely. The *Ruby on Rails Tutorial* did have a bit at the end on Active Record query optimization; that was a very helpful introduction, but I wish there had been more. The Rails Guide on [Active Record Query Interface](https://guides.rubyonrails.org/active_record_querying.html) also helps, but it is not the beginner's guide that I'm wishing for, which would emphasize common beginners' misunderstandings and would feature more fleshed-out examples.

What would be the focus of such a beginner's guide, if it existed? One area that has been particularly difficult for me is database queries and how to optimize them. Even at the very beginning I knew *in theory* that I have to be careful not to hit the database too often, but I didn't really know what this meant in practice. It took me some time to get into the mindset of tiptoeing around the database.

This shift in mindset was slow for me partly because of Active Record's deceptively convenient interface. To a novice, it's hard to see the exact points where queries are executed. For example, I was sometimes calling Ruby collections methods on an Active Record query not realizing that I could instead further refine the query to get the same results with much better performance.

In the end I'm surviving without my wished-for beginner's guide: by paying attention to the log and experimenting (and Googling) I've done some work optimizing my queries, and now my data-heavy page loads are noticeably faster.

Here are a few other important facts that were unclear to me at first and took some hunting to figure out:

- Q: How long does an object retrieved from the database persist in memory? A: In Rails, instances (such as Active Record objects) exist only within the current request. Classes, on the other hand, persist across requests. So if you need to cache data retrieved from the database, do it on the class level or (even better) follow [the Rails Guide to caching](https://guides.rubyonrails.org/caching_with_rails.html).
- Q: What columns should I index? A: Any column that is used in a query to look up or sort records. [Here's a longer explanation of which columns to index.](https://semaphoreci.com/blog/2017/05/09/faster-rails-is-your-database-properly-indexed.html)
- Q: There are lots of different ways set an object's attributes. What are their differences? A: [Here's a cheat sheet on how to set Active Record attributes.](https://scottbartell.com/2020/01/30/set-attributes-in-active-record-rails-6/)

## 3. JS bundling

JS bundling, more than anything else, is shrouded in mystery for me. When I fix bundling issues or even when I try to learn the underlying concepts, it feels like I'm taking stabs in the dark.

It all started when I got Webpack-related build errors in Heroku, which I couldn't solve even after intense Googling. The new JS bundling options coming in Rails 7 had been announced a few days earlier, so rather than fiddle around further with Webpack, I thought it would make more sense to throw out Webpack and switch to the simpler approach of importmaps. What could possibly go wrong?

With an importmap the build errors went away, but then I got JS errors on my pages in production, which I eventually solved by upgrading to Rails 7 alpha. Now my app was building fine *and* the JS was working in production. Hooray!

But that's not the end of the story. A few weeks later I tackled a UI problem caused by cached page previews shown by Turbo. My importmap was not cooperating with my attempts to customize what happens in page transitions, so eventually I switched to JS bundling with ESBuild. *That's* the end of the story, I hope.

These were frustrating episodes, but I did learn a lot as I switched back and forth between different bundling setups and different versions of Rails. I also saw more than ever what people mean when they say the Ruby community is friendly, because I got tons of help on [the StimulusReflex Discord channel](https://discord.com/invite/stimulus-reflex)—despite the fact that my questions were not remotely about StimulusReflex! It blows me away how even well-known Rubyists are happy to help me, a random beginner. And I don't mean just a one-off reply; sometimes I get help over several days of troubleshooting and more questions. I'm gladder than ever that I chose Ruby ❤️

## Conclusion

To repeat, my intention here is *not* to complain about how hard Rails is to get started with. It's just that after I wrote about building my app, I felt something was not right: I raved about how quickly I had gotten up and running with Rails, but I was leaving out the less pleasant bits where I struggled mightily along the way. With this catalogue of woes, I hope I've corrected the imbalance.
