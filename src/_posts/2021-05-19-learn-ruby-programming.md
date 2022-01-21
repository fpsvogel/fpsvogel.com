---
layout: post
title: Ruby and computer science
subtitle: a self-learning curriculum
---

- [Objections](#objections)
- [Preliminaries](#preliminaries)
- [Frontend basics](#frontend-basics)
- [Ruby](#ruby)
- [Meanwhile, computer science](#meanwhile-computer-science)
- [Other programming/CS resource lists](#other-programmingcs-resource-lists)

It's been exactly one year since I started studying part-time to get into software development, and I thought it would be useful to write out my curriculum. I am learning Ruby, Rails, and a healthy dose of computer science. I'm also putting this [on GitHub](https://github.com/fpsvogel/learn-ruby-and-cs) where I will continue to update it, but below is my progress as of now.

## Objections

*Why Ruby?? Isn't JavaScript the obvious choice for web development?* Ruby is a good first language to master because its ecosystem is stable, the community is more experienced, and for me Ruby is more enjoyable to write. Not convinced? [Read this](https://medium.com/learn-love-code/why-teach-ruby-bac8416c77ba) or [watch this](https://youtu.be/IlVfHG-pAag?t=1534).

*OK, but why so many books and courses?? Isn't practice more important than reading?* Yes, you should be spending more time coding than reading, but starting a project and getting into a coding routine is easy, whereas knowing what to read is not at all obvious at the beginning. Hence the larger space devoted to books and courses here. Besides the obvious reasons to undertake serious study (to learn from the masters, and to spice up my resume), I also simply enjoy knowing how things work under the hood.

## Preliminaries

- If you've never written a line of code in your life, you may want to start with the free [Learn to Program](https://pine.fm/LearnToProgram/). I studied some computer science in high school, so I had a bit of a head start.
- If you are a working adult, make sure your day job is conducive to part-time studying. Last year I was a first-year schoolteacher. That meant hours of grading in the evenings and on weekends, which would have made studying impossible. For this and other reasons I switched to a remote tech support job, which freed up my evenings and weekends (and early mornings, with no commute).
- Find a system for keeping *organized* notes, code snippets, and articles/videos saved for later. I use a simple text file ([similar to this](https://illdoitlater.xyz/t/plaintext)), which is more effortless than any knowledge base app that I've tried.
- It's worth dipping into the Ruby and wider programming communities. Here are my favorites:
  - [Hacker Newsletter](https://hackernewsletter.com/)
  - [DEV newsletter](https://dev.to/t/newsletter)
  - Ruby: [Reddit](https://www.reddit.com/r/ruby), [Discord](https://discord.gg/tSFdeuVfpc), [Slack](https://www.rubyonrails.link/)
  - Rails: [Reddit](https://www.reddit.com/r/rails) and [Discord](https://discord.gg/AuDNwjsyfm)
  - others on Discord: [Bridgetown](https://discord.gg/Cugms94QFM), [StimulusReflex](https://discord.com/invite/stimulus-reflex)
- Last but not least, take care of yourself! Studying (especially while working) can easily be overdone. Exercise and get plenty of sleep. If you develop wrist pain from computer use, act swiftly: get an ergonomic mouse and keyboard, do daily RSI stretches, and start using a break app such as [Workrave](https://workrave.org/).

So without further ado, here are my recommendations from what I studied. Resources that are free of charge are marked with a star (⭐). If you need more free resources, see the links to other lists at the bottom. You may be able to find the books for free (from your local library or more dubious sources) but be sure to buy them when you can, to support the authors. 🙂

## Frontend basics

- [x]&nbsp;Treehouse's [Frontend Web Development](https://teamtreehouse.com/tracks/front-end-web-development) track, or The Odin Project's ⭐[Foundations](https://www.theodinproject.com/paths/foundations/courses/foundations) + ⭐[HTML and CSS](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/html-and-css) + ⭐[JavaScript](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/javascript)
- [x]&nbsp;**Build a blog from scratch:** Which you are reading. [Here's how I built it](/posts/2020/zs). I am also posting daily discoveries on Twitter, where—confession—[I sometimes talk to myself](https://twitter.com/fpsvogel/status/1389915714098802692).

## Ruby

- [x]&nbsp;**Basics:** [The Well-Grounded Rubyist](https://www.manning.com/books/the-well-grounded-rubyist-third-edition) or ⭐[The Odin Project](https://www.theodinproject.com/courses/ruby-programming).
- [x]&nbsp;**Guided practice:** ⭐[Exercism](https://exercism.io/my/tracks/ruby), then ⭐[CodeWars](https://www.codewars.com) if you want more. Be sure to take notes each time you learn something new in an exercise, and [write up a reflection](/posts/2020/exercism-ruby) at the end.
- [x]&nbsp;**OOP:** [Practical Object-Oriented Design: An Agile Primer Using Ruby](https://www.poodr.com) (a.k.a. POODR), then [99 Bottles of OOP](https://sandimetz.com/99bottles-sample-ruby). More than any other books, these are worth the price tag.
- [x]&nbsp;**Ruby app:** Apply those OOP lessons. I made a CLI (command-line interface) [app that gives statistics on a reading log](/posts/2021/my-first-ruby-app-lessons-learned). Along the way I also [published a Ruby gem](/posts/2020/ruby-functional-programming), though in the end I abandoned it because I realized it did more harm than good. All part of the learning process…
- [x]&nbsp;**Design patterns:** [Head First Design Patterns](https://www.oreilly.com/library/view/head-first-design/9781492077992/). Also ⭐[Refactoring.Guru](https://refactoring.guru/) for a catalog of code smells, refactoring recipes, and design patterns.
- [ ]&nbsp;**Bridgetown apps:** I'm remaking my blog on ⭐[Bridgetown](https://github.com/bridgetownrb/bridgetown) (an updated Jekyll), then I'll use Bridgetown to make a couple of static web apps.
- [ ]&nbsp;**Rails:**
  - [ ]&nbsp;⭐[Rails for Beginners](https://gorails.com/series/rails-for-beginners)
  - [ ]&nbsp;[A general Rails course on Udemy](https://www.udemy.com/course/ruby-on-rails-6-learn-20-gems-build-an-e-learning-platform/) (or [find a newer one](https://www.udemy.com/courses/search/?duration=extraLong&q=ruby+on+rails&ratings=4.0&sort=newest&src=ukw) if that one is of date by the time you read this)
  - [ ]&nbsp;[Ruby on Rails Tutorial](https://www.railstutorial.org)
  - [ ]&nbsp;⭐[Rails Code Along](https://www.railscodealong.com/)
  - [ ]&nbsp;[Dissecting Ruby on Rails](https://www.udemy.com/course/professional-rails-5-development-course/)
  - [ ]&nbsp;⭐[Demystifying Rails](https://launchschool.com/books/demystifying_rails)
- [ ]&nbsp;**Rails app:** And use ⭐[StimulusReflex](https://docs.stimulusreflex.com/) to build a reactive frontend.
- [ ]&nbsp;**Deployment:** [Deployment from Scratch](https://deploymentfromscratch.com/) and [Deploying Rails Applications](https://leanpub.com/deploying_rails_applications).
- [ ]&nbsp;**Open source contributions:** ⭐[First Timers Only](https://www.firsttimersonly.com/) is a good place to start.
- [ ]&nbsp;**Polishing up—books:**
  - [ ]&nbsp;[Polished Ruby Programming](https://www.packtpub.com/product/polished-ruby-programming/9781801072724)
  - [ ]&nbsp;[Ruby Science](https://github.com/thoughtbot/ruby-science)
  - [ ]&nbsp;[Metaprogramming Ruby](https://pragprog.com/titles/ppmetr2/metaprogramming-ruby-2/)
  - [ ]&nbsp;[The Complete Guide to Rails Performance](https://www.railsspeed.com/)
  - [ ]&nbsp;[The Ruby on Rails Performance Apocrypha](https://www.speedshop.co/2021/01/14/announcing-apocrypha.html)
- [ ]&nbsp;**Polishing up—screencasts and courses:**
  - [ ]&nbsp;⭐[Web-Crunch](https://web-crunch.com/collections)
  - [ ]&nbsp;⭐[Upcase](https://thoughtbot.com/blog/announcing-upcase-is-free)
  - [ ]&nbsp;[GoRails](https://gorails.com)
  - [ ]&nbsp;[Drifting Ruby](https://www.driftingruby.com/)
  - [ ]&nbsp;[RubyTapas](https://www.rubytapas.com/)
  - [ ]&nbsp;[Destroy All Software](https://www.destroyallsoftware.com/screencasts/catalog)
- [ ]&nbsp;⭐**Polishing up—podcasts:**
  - [ ]&nbsp;[Remote Ruby](https://remoteruby.transistor.fm/episodes)
  - [ ]&nbsp;[Ruby on Rails Podcast](https://5by5.tv/rubyonrails)
  - [ ]&nbsp;[The Bike Shed](https://www.bikeshed.fm/)

## Meanwhile, computer science

- [x]&nbsp;**Computers 101:** [Code: The Hidden Language of Computer Hardware and Software](https://www.charlespetzold.com/code/)
- [x]&nbsp;**Algorithms I:** [Data Structures and Algorithms in Java](https://www.amazon.com/Data-Structures-Algorithms-Java-2nd/dp/0672324539)
- [x]&nbsp;**Usability:** [Don't Make Me Think](https://sensible.com/dont-make-me-think/) and [The Design of Everyday Things](https://www.nngroup.com/books/design-everyday-things-revised/)
- [x]&nbsp;**Operating Systems:** [Operating Systems: Three Easy Pieces](http://pages.cs.wisc.edu/~remzi/OSTEP/)
- [x]&nbsp;**Networks:** [Computer Networking: A Top-Down Approach](https://gaia.cs.umass.edu/kurose_ross/eighth.htm)
- [ ]&nbsp;**Computer Architecture:** [The Elements of Computing Systems: Building a Modern Computer from First Principles](https://mitpress.mit.edu/books/elements-computing-systems-second-edition) (plus the [site](https://www.nand2tetris.org/) and free accompanying course: [part 1](https://www.coursera.org/learn/build-a-computer), [part 2](https://www.coursera.org/learn/nand2tetris2)).
- [ ]&nbsp;**Software Architecture:** [Designing Data-Intensive Applications](https://www.oreilly.com/library/view/designing-data-intensive-applications/9781491903063/)
- [ ]&nbsp;**Databases:** ⭐[Readings in Database Systems](http://www.redbook.io/)
- [ ]&nbsp;**Compilers:** ⭐[Crafting Interpreters](https://craftinginterpreters.com/)
- [ ]&nbsp;**Math:** [Concrete Mathematics: A Foundation for Computer Science](https://www-cs-faculty.stanford.edu/~knuth/gkp.html). The math review that I'm doing leading up to this is proving to be a journey in itself, to be outlined in a future post.
- [ ]&nbsp;**Algorithms II:** [The Algorithm Design Manual](https://www.algorist.com/)
- [ ]&nbsp;**??:** ⭐[Structure and Interpretation of Computer Programs](https://sarabander.github.io/sicp/html/index.xhtml) (and [video lectures](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video-lectures/)). I have often seen this recommended, but its exact subject matter (and whether reading it amounts to anything more than a badge of honor) so far eludes me. Which, I'm sure some would retort, only shows how small my mind still is at this point.

## Other programming/CS resource lists

- [Teach Yourself CS](https://teachyourselfcs.com/)
- [p1xt Computer Science and Programming](https://github.com/P1xt/p1xt-guides)
- [Open Source Society University](https://github.com/ossu/computer-science)