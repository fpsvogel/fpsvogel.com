---
title: A StumbleUpon-style Wikipedia explorer
subtitle: "lightning Rails app #2"
---

- [New things I did in this app](#new-things-i-did-in-this-app)
- [The technical challenge](#the-technical-challenge)
- [The verdict: will I continue work on this app?](#the-verdict-will-i-continue-work-on-this-app)

Occasionally I get the urge to read Wikipedia. Not on a particular topic, just… whatever is out there. But how can a person explore Wikipedia? Here are some existing approaches:

- [Most popular articles](https://wikirank.net/) in each category. But many of the top articles are about common knowledge, and they don't change much over time, so this isn't a great way to browse.
- [The "unusual articles" list.](https://en.wikipedia.org/wiki/Wikipedia:Unusual_articles) It's a fun list, but eventually you reach the end of it.
- [Featured articles](https://en.wikipedia.org/wiki/Wikipedia:Featured_articles) and [good articles](https://en.wikipedia.org/wiki/Wikipedia:Good_articles) are also good lists, though a bit overwhelming. An easier approach is [a random featured article](https://randomincategory.toolforge.org/Featured_articles?site=en.wikipedia.org) or [a random good article](https://randomincategory.toolforge.org/Good_articles?site=en.wikipedia.org).
- [Wikipedia:Explore](https://en.wikipedia.org/wiki/Wikipedia:Explore) links to several topic-based lists.
- [The "Random page in category" tool.](https://randomincategory.toolforge.org) But its usefulness is limited because of how chaotic Wikipedia's categories are. (More on that below.)
- [A world map](https://copernix.io/) showing geographically-placed articles.

What I really wanted, though, was a way to get personalized recommendations of articles, like [StumbleUpon](https://en.wikipedia.org/wiki/StumbleUpon) but for Wikipedia. That way I could avoid some of the hit-or-miss results of browsing random articles, and I wouldn't have to wade through topic lists either.

So I've built [Wiki Stumble](https://wikistumble.herokuapp.com/), a little app that suggests Wikipedia articles based on user-selected categories and also based on the user's reaction (thumbs up or down) to previous recommendations. [Here's the GitHub repo.](https://github.com/fpsvogel/wikistumble)

This is my second "lightning app" this month, so named because I'm making them in the spare hours of a day or two each. In the end I'll choose one or two to continue expanding while I learn better Rails testing skills. These lightning apps are simple and intentionally leave out a lot of features, but I'm still trying to do something new in each one.

## New things I did in this app

- Used the Wikipedia APIs.
- Wrote more tests this time around, again using RSpec. (I've mostly used Minitest until recently.) I wrote most of my tests toward the end, because for this app I wasn't sure how I would implement the main feature and how it could be tested, until I actually tried building it (more on that below). Still, I have plently of tests now, and I did manage to [sneak in some TDD](https://github.com/fpsvogel/wikistumble/commit/4281145325268afc0d56d1c4c8cb95f6836643e4#diff-b86f796c2cf34f7b413473d8caa19b6b0701757729fe74008aa8d6ee97621bbb) for [improvements toward the end](https://github.com/fpsvogel/wikistumble/commit/b19fb40f31e2123e6939a2f2a4040e466328979c#diff-b86f796c2cf34f7b413473d8caa19b6b0701757729fe74008aa8d6ee97621bbb).
- Gave Bootstrap another chance. I've [avoided it in recent projects](https://github.com/vinorodrigues/bootstrap-dark-5#method-4), but I wanted to try it again; after all, I already know my around Bootstrap, so the learning curve would not be an issue. After I [installed a Bootstrap theme](https://bootswatch.com/help/) for a slightly less generic look, I tackled one of Bootstrap's big deficiencies: the lack of a dark mode. I [followed this guide](https://github.com/vinorodrigues/bootstrap-dark-5#method-4), but in the end I abandoned the effort because it was giving me too many problems. Someday when Bootstrap finally includes a built-in dark mode, I might use it in a personal project. For now, I chose [PaperCSS](https://www.getpapercss.com) again.

## The technical challenge

Unlike my first lightning app, which was nothing more than a simple interface to an API, this second app posed a real challenge: how to retrieve Wikipedia articles based on category preferences? You'd think it would be straightforward, just a matter of an API call to get a random article within a set of given categories. But it is not so simple, for two reasons.

First, the Wikipedia API has endpoints for retrieving a specific page and a random page, but nothing in between. The [random page in category](https://randomincategory.toolforge.org) tool fills the gap somewhat, but it is slower than the API. There is an API endpoint for getting an article's categories (e.g. `https://en.wikipedia.org/w/api.php?format=json&action=query&prop=categories&titles=Chartwell&clshow=!hidden&cllimit=100`), which might have been useful, except there's the other problem…

Wikipedia's categories are a mess. An article's categories are usually very specific and therefore useless, and the only way to get more general categories for an article is to traverse the category graph upward. But since the graph is not a tree or even a [DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph), you would need to come up with a complicated and time-consuming algorithm to do this. [Here's someone's valiant attempt.](https://stackoverflow.com/a/65859846/4158773) No, thanks.

The surprising answer to this conundrum was not far away—[just below that same StackOverflow answer](https://stackoverflow.com/a/65801715/4158773), in fact. Evidently, Wikimedia uses AI to analyze each article and guess at its general categories, using a different taxonomy than Wikipedia's categories. These category predictions are conveniently accessible via an API, and they are a crucial part of how Wiki Stumble works. When the user presses "Next article", here's what the app does:

1. Get several random articles over the Wikipedia REST API. The exact number of requested articles varies, depending on whether the app finds a good match soon or not. (Also, if the user has chosen to see only Good or Featured articles, then the app takes the extra step of getting article URLs using the "random page in category" tool.)
2. Get these articles' category predictions via the ORES API.
3. Choose a best match by comparing each article's predicted categories to the user's category preferences, which the user has previously expressed either by choosing some starter categories, or by giving feedback (thumbs up or down) to previously recommended articles, or both.
4. Show the best-matching article to the user.
5. If the user gives a thumbs up or down to the article, then adjust the user's category preferences with a +1 or -1 to the article's predicted categories.

This is a lot of back-and-forth using several APIs, but still the app is reasonably fast, and certainly a lot faster than using the "random page" links, with their frequent duds that you're not interested in.

## The verdict: will I continue work on this app?

Yes, I will. I abandoned [my first lightning app](/posts/2021/gpt3-ai-story-writer) because after the proof-of-concept stage I didn't have a strong sense of where to take it next, or what value it would provide other than pure entertainment that can already be had on other similar sites. Plus, even that value was provided not by my app, but by the GPT-3 API for which my app was merely a convenient interface—and in the long run I would have to pay to use that API. But this time, I'm solving a problem in a way that no one else has done (as far as I know), and the app provides clear value in improved access to knowledge, all while using Wikipedia's free API.

Also, this time I more clearly see what features need to be added on to this minimal proof of concept. Just to name a few:

- User accounts to save personalization data and liked articles.
- A better way to choose starter categories, because writing them into a text field is a little clunky.
- More fine-grained control over a user's category preferences, in case the user wants to manually edit them.
- Faster tests. Currently my system tests make real API calls, which makes them slow. *UPDATE: I finished reading Jason Swett's [Complete Guide to Rails Testing](https://www.codewithjason.com/complete-guide-to-rails-testing/), which [taught me how to use WebMock and VCR](https://www.codewithjason.com/vcr-webmock-hello-world-tutorial/) to speed up my system tests. Now they take just one second instead of half a minute. [Here's the commit.](https://github.com/fpsvogel/wikistumble/commit/2609a345c034174cc54b708f5711034ebae1a0ea)*

But first, on to the third (and final) lightning app!
