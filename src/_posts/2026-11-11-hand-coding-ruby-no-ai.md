---
title: Hand coding a feature in a Ruby gem
subtitle: how often and how early do I quit a book?
description: In my reading log Ruby gem, let's build a feature to find out how often and how early I DNF (quit) a book, with handcrafted code and no AI.
---

- [This year](#this-year)
- [The idea](#the-idea)
- [How often do I quit?](#how-often-do-i-quit)
- [How early do I quit?](#how-early-do-i-quit)
- [Adding a test](#adding-a-test)
- [Making the CLI output prettier](#making-the-cli-output-prettier)
- [Showing the new stats on my website](#showing-the-new-stats-on-my-website)
- [Why hand coding?](#why-hand-coding)

A full year since my last programming post, recharged by months of being offline LARPing as a normal person, I'm ready to make my grand re-entrance to the Internet.

Ready for it?

Today I'll walk you through adding a small feature to a little Ruby gem I made a few years ago.

*Audience:*&emsp;【・_・?】

I'm pretty sure I'm the only person who uses my gem.

*Audience:*&emsp;(￣(エ)￣)ゞ

Oh, and we'll do it entirely by hand. No AI!

*Audience:*&emsp;<nobr>(ง ˃ ᗜ ˂)و ̑̑</nobr>&emsp;<nobr>ヾ(｡★ω★｡)ｼ</nobr>&emsp;<nobr>٩(ˊᗜˋ*)و ♡</nobr>&emsp;<nobr>₍₍⚞(˶˃ ᵕ ˂˶)⚟⁾⁾</nobr>

(At least, that's how I feel these days when I come across a human-written blog post with human-written code.)

## This year

This year, feeling disoriented because *&lt;gestures all around&gt;*, I hoped that taking a break from programming outside of work would help me step back and think of a brilliant plan of what to focus on next. Something that would take my skills to the next level, and be super impressive, and win me accolades and things like that. *And* not involving AI, for the sake of my soul and all that is good in the world.

I'm still figuring that out, so in the meantime here's a random little coding adventure that I hope rises from insignificance for its being entirely from my brain and transmitted to you via my meaty fingers, one character at a time. Except the kaomojis.

## The idea

I have an old Ruby gem that parses my CSV reading log ([backstory here](/posts/2025/goodreads-to-plain-text-csv-reading-log)) which I occasionally augment with a new feature, e.g. earlier this year I added a way to specify when I've changed a rating, so that now [my reading page](/reading) on this blog has a juicy section at the bottom with books that *used* to be rated high enough to be in the main list but which I've downgraded in rating because I realized they are not my favorite or in some cases I was flat-out dumb for thinking they were any good at all.

Anyway, the other day I was basking gleefully in the thought of quitting yet another book (which always gives me a rush, it's basically what I live for), and I marveled at how often and how early I DNF ("Did Not Finish"). Then I wondered: just *how often*, and generally *how early* do I DNF?

It sounded like a new feature for my Ruby gem! So in my head I dropped everything, sprinted to my computer, and mashed out a new gem version amid maniacal laughter. In reality, I went about my day and worked on it after my children were in bed (so, no maniacal laughter allowed, or at most whispered).

## How often do I quit?

My Reading gem includes a language for querying for reading statistics, used either via CLI or (as in my website) via Ruby. I need queries to be able to answer my two questions: *how often* and *how early* do I DNF?

Queries can actually already answer the first question: there is [a stats filter](https://codeberg.org/fpsvogel/reading#stats-filters) for progress, so I can run the CLI with a query including that filter:

```
reading '(path to my reading log)' 'count status=done progress<100%
```

That prints the number of done items that I didn't actually finish 100%: `292 items`.

Thus, I can answer my "how often" question by dividing 292 by 1010, which is the query result for the count of all done items of *any* progress. That gives me a result of about 28.9%. So I DNF over a quarter of what I start. Cool.

## How early do I quit?

Now my other question: *how early* do I tend to DNF? This part is not yet built in: [the list of stats operations](https://codeberg.org/fpsvogel/reading#stats-operations) doesn't include `average progress`. So let's add it!

[A giant hash](https://codeberg.org/fpsvogel/reading/src/tag/v1.4.0/lib/reading/stats/operation.rb#L73-L283) contains all the stats operations, each implemented in a proc (a function, for you non-Ruby folk). In it I add:

```ruby
  # ...
  average_progress: proc { |items|
    experiences_with_progress = 0
    total_progress = items.sum { |item|
      item.experiences.sum { |experience|
        amount = experience.spans.sum { |span|
          span.amount * (span.progress || 0.0)
        }.to_i
        length = item.variants[experience.variant_index].length
        next 0 unless length
        experiences_with_progress += 1
        amount.to_f / length.to_i
      }
    }

    total_progress / experiences_with_progress
  },
  # ...
```

Notes:

- You can see an item's full structure in [this hash in the config file](https://codeberg.org/fpsvogel/reading/src/tag/v1.4.0/lib/reading/config.rb#L143-L200), except that actual items are made up of Data objects to allow dot access such as `item.experiences` rather than the cumbersome and error-prone `item[:experiences]`.
- An item's "experiences" describe the different times I've read it, listened to it, watched it, etc.
- An experience contains one or more "spans", each of which has an amount and progress. Example: as I listen through a podcast (an experience), I'm listening to an episode (a span), which is two hours long (amount) and I decide to quit after one hour (progress).
- An item's "variants" represent different editions or different media. Each has its own length, or (in the case of some podcasts) no defined length at all, in which case it doesn't make sense to calculate progress, so those aren't counted.
- I use `to_i` to make sure amounts/lengths are changed into a page count, if they are a time value (for audiobooks and podcasts).

Now when I run:

```
bin/reading '(path to my reading log)' 'average progress status=done progress<100%'
```

I get `0.22654625583348637`. So the answer to my second question is that on average, I DNF at about 22.7% into a thing. That shows remarkable perseverance for a DNF junkie like me.

## Adding a test

Let's write a test for this new feature.

In this gem I tend to use large sets of feature tests instead of unit tests. I don't find unit tests to be worthwhile when the feature tests run so quickly. (The test suite of 464 test cases in about 0.12 seconds.)

In these feature tests, I define data for tests separately from the test cases themselves, which are automatically generated from the data. Case in point: the test file for stats defines inputs and outputs for [a bunch of queries](https://codeberg.org/fpsvogel/reading/src/tag/v1.4.0/test/stats_test.rb#L11), then the file ends with [a comparatively few lines](https://codeberg.org/fpsvogel/reading/src/tag/v1.4.0/test/stats_test.rb#L2160) that generate test cases from that data. I say "comparatively few" because the file is over two thousand lines long—before you pop a blood vessel, I will note that navigating these behemoth test files is not too difficult: to find tests for a specific stats operation, filter, etc., all I need to do is grep for its name.

This separation of test data makes it easy to add a new test: copy-paste existing test data for another stats operation, then tweak the name and expected result, and make sure the items hashes contain all the fields expected by our implementation. (Test data does not contain realistic item hashes in the sense of including all empty fields, the ones you saw [in the config file](https://codeberg.org/fpsvogel/reading/src/tag/v1.4.0/lib/reading/config.rb#L143-L200). Otherwise test files would be even more gigantic, and meaningful test data would be harder to spot amid the noise.)

Here's our new test data, from which a new test case is automatically generated:

```ruby
  # ...
  :"average progress" => {
    input: "average progress",
    # assuming 35 pages per hour (the config default)
    result: 0.425, # 170% / 4 (sum of percentages / number of experiences)
    items: [
      # 20%, 100%
      { experiences: [{ spans: [{ amount: 35, progress: 0.2 }], variant_index: 0 },
                      { spans: [{ amount: 35, progress: 1.0 }, { amount: Reading.time("1:00"), progress: 1.0 }], variant_index: 1 }],
        variants: [{ length: 35 }, { length: 70 }] },
      # 50%, 0%
      { experiences: [{ spans: [{ amount: 35, progress: 1.0 }], variant_index: 0 },
                      { spans: [{ amount: 35, progress: nil }], variant_index: 0 }],
        variants: [{ length: 70 }] },
      # N/A (undefined length)
      { experiences: [{ spans: [{ amount: 35, progress: 1.0 }], variant_index: 0 }],
        variants: [{ length: nil }] },
      # N/A (no experiences)
      { experiences: [] },
    ],
  },
  # ...
```

## Making the CLI output prettier

The output I got earlier, `0.22654625583348637`, is intelligible as about 22.7%, but why don't we go ahead and make the output actually `22.7%`?

I don't want to change the proc's return value to a formatted string in our implementation above. I like to return numeric values so that API consumers (i.e. [my website's reading stats page](/reading-stats/)) can use them. So I want to change only the result that the CLI shows, without changing the value returned by the stats operation itself.

Luckily, there's already a mechanism for that: [result formatters](https://codeberg.org/fpsvogel/reading/src/tag/v1.4.0/lib/reading/stats/result_formatters.rb). All I need to do is add a new one among the CLI formatters:

```ruby
  # ...
  average_progress: ->(result) { "#{(result * 100).round(1)}%" },
  # ...
```

Voilà! The command from earlier now outputs `22.7%`.

## Showing the new stats on my website

The final touch is to show these new stats on my website's [reading stats page](http://localhost:4000/reading-stats).

To do that, I add some stats queries [to my website's plugin that fetches reading data](https://codeberg.org/fpsvogel/fpsvogel.com/src/commit/3c53e8b72ac486bbc56feb9c79e89e2b70c82545/plugins/builders/load_reading_list.rb#L123-L126):

```ruby
  dnf_count = Reading.stats("count status=done progress<100%", items:)
  finished_count = Reading.stats("count status=done progress>=100%", items:)
  stats[:dnf_rate] = dnf_count.to_f / (dnf_count + finished_count)

  stats[:dnf_average_progress] = Reading.stats("average progress status=done progress<100%", items:)
```

Then in the Markdown file for my reading stats page, I add a new section:

```
## DNF ("Did Not Finish") stats

DNF rate: <strong><%%= (stats[:dnf_rate] * 100).round(1) %>%</strong>

Average DNF progress: <strong><%%t= (stats[:dnf_average_progress] * 100).round(1) %>%</strong>
```

And with that, I am proudly telling the world about my addiction to quitting books.

## Why hand coding?

Some of you may be wondering why I did this all by hand. Wouldn't it have been faster and easier to do it with AI?

To answer that, I need to first ask a different question: what have I done, exactly? I implemented the feature, yes, but along the way I wrestled with questions that I doubt would've come up if I hadn't been working directly with the code. For example:

- What does "progress" mean, particularly for something like a podcast that doesn't always have a defined length? If I decide to stop listening to a podcast, should that be considered a DNF? The code answered these questions in some way previously, but I felt compelled to reexamine them while I was comparing the output from my gem to baseline totals that I manually calculated from my reading log. (These are the glorious moments when regex skills finally come in handy.)
- In the API, is the `input:` worth keeping as a positional argument in `Reading.stats(input: "count", items:)`? No, so I simplified to `Reading.stats("count", items:)`.

The first point may seem pedantic, but sloppy answers to this kind of question cascade into confusion over time. And if the second point seems trivial, I argue that it's an accumulation of these trivial ergonomic touches that makes a system pleasant to use.

If your answer is "just let the AI figure it out", then (a) good luck with that in a large system over the long term, and (b) even in a small system like my gem, I'd rather not be distant from the code and thus alienated from my work.

*Alienation* is an apt description, in my view, of the toll LLMs have taken on software development. We talk to each other less, and when we do, increasingly it's through AI-generated text rather than our own words. We wreak (further) havoc on the natural environments that we inhabit, the climate pledges of the 2010s now only a distant memory. We deskill ourselves and impoverish our minds while further enriching billionaires.

That's why I still prefer hand coding and do it as often as I can.
