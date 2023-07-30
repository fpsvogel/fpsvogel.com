---
title: My plain-text reading list
subtitle: now with statistics, and feature-complete!
description: How I quit Goodreads, moved to a CSV reading log, and built a parser for it in order to share favorites and statistics on my site.
---

- [The new statistics feature](#the-new-statistics-feature)
- [Flashback to summer 2020](#flashback-to-summer-2020)
- [Next came the Reading gem](#next-came-the-reading-gem)
- [Why I'm so glad to have finished this project](#why-im-so-glad-to-have-finished-this-project)
  - [Sticking it to my teenage self](#sticking-it-to-my-teenage-self)
  - [Building something new](#building-something-new)
  - [Moving on](#moving-on)

I've added a new page to this site, [Reading Statistics](/reading-stats/), thanks to a new version of my [Reading](https://github.com/fpsvogel/reading) Ruby gem, which has been the force behind my [Reading List](/reading/) page.

This post is mostly a recap of how the Reading gem came to be, as a way to celebrate it now being feature-complete. But first, here's a glimpse into the new feature.

## The new statistics feature

At its core are **strings containing statistics queries**. For example, to get the data for the charts that you see on the Reading Statistics page, I pass these query strings into the `Reading::stats` method (along with the items previously parsed by `Reading::parse`):

- `"amount by genre rating>3"` for my favorite genres. This gives the total pages read of 4- and 5-star items, by genre.
- `"amount by year, genre"` for what genres I've read each year. This gives the total pages read in each genre, by year.
- `"average rating by genre"` for how I feel about each genre.
- `"total items by rating"` for my rating distribution.
- `"top 10 amounts"` for my longest and/or most re-read items. This gives the ten items with the highest amount read.
- `"top 10 speeds"` for my fastest reads. This gives the ten items with the highest reading speed (pages per day).

The last chart (*"Most annotated items"*) is an example of a DIY query that doesn't call `Reading::stats` but instead manipulates the array of Items directly:

```ruby
items
  .map { |item|
    notes_word_count = item
      .notes
      .sum { |note|
        note.content.scan(/[\w-]+/).size
      }

    [item, notes_word_count]
  }
  .max_by(10, &:last)
```

After each of these queries, in order to get the data ready to pass into the charts, a few lines of data manipulation are needed (which you can see [here in the code for my site's reading list builder](https://github.com/fpsvogel/blog-2021/blob/main/plugins/builders/load_reading_list.rb#L72)). But the real work of parsing and analyzing the reading log has already been done by the Reading gem.

So that's the new feature. It's more thoroughly documented [in the gem's README](https://github.com/fpsvogel/reading#get-statistics-on-your-reading).

This is the last feature that I'd planned, and it's done! 🎉 To celebrate the gem being feature-complete, here's the story of how it came to be.

## Flashback to summer 2020

I'd just quit my teaching career. I was learning programming while working in e-commerce customer support, to pay the bills. My wife and I had just lost our first baby early in the pregnancy, and in the process she got so sick that she was bedridden for a month. And because the pandemic was in full swing, we were alone.

It was a rough time.

But there were bright spots. One of them was **having more time to read** now that I wasn't an English teacher (ironically).

I also spent more time **reflecting on my reading**: not just tracking what books I was reading (which I'd been doing for a few years already on Goodreads), but now I started taking notes on the books that I wanted to engage with more deeply.

I soon realized I needed a single place to store my notes, or else I'd lose them. Ideally I'd keep my notes **in the same place where I tracked my reading**, so that I wouldn't have to keep two separate lists. But taking notes in Goodreads is surprisingly unintuitive. On top of that, I didn't love Goodreads even for tracking my reading.

So I decided to ditch Goodreads. I exported my Goodreads data and converted it into **a plain-text reading log in a CSV file**, which [I wrote about in a blog post](/posts/2020/readcsv).

I found that using a plain-text reading log was actually delightful, thanks to [the Rainbow CSV extension](https://marketplace.visualstudio.com/items?itemName=mechatroner.rainbow-csv) for VS Code. It's also nice to have a keyboard shortcut that adds a row template, to reduce boilerplate typing. I made that with [an AutoHotkey script](https://github.com/fpsvogel/reading/blob/main/doc/autohotkey-reading-row-shortcut.ahk) and later with [a Ruby scriptg](https://github.com/fpsvogel/reading/blob/main/doc/ruby_reading_csv_row_shortcut.rb).

The one problem with my new approach was that **I didn't have a way to see a list of my top-rated books and share it with friends** (the single benefit I got from Goodreads). Manually keeping a separate list of my favorites would take too much time and would be error-prone, and so my next thought was, to quote [an xkcd comic](https://xkcd.com/1319/), *"I should write a program automating this!"*

Over the following months I wrote a parser for my reading log in Ruby, which I'd just started learning in my nascent career switch. It morphed into a nifty CLI app for showing reading statistics, which you can see in action [in its GitHub repo](https://github.com/fpsvogel/readstat#readstat).

## Next came the Reading gem

In 2021 when I discovered [Bridgetown](https://www.bridgetownrb.com) and rejoiced that I didn't have to dive into Ruby on Rails quite yet, I [used Bridgetown to build this site](/posts/2021/build-a-blog-with-bridgetown) and **finally realized my dream of sharing my favorite reads** by making a Reading List page that's automatically updated by my CSV parser.

In the process, I rewrote the CSV parser and split it out from my statistics CLI app, which I'd never ended up using because **it's too much effort to fire up a terminal and write out a bunch of queries** just to satisfy my curiosity about my reading habits.

Then I wondered, could *more automation* solve that problem? What if I had a separate page on my site with charts showing my reading statistics, which was **automatically updated** in the same way as my Reading List page?

As much as I liked the idea, I reluctantly shelved it because I had to get on with life: for the next two years I was busy learning Rails, getting my first developer job, moving into our first house, and having a baby.

But now I've circled back and re-written the statistics part of my old CLI app, integrated it into the Reading gem, and finally added the Reading Statistics page. The quest is now completed 🧙

## Why I'm so glad to have finished this project

### Sticking it to my teenage self

All my life I've found it easy to *start* projects, but tremendously difficult to *finish* them.

In fact, I learned some coding way back in high school, but never got anywhere close to finishing a project, due to my lack of discipline. So now it's as if **I'm vindicating myself, proving to myself that I'm not that aimless teenager anymore**. It feels great to finish a major effort that I started three years ago, even going beyond what I originally envisioned.

### Building something new

It also feels good to have built something that is genuinely **new**, that no one else has built in quite the same way. Yeah, it's extremely niche: my gem has only 3 stars on GitHub, compared to the 300+ stars of [my "Learn Ruby" list](https://github.com/fpsvogel/learn-ruby). But it's *original*, and in my head that adds some imaginary stars to the total (as well as the fact that I use the gem a lot myself).

It's true that some other projects overlap with my efforts:

- Jamie Todd Rubin [has written](https://jamierubin.net/2014/12/07/joys-of-a-text-based-reading-list/) about [his plain-text reading list](https://jamierubin.net/2015/06/27/maintaining-my-reading-list-as-a-github-repo-using-atom-1-0/) and [automation around it](https://jamierubin.net/2014/01/18/automating-my-reading-list-a-case-study-in-the-versatility-of-text-files/). (And [here's the GitHub repo](https://github.com/jamietr1/reading-list).)
- The [bamos/reading-list](https://github.com/bamos/reading-list) GitHub repo is another plain-text reading list (this one in YAML format) that automatically gets published to a website.
- [Jelu](https://github.com/bayang/jelu) is a "self-hosted 'personal Goodreads'", to quote its README. It's not in plain text, of course, but it does let you own your reading data, which is equally rare.

But even if I'd known of these projects three years ago, I still would've gone ahead with this project because I track and annotate my reading in ways that would be more complicated if I were to use these other approaches.

### Moving on

And of course, it's nice to move on to other projects after three years working on this one. I've been thinking about making a game, as [I recently wrote about](/posts/2023/why-make-a-text-based-game). That would be another way to show up my teenage self, because back then my dream was to make a game, but really all I did was *play* games 🙄

I still plan giving the Reading gem a 1.0 release after (presumably) bug fixes and code cleanup. And eventually I might integrate it with a social network, maybe [BookWyrm](https://bookwyrm.social/) (the Fediverse alternative to Goodreads) once it has a public API. (Even if I *wanted* to integrate with Goodreads, at this point I couldn't because the Goodreads public API has been largely discontinued…)

But those goals are not urgent, and for now **I'm enjoying the feeling of freedom** after finishing a years-long project.
