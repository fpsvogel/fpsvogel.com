---
title: Hitting the books
subtitle: why building stuff is not always enough
description: Side projects are not the only way to improve as a developer. Books and courses can fill in gaps of fundamental skills and computer science knowledge.
---

- [A break from building stuff](#a-break-from-building-stuff)
- [SQL and databases](#sql-and-databases)
- [About the Web](#about-the-web)
- [What next?](#what-next)

tl;dr I've been spending time on [foundational skills](https://github.com/fpsvogel/learn-ruby#foundations), like practicing SQL and building an HTTP server from scratch, and next I'll go back to [learning computer science](https://github.com/fpsvogel/learn-cs).

## A break from building stuff

*"Just build stuff."*

That's what I've done over the past two or three years. I spent most of my outside-of-work-programming time (much reduced now that I have children) on "practical" projects such as:

- [A CLI framework for doing Advent of Code in Ruby](https://github.com/fpsvogel/advent_of_ruby)
- [A Ruby gem for parsing a reading log](https://github.com/fpsvogel/reading)
- [Learning some Haskell](https://fpsvogel.com/posts/2023/rubyist-learns-haskell-1-getting-started)

(That last one is debatable in its practicality 😅)

What to work on next? I'm not sure. I'm **stumped**. Even to the point that I wondered what it would be like to learn one of the "boring" languages. I listed out learning resources [for C#](https://github.com/fpsvogel/learn-csharp) and [for Java](https://github.com/fpsvogel/learn-java). I'm not sure I'll go ahead with either of those.

<small><em>Disclaimer to prevent angry emails from C# and Java developers: there are some very intriguing things about both languages, like concurrency. The other day I went down a rabbit hole comparing C#'s stackless coroutines (async/await) to Java's stackful coroutines (Virtual Threads). C# [might even evolve](https://www.reddit.com/r/csharp/comments/1krsr78/async2_runtimeasync_and_implicit_asyncawait/) to the point of its stackless coroutines not needing async/await written out 😲 And of course, either is great for high performance while being memory-safe and garbage-collected, without having to write Go. \*Ducks away from Go afficionados.\*</em></small>

*UPDATE: I dug up some old notes on Elixir learning resources, updated them, and [put them in a repo as well](https://github.com/fpsvogel/learn-elixir). Maybe I'll make a zoo for these lists 😂*

There is one language I definitely do want to spend time on: [Roc](https://www.roc-lang.org), a functional language without [the baggage of Haskell](https://fpsvogel.com/posts/2024/rubyist-learns-haskell-3-quitting-haskell-discovering-roc). But Roc is at pre-0.1 (only nightly builds) and I'm waiting until it stabilizes somewhat.

Why look to another language? There's a ton of fun stuff I could do in Ruby:

- 🤖 Build Starcraft II bots with the [SC2 AI gem](https://sc2ai.pages.dev/).
- 🕹️ Make a graphical game with [DragonRuby](https://dragonruby.itch.io/dragonruby-gtk).
- 📃 Continue making [a text-based game](https://fpsvogel.com/posts/2023/ruby-text-based-game-real-time-input) that I started a while back.
- 🎵 Make music with [Sonic Pi](https://sonic-pi.net/).
- 🎄 Do Advent of Code from previous years. I made [a gem](https://github.com/fpsvogel/advent_of_ruby) for that, after all.
- ⛳ [Code golf.](https://github.com/fpsvogel/learn-ruby/tree/61c82a919e995e4f1e24a9b91926cf29a4fdb8a5#user-content-code-golf)
- 🏋️ Do [coding exercises](https://github.com/fpsvogel/learn-ruby/tree/61c82a919e995e4f1e24a9b91926cf29a4fdb8a5#user-content-coding-exercises), mainly from competitive programming.

But, I don't know… right now I'm craving more structure and a sense of progression.

Plus, there are specific skill/knowledge gaps that I want to fill in. What gaps? I'm glad you asked! 😁

## SQL and databases

I hand-write SQL almost every day at work for data exploration purposes, but there are a lot of concepts I feel I'm missing. To address that, I'm working through practice sites and doing some reading beyond the basics.

(If you're brand new to SQL and need more basic practice, try [SQL Teaching](https://www.sqlteaching.com), [SQLBolt](https://sqlbolt.com), and [Select Star SQL](https://selectstarsql.com).)

I'm learning techniques that aren't applicable every day but are good to know anyway, such as:

- [FOR UPDATE locks](https://www.postgresql.org/docs/current/explicit-locking.html#LOCKING-ROWS) and [their Active Record implementation](https://guides.rubyonrails.org/active_record_querying.html#pessimistic-locking)
- [Common Table Expressions](https://www.postgresql.org/docs/current/queries-with.html) and [their Active Record implementation](https://www.hashnotadam.com/posts/2023/05/common-table-expressions-in-active-record/)
- [LATERAL JOIN](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-LATERAL), which isn't implemented in Active Record, but is used in the [activerecord-has_some_of_many](https://github.com/bensheldon/activerecord-has_some_of_many) gem for the common use case of "top N" queries ([here's an example with a manual LATERAL JOIN](https://sambleckley.com/writing/lateral-in-rails.html))
- [Postgres prepared statements](https://www.postgresql.org/docs/current/sql-prepare.html) can improve the performance of repeated similar queries by caching their execution plan.
- *Obfuscated conditions* (where an index can't be applied) result from using a function on a column, [e.g. on dates](https://use-the-index-luke.com/sql/where-clause/obfuscation/dates).

Here are the SQL and database resources (most of them free) that I've been using and would recommend:

- **SQL practice:**
  - [SQL Practice](https://www.sql-practice.com/)
  - [PostgreSQL Exercises](https://pgexercises.com/)
- **Databases:**
  - [Next-Level Database Techniques for Developers](https://sqlfordevs.com/ebook)>
  - [Use the Index, Luke!](https://use-the-index-luke.com/sql/preface)
  - [Build a Database Server](https://technicaldeft.com/build-a-database-server)
  - [Build Your Own Redis with C/C++](https://build-your-own.org/redis/)

## About the Web

Recently I realized I didn't know (or had forgotten) what an HTTP request actually *looks* like as it's being sent over the wire. So it was time to relearn the basics.

Along the way I'm also learning some neat tricks. I'm particularly enjoying the hands-on exploration afforded by building an HTTP server from scratch, where I'm going on little side-quests of my own making, like [implementing live reloading](https://github.com/fpsvogel/http-server-from-scratch/commit/e16d1eab6ea040cd9d705f531d756a86cd2e0288#diff-edf2b3f28548822d73a1ba38fe04d1edf2b0653850a3adc6f25e4ca2746ea672) and [starting a test server without a sleep or runtime limit](https://github.com/fpsvogel/http-server-from-scratch/blob/daef787e60aafcd2b7b3af471869cc4d1a9e99d3/test/test_server.rb#L14-L37) (unlike [the suggested test setup](https://github.com/noahgibbs/testing_rebuilding_http/blob/main/roll_forward_tests.rb#L61-L79)).

You may have noticed, but these examples of things I've learned are from **hands-on practice** and, yes, **building stuff** like an HTTP server. The point of this post is not to pontificate against side projects, just to lay out *a different way of practicing fundamental skills*.

Anyway, these are the Web-related resources I'm using:

- **HTTP:**
  - [Hypermedia Systems, Part I: Hypermedia Concepts](https://hypermedia.systems/part/hypermedia-concepts/) by the creator of [htmx](https://htmx.org), one of [many libraries](https://htmx.org/essays/alternatives) that take a hypermedia-oriented approach to web development.
  - [Noah Gibbs - Rebuilding HTTP](https://noahgibbs.gumroad.com/l/rebuilding_http) (his last book 😢)
- **Networking:**
  - [Computer Networking: A Top-Down Approach](https://gaia.cs.umass.edu/kurose_ross/index.php) (re-read)
  - [Jesse Storimer - Working with TCP Sockets](https://workingwithruby.com/wwtcps/intro)
- **Security:**
  - [Hacksplaining](https://www.hacksplaining.com/) and/or the accompanying book [Grokking Web Application Security](https://www.manning.com/books/grokking-web-application-security)
  - [PortSwigger - web security exercises](https://portswigger.net/web-security/all-topics)

## What next?

Once I get through all of the above resources, I will finally have finished the "Foundations" section of [my Learn Ruby list](https://github.com/fpsvogel/learn-ruby). From there I could start focusing on a different section.

More likely, I'll spend some time on [my Learn Computer Science list](https://github.com/fpsvogel/learn-cs). It's been a while since I last chipped away at it.

And I'm excited to give [Roc](https://www.roc-lang.org/) another try in a few months. As for C# and Java… I'll save them for when I need a career pivot.
