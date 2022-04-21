---
title: Ruby for the self-taught developer
subtitle: why it's a great fit
---

- [1. It's fun](#1-its-fun)
- [2. It's optimized for speed of development](#2-its-optimized-for-speed-of-development)
- [Objection #1: Rails apps are a mess](#objection-1-rails-apps-are-a-mess)
- [Objection #2: Ruby is slow](#objection-2-ruby-is-slow)
- [Objection #3: Ruby is dying](#objection-3-ruby-is-dying)
- [What about you?](#what-about-you)

Last month [I built my very first Rails app](/posts/2021/first-rails-app-plain-reading) and this month I'm working through the classic Ruby on Rails Tutorial, so I thought it would be a good time to pause and reflect on why I chose to start my developer journey with Ruby.

When I meet someone new at a social gathering and they happen to be a developer, I tell them I've been learning Ruby. Most of the time, their response is to recommend something else: Python, Laravel, Node + MongoDB, and .NET are the ones I've heard so far. Not only is it a bit soul-crushing for a beginner's endeavors to be flatly dismissed like this, but it's also wrong to assume that Ruby is a bad choice for a beginner.

I'll go even further and say that for me as a self-taught developer, Ruby was the best choice I could've made. Below I'll explain why, and then I'll address a few common objections.

Note that in this post I often lump Ruby and Rails together, not because they are the same, and not because every Rubyist works with Rails (there are some who don't), but because for a beginner looking for their first developer job, the simplest path is to learn both of them and get a job in a company that uses Rails.

Also, it should go without saying that if you're certain you're *not* interested in making websites or web apps (let's say you want to get into AI or systems programming), then Ruby is not the best choice, since the Ruby ecosystem is decidedly web-oriented. But if you're a beginner and you want to teach yourself programming in general, or web programming in particular, here are some reasons why Ruby is a great choice.

## 1. It's fun

As a self-taught developer, you can't rely on course deadlines and grades to motivate you. You have to motivate yourself, and that's a lot easier when the work you're doing is intrinsically enjoyable.

I've gotten a fair amount of enjoyment from other programming languages: years ago some [Blitz BASIC](https://en.wikipedia.org/wiki/Blitz_BASIC), Java, and Lua, and these days a bit of frontend JS. But I enjoy Ruby most of all.

Maybe it's because of Ruby's combination of concise syntax with a powerful object model, or maybe there's an undefinable "something" in Ruby that inspires odd creations like [a book-length guide to Ruby in cartoon format](https://poignant.guide/) (which I don't recommend as a beginner's guide, but it is impressive nonetheless). Whatever the reason, Ruby is fun in a way that can only be appreciated if you [try it yourself](https://try.ruby-lang.org/).

I'm not alone in feeling that way—just yesterday someone published a ["love letter to Ruby"](https://jmarchello.com/a-love-letter-to-ruby-and-rails), explaining:

> "In my experience working in other technologies, 50-80% of my time is spent solving technology problems and what's left is used to solve actual business problems. These technology problems are tasks such as building out database connections, setting up boilerplate, writing build pipelines, etc. Meanwhile with Rails I've noticed I get to spend spent the vast majority of my time focusing on business logic."

Which brings us to my next point.

## 2. It's optimized for speed of development

As a self-taught developer, it's also important to *build stuff*. You have no degree that tells people how good you are. Instead, your portfolio does all the talking. For the solo learner who needs to put together a portfolio of working, useful apps, Ruby and Rails are excellent tools.

Part of this productivity boost, it must be said, comes from how many conventions are built into Rails. Honestly, the reason I looked for alternatives to JS frameworks in the first place is that the JS ecosystem has so many options at every turn, and it's hard for a beginner to know what decisions to make.

It's not been much longer than a year since I started learning Ruby part-time in the spare hours left over after work and family, but in that time I've already built a few projects that are useful to me:

- First, [a CLI app](https://github.com/fpsvogel/readstat) that analyzes my CSV reading log and shows stats on my reading. (I'll eventually move its core functions into my Rails app.)
- Next, [my blog built with Bridgetown](https://github.com/fpsvogel/blog-2021). It's what you're looking at right now. My favorite part is the [Reading](/reading) page, where the highest-rated items are automatically pulled in from my CSV reading log every week. ([Here's more](/posts/2021/build-a-blog-with-bridgetown#2-ruby-component-and-plugin) on how I built that, if you're curious.)
- Most recently, [my first Rails app](/posts/2021/first-rails-app-plain-reading). I built the usable first version in just one month, and for the next few months I'll be expanding it.

So Ruby is fun and very productive, two key advantages for the self-taught developer.

*"But,"* you might be wondering, *"aren't Rails apps messy and slow? Isn't Ruby unpopular and way past its prime?"* I'll address each of these objections next.

## Objection #1: Rails apps are a mess

There's a reason Rails is often used in startups, and it's the same reason that people either love Rails or hate it: Rails makes it so easy to slap together an app and throw new features into it nearly as fast as you can think of them. It's exhilarating in the moment, but we all know the sad result. The app grows haphazardly into a [big ball of mud](https://en.wikipedia.org/wiki/Big_ball_of_mud), its growth grinds to a halt, and its developers are left with a bad taste in their mouth, cringing at the mere mention of Rails for the rest of their life.

But Rails can be productive *even in the long run*, if you use it carefully. ["Provide sharp knives"](https://rubyonrails.org/doctrine/#provide-sharp-knives) is a core value of Rails, and it's up to us whether we use those knives for good or ill. There are lots of resources out there for learning sustainable Rails development, some of which I've included in [my study plan](https://github.com/fpsvogel/learn-ruby-and-cs#rails).

## Objection #2: Ruby is slow

Ruby and Rails have a reputation for being slow. I think a lot of this comes from (a) performance benchmarks, and (b) stories of companies moving away from Rails for performance reasons. But just because Scala is faster than Ruby, and Twitter switched from Rails to Scala for their backend, doesn't mean that you should skip Ruby and build your first apps with Scala.

Every technology has its own tradeoffs. Ruby has lots of conveniences that make development faster and easier, but those conveniences come at the cost of performance. For me, that cost is completely worthwhile. But if you're still skeptical, here are some thoughts for you:

- Ruby and Rails are *fast enough* for most applications that don't involve a lot of data processing. Heck, even Shopify and Github run on Rails.
- Whenever I've run into performance issues in my projects, so far they've been caused by badly optimized code. [Here's a recent example](/posts/2021/nand-to-tetris#optimizing-runtime) where I got an 800x speed increase in my Ruby code.
- In recent years, Ruby has gotten [big improvements in performance, concurrency, and parallelism](https://medium.com/retention-science/ruby-is-still-a-diamond-b789d2661266). And the improvements are [still rolling in](https://shopify.engineering/yjit-faster-rubying).
- If you're convinced you need better performance than Ruby can offer, don't turn your back before you look into the more performant Ruby variants, such as [TruffleRuby](https://github.com/oracle/truffleruby) and the upcoming [Sorbet Compiler](https://sorbet.org/blog/2021/07/30/open-sourcing-sorbet-compiler). If you want to talk compilers, though, there's also Ruby's near cousin [Crystal](https://crystal-lang.org), which [can easily be used alongside Rails](https://www.youtube.com/watch?v=sTGfi98XXS4&t=592s) to speed up data processing tasks.
- There are also lighter and faster alternatives to Rails, such as [Roda](https://roda.jeremyevans.net/). Also, [Bridgetown is getting exciting new features](https://www.bridgetownrb.com/release/era-of-bridgetown-v1/) for building hybrid static/SSR sites.

## Objection #3: Ruby is dying

It's true that Ruby and Rails are somewhat old and not as popular as they once were. But that doesn't mean they're *dying*. In fact, from what I can see, in the past few years there's been an uptick in ambitious new Ruby projects such as [Bridgetown](https://www.bridgetownrb.com/) (can you tell that I love it?) and popular new Rails projects like [Forem](https://www.forem.com/) and [Polywork](https://www.polywork.com/). And there are plenty of Rails jobs out there.

Sidenote on jobs: Rails salaries are higher than the industry average right now because from what I gather, companies are finding it easier to spend their resources on top Rails talent rather than to invest in juniors. (Maybe because there are not a whole lot of juniors in Rails these days? I'm not sure.) So once you get a Rails job the salary will be high, but as a beginner it might take longer to find your first job. For me this isn't a terrible situation, because I have a full-time job already (not as a developer) and I'll happily work on my Ruby projects until I'm able to find a developer job, whenever that may be. But if you're a beginner who needs to get a developer job immediately, then maybe Ruby is not the best place to start.

Anyway, for a beginner it's much easier to learn a technology like Rails that is *not* the hot new thing because it's not changing as rapidly. Sure, there are always improvements to keep up with, but the fact remains that when you search for a solution to a problem and find one that's a few years old, it will likely work despite its age. But again, Rails is not dying, and it's popular enough that you won't often have to rely on a decade-old answer to solve a problem you're stuck on.

## What about you?

If you're a beginner wondering what programming language to learn first, give Ruby a chance! [Try it in your browser](https://try.ruby-lang.org/), then see [my study plan](https://github.com/fpsvogel/learn-ruby-and-cs#rails) to get some ideas on next steps.

Or if you're a grizzled veteran who hates Ruby, then I hope I've gone a little way to soften your heart. The next time a beginner says to you that they're learning Ruby, try not to suggest something else right away. Instead, smile and ask them how it's going. It'll make a bigger difference than you might guess.
