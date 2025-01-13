---
title: A Rubyist learns Haskell, part 3
subtitle: the end
description: Why I'm giving up on Haskell, why I got into it (to better understand Ruby on Rails service objects), and why I like the Roc language better.
---

- [Why did I want to learn functional programming, anyway?](#why-did-i-want-to-learn-functional-programming-anyway)
- [Y U NO HASKELL!?](#y-u-no-haskell)
- [I discovered Roc](#i-discovered-roc)
- [… wait, but then why is that list archived?](#-wait-but-then-why-is-that-list-archived)
- [A sneak peek of what's to come](#a-sneak-peek-of-whats-to-come)

I'm giving up on Haskell, and I'm 0% sad about it *<small>(OK, maybe 5% sad because of wounded pride)</small>* because I've found something a lot more to my liking: [Roc](https://www.roc-lang.org/).

… but don't worry, you won't be seeing a "Learning Roc" series anytime soon on this blog. I'm going to get back to writing about Ruby and web development, and put my explorations of functional programming on hold.

## Why did I want to learn functional programming, anyway?

A couple years ago I posted half-baked thoughts on [OOP vs. services for organizing business logic](https://fpsvogel.com/posts/2022/rails-service-objects-alternative-to-organize-business-logic). The tl;dr is that I was intrigued about **why so many Rails developers like service objects**, and I wanted to understand them better despite my instinctive aversion to them.

As I wrote that post, I realized that some of the strongest proponents of service objects *are also fans of functional programming*. So at some later point I decided to go straight to the source and learn Haskell.

I'm glad I gave Haskell a try, but I've concluded that it's not for me.

## Y U NO HASKELL!?

Here's how it went down.

I fought my way through [Haskell MOOC](https://haskell.mooc.fi) up until Lecture 12, which is titled *"fmap fmap fmap"*… which somehow deflated my resolve to persevere through a few more lectures to the end of the course.

So I decided it was time to *build a thing:* a little CLI app that parses numbers in seven-segment display format, such as what you see on digital clocks. It's a coding exercise that I've done before in Ruby, and now I wanted to try my hand at it in Haskell.

I did finish it, but my Haskell code is… a mixed bag. In the part where the app gets user input, my code [looks horrendous](https://github.com/fpsvogel/haskell-ocr-exercise/blob/9020c21ead971bb6ca05847a3ce0b6770df27970/app/Main.hs). I'm a lot happier with the parts where I was able to write pure functions; [here's an example](https://github.com/fpsvogel/haskell-ocr-exercise/blob/main/src/Digits/Read.hs). (The commented section at the top is a *doctest*, which is what it sounds like: documentation that can also be run as an automated test. Doctest libraries exist in many languages, [including Ruby](https://github.com/p0deje/yard-doctest)!)

But in the end, the exercise didn't revive my excitement to learn more Haskell. In fact, my list of things I don't like about Haskell only grew longer:

- I find it hard to write **readable** Haskell code.
- It's not easy to read **other people's** Haskell code either.
- Writing Haskell gives me **decision fatigue** because it's so flexible and you can write in so many different styles.
- Even more decision fatigue comes from how Haskell feels like **a skeleton or "language toolkit"**, rather than batteries-included. Maybe I'm spoiled by Ruby, but I didn't like how often I had to hunt for packages and language extensions to get conveniences that I wish were built in to the language or standard library. For example, I had to use several language extensions to [access record fields with dot syntax instead of globally-namespaced accessor functions](https://github.com/fpsvogel/haskell-mooc/blob/my-solutions/exercises/Set5a.hs#L6-L14), which seems like a pretty basic feature—and parts of that are still being ironed out.
- Writing **high-performance Haskell** is not easy, from what I gather, and involves arcane Haskell-specific knowledge. Not that I'm going to write a game engine in Haskell, but coming from a Ruby background, it would be nice to have a no-frills high-performance tool in my belt since Ruby is not that.

Even people who criticize Haskell say almost unanimously that learning it was a mind-expanding experience. But after months of (albeit slowly) learning Haskell, I didn't have any grand insights. Maybe enlightenment was yet to come, but I was less and less excited about the grind in between.

So my Haskell learning slowed to a stop, and I declared it officially over when…

## I discovered Roc

Like [Gandalf and the Riders of Rohan arriving in the hour of most desperate need, ending the long night with the rays of dawn](https://youtu.be/Lc9q6nnmrGY?t=73)…

… so was my discovery of [the Roc language](https://www.roc-lang.org).

Roc's philosophy immediately clicked with me. At its core is a **simplicity** that I found lacking in Haskell, which gives it several advantages:

- It's **easier to learn**.
- It's **easier to read**, at least to my eyes. Compared to Haskell, it more often prioritizes explicitness over terseness and abstraction. See for yourself: compare ["simple" Haskell code](https://www.haskellforall.com/2015/10/basic-haskell-examples.html) to any of [the official Roc examples](https://www.roc-lang.org/examples).
- It's **performant**, [aiming to outperform the fastest mainstream garbage-collected languages (Java, Go, etc.)](https://www.youtube.com/watch?v=vzfy4EKwG_Y).
- It's **low-ceremony**, [tapping in to some of the strengths of dynamic languages](https://youtu.be/7R204VUlzGc?t=1308) (see also [the upcoming "purity inference"](https://www.youtube.com/watch?v=42TUAKhzlRI)).

I like Roc so much that it has replaced Haskell and Elixir in [my "Learn functional programming" list](https://github.com/fpsvogel/learn-functional-programming/compare/51ae0044386541fd7a34db7afb00e995eac188ae..de7a770f70e263dd4fedffcf8ee00f4ec2346d5a).

## … wait, but then why is that list archived?

Astute readers may have noticed that the GitHub repo for the above "Learn functional programming" list is archived.

In the end, I decided that I need to refocus my learning efforts: I want to explore some other problems **closer to my roots in web development**. Now that I've discovered Roc, it's a good time to pause my foray into functional programming. Since Roc is a very new language, its syntax is still in flux, and I run into compiler errors now and then. So it'll be a nicer learning experience if I come back to it later.

But I don't want to discourage *you* from looking into Roc. These days I'm being extra careful with my time commitments for family reasons (namely, a toddler and baby #2 on the way), but if you're less inundated and you have any interest in functional programming, you should totally try out Roc. For Roc learning resources, check out [my "Learn functional programming" list](https://github.com/fpsvogel/learn-functional-programming). The links there are still up to date, as of October 2023.

## A sneak peek of what's to come

Since my enthusiasm for Haskell has run out and half of this post wasn't about Haskell anyway, I think it's safe to say this series is over.

Here's a peek into (probable) upcoming posts:

- [Alpine.js](https://alpinejs.dev) compared to [Stimulus](https://stimulus.hotwired.dev)
- A CLI tool for doing [Advent of Code](https://adventofcode.com/) puzzles in Ruby
- ~~Another rewrite of my little app [Wiki Stumble](https://github.com/fpsvogel/wiki-stumble), this time in… JavaScript 😱~~ *UPDATE: I decided not to do this one because, while it totally makes sense and is what I "should" have done from the beginning, I'm just not excited about it.*
- Finally continuing to build my [text-based game framework in Ruby](https://github.com/fpsvogel/worlds-terminal).
