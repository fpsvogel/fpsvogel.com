---
title: Making myself a reading log
subtitle: freedom in plain text
description: How I quit Goodreads, tracked my reading in a plain text file, made a Ruby gem to parse and query it, and learned how to be a better reader along the way.
---

- [In the beginning, there was Goodreads](#in-the-beginning-there-was-goodreads)
- [And then I went off the deep end](#and-then-i-went-off-the-deep-end)
- [That was a lot of work. Was it worth it?](#that-was-a-lot-of-work-was-it-worth-it)
- [OK, but what are the downsides?](#ok-but-what-are-the-downsides)

Have you ever wanted to track your reading in an excruciatingly-detailed plain text file that is programmatically parsed, queried, and visualized in charts?

I did, and you can see the result on my site's [Reading](/reading) and [Reading Stats](/reading-stats) pages.

This isn't a new project: it's been two years since I seriously worked on it. Nor is it popular, judging by its single-digit [GitHub stars](https://github.com/fpsvogel/reading).

But I want to reflect on it as a tool that I shaped for myself, and which ended up reshaping how I read.

## In the beginning, there was Goodreads

I used to track my reading with Goodreads. I didn't love it, partly because of UI annoyances, and also because whenever I started reading an obscure old book that wasn't in the database, I had to [post it in a forum thread and wait for weeks until someone added it](https://help.goodreads.com/s/question/0D58V00006itkBzSAI/adding-a-new-book). It felt unnecessary when all I needed was a place to save basic info on books I had read, mostly for my own later reference.

So I quit Goodreads and switched to an offline reading log. Just a plain text file:

```
\Rating|Title|Start date|End date
5|📕Goatsong: A Novel of Ancient Athens|2020/1/19|2020/2/16
4|🔊The Jedi Doth Return -- William Shakespeare's Star Wars, #6|2020/2/1|2020/2/10
```

I could edit it on my phone (synced to Dropbox) but it looked best in VS Code with the [Rainbow CSV](https://marketplace.visualstudio.com/items?itemName=mechatroner.rainbow-csv) extension:

![a simple reading log viewed with the Rainbow CSV extension for VS Code](/images/reading-log-simple.png)

I enjoyed the simplicity, but it came with a downside: I felt (unexpectedly) like I needed a public list of my top-rated books. I guess the "showing off" aspect of Goodreads had been more important than I'd consciously realized.

So I wrote a Ruby script that parsed and filtered my reading log, so that my site could show a list that was shorter and more readable than a wall of plain text.

It wasn't great having to rebuild my site locally in order to update that list, so I hooked up my script to Dropbox (where my reading log is synced), set up weekly builds for my site via GitHub Actions, and voilà! I had an auto-updating public list of favorite books from my reading log.

## And then I went off the deep end

Now that I was parsing my reading log, I wondered what more I could track and query.

And so it was that my humble text file grew to encompass a lot more than just titles and dates and ratings:

- formats
- editions
- sources
- length: page count or time duration—because I also started tracking podcasts and documentaries
- history: not just start and end dates, but also more fine-grained history (*"I read X pages over Y days*") or a regular cadence (*"I listen to X episodes per week, and an episode is Y minutes long"*)
- notes

All of this, by the way, on a single line per entry. And then there were *new* kinds of entries, like single-line lists of to-be-read titles in a particular genre.

I knew I had to call it done and stop adding features when I started consulting [my format guide](https://github.com/fpsvogel/reading/blob/main/doc/csv-format.md) to remind myself of the syntax 😅

And yet, my reading log is still fairly readable (to me) thanks to Rainbow CSV:

```
\Rating|Title|Sources|Start|End|Genres|Length|Notes|History
4|🎤Radio Ambulante|https://radioambulante.org|||spanish|0:30 each||2024/10/19 En Este Pueblo no Hay Ladrones (22 Nov. 2016) -- ..11/23 x1/day -- 2025/01/05..
3|🔊P. G. Wodehouse - Extricating Young Gussie|https://youtu.be/a5ozA7DZcMk|2025/08/12|2025/08/12|fiction|0:40|The first Jeeves story.
2|DNF 10% 🌐Google SRE book + workbook|https://sre.google/sre-book/table-of-contents https://sre.google/workbook/table-of-contents|2025/07/11|2025/07/25|tech|1000|Not completely devoid of value, but I want to learn better monitoring strategies, and I found that simply having conversations with my team is more effective. E.g. in [...]
```

![entries from my current reading log, which are more complex but still readable thanks to Rainbow CSV](/images/reading-log-complex.png)

## That was a lot of work. Was it worth it?

It was worth it! Tracking my reading *in the way that I like* has made me a better reader.

I used to take notes in various places, digital and physical, that I would invariably lose track of. But now my notes go straight into my reading log, on the same line as the book they refer to (highlighted in teal in the screenshot above).

It's also easier for me to keep track of books that I want to read or reread.

And there are more benefits that I haven't yet explored. For example, I sometimes look for recommendations by going to the Amazon product page of a book that I like, browsing the "Customers also bought or read" section, and looking up any intriguing titles on Goodreads. I could automate this somewhat tedious task, and make my reading log CLI show lists of recommended books and their Goodreads ratings.

That would be yet another feature that popular book tracking platforms already offer, but my goal is precisely *not to to be locked into someone else's platform*, limited by their feature set, their UI, and their continued existence—or their capability (I would hope) to export my complete data when I need to jump ship.

## OK, but what are the downsides?

The syntax, as I mentioned, is extensive. And the parsing logic is correspondingly complex. If I had known how much ad-hoc syntax I would bolt onto what is essentially a CSV file, I might have started with JSONL. Here's a comparison.

In my reading log I have a podcast that I binge-listened for a few days and since then I've been listening to a new episode each week:

```
\Rating|Title|Sources|Start|End|Genres|Length|Notes|History
4|🎤Sherlock & Co.|https://www.goalhangerpodcasts.com/sherlock|||fiction|0:30 each||2024/05/02..4 x31 -- 5/18.. x1/week
```

![a podcast entry in my reading log, viewed with Rainbow CSV](/images/reading-log-psv.png)

Here's what that entry would look like in JSONL:

```
{"rating": 4, "title": "Sherlock & Co.", "genres": ["fiction"], "variants": [{"format": "audio", "length": "0:30 each", "sources": [{"url": "https://www.goalhangerpodcasts.com/sherlock"}]}], "experiences": [{"spans": [{"start": "2024/05/02", "end": "2024/05-04", "amount": "x31"}]}, {"spans": [{"start": "2024/05/18", "amount": "x1/week"}]}]}
```

![the same podcast entry, but this time in JSONL instead of my PSV-based format](/images/reading-log-jsonl.png)

This is close to the entry's final form after the shorter line above is parsed, but the JSONL actually *still* requires some parsing and data transformation (of the `length` and `amount` fields).

And I know this is subjective, but I'm glad I don't have to wade through hundreds of lines of so many braces and quotes. Call me crazy, but I find CSV (or at least PSV, i.e. with pipes) a more pleasant format for hand-editing.

Other horrifying non-issues include long regular expressions (the one for the reading history column is [94 lines long](https://github.com/fpsvogel/reading/blob/65956e74a777b8e8e4d24406e78b6440e32503e7/lib/reading/parsing/rows/regular_columns/history.rb#L36-L139)), and over 500 lines of [convoluted data transformation logic](https://github.com/fpsvogel/reading/blob/65956e74a777b8e8e4d24406e78b6440e32503e7/lib/reading/parsing/attributes/experiences/history_transformer.rb#L3-L4) for that same column. Thankfully, I'm done working through the bugs by now (I think…).

The one real bummer is not being on a reading platform where I can connect with other people. I hope that someday one of the platforms will offer an API complete enough that I can (after hacking up some additional Ruby) mostly-automatically update my account based the edits that I'm already making in my reading log. [Hardcover](https://hardcover.app/) looks promising.

But for now, I can console myself that the world of book tracking apps is so fragmented post-Goodreads-enshittification, that I don't feel like I'm missing much by not choosing a corner—or rather, by making my own little corner, where I've gained a lot by making a tool designed just for me.
