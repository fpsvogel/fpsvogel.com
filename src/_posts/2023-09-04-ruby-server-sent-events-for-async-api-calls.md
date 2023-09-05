---
title: Server-sent events
subtitle: for asynchronous API calls in a Roda app
description: To speed up a slow page full of API calls or other expensive tasks, server-sent events let you do the work after the response and stream the results back.
---

- [The paths not taken](#the-paths-not-taken)
- [Server-sent events](#server-sent-events)
- [An on-page buffer of next articles](#an-on-page-buffer-of-next-articles)
- [What's actually happening at this point](#whats-actually-happening-at-this-point)
- [A demo](#a-demo)
- [Smoothing out the rough edges](#smoothing-out-the-rough-edges)
- [Conclusion: outside-the-box lessons](#conclusion-outside-the-box-lessons)

In my last post, [I rewrote a little Rails app with Roda and Turbo Streams](/posts/2023/roda-app-with-hotwire-turbo-streams). In this post I'll show how I solved the app's last and biggest problem: **slow API calls**. *So slow* that the user had to wait *several seconds* between pressing the "Next article" button, and actually seeing a new article.

The app is called Wiki Stumble. Here's [the live site](https://wikistumble.com/) and [the GitHub repo](https://github.com/fpsvogel/wikistumble). The app shows summaries of Wikipedia articles personalized to the user's likes and dislikes.

Due to Wikipedia APIs not having that capability built in, the app has to make **multiple API calls for each article**, fetching new articles over and over until a suitable one is found.

So the question I set out to answer was, *"How can I move the API calls to happen **outside the request** that shows new content, while still sending the final results from the API calls back to the page?"*

## The paths not taken

If I were building Wiki Stumble like the large app at my work, I'd call those APIs in a background job and then store suitable articles in a database table. **But my little app doesn't use background jobs or even a database**, and I don't want to add them unless it's really necessary.

Another option would be to use WebSockets (in Rails, see [Action Cable](https://guides.rubyonrails.org/action_cable_overview.html)). There are WebSockets setups for Roda out there (e.g. [1](https://github.com/socketry/roda-websockets), [2](https://github.com/nanne007/roda/blob/master/lib/roda/plugins/websockets.rb)), but they seem more complex than I need—after all, WebSockets enable two-way async communication between the client and server, but **I only need to send async messages *one-way*** from the server to the client.

My search for lightweight, async server-to-client communication led me to…

## Server-sent events

[This article by Julia Evans](https://jvns.ca/blog/2021/01/12/day-36--server-sent-events-are-cool--and-a-fun-bug/) is a great introduction to server-sent events, a.k.a. EventSource. It's like half of WebSockets, but over HTTP! 🤯

Adding server-sent events to Wiki Stumble was pretty straightforward, thanks to a Turbo Streams integration. (It doesn't seem to be documented apart from [this PR](https://github.com/hotwired/turbo/pull/415). Thanks to Ayush Newatia, author of [The Rails and Hotwire Codex](https://railsandhotwirecodex.com/), for pointing me to that PR over at [The Spicy Web](https://discord.gg/CUuYVH7Qa9) Discord.)

All I had to do was add `<turbo-stream-source>` elements to the page, like this:

```html
<turbo-stream-source src="/next"></turbo-stream-source>
```

Then I added the `GET /next` route, which you can [see here in its first iteration](https://github.com/fpsvogel/wikistumble/blob/62bd341c378a4f7040ad8177443b5110a6b5088d/app/router.rb#L91-L138). (Later I rewrote some of that code for performance reasons; see below on Rack hijacking.)

One gotcha is that connections need to be manually closed on the client side, or else the GET endpoint will keep getting hit even after the `<turbo-stream-source>` is no longer on the page. So I wrote [a Stimulus controller](https://github.com/fpsvogel/wikistumble/blob/4d5d48332a8dc27c278af9cfdaae4232c0866324/public/app.js#L16-L36) that closes each connection when its `<turbo-stream-source>` element is disconnected.

If you're not familiar with Stimulus, see the handy demo on [the Stimulus home page](https://stimulus.hotwired.dev/).

## An on-page buffer of next articles

Server-sent events allowed Wiki Stumble to return a response before the next article was done being fetched. Great!

But on its own, **this isn't enough.** At best, in place of the old article, the user would see a placeholder with a loading spinner until the next article was loaded 🤮 And the wait time wouldn't actually be any shorter.

I needed **a buffer** of next articles, preferably *several articles* just in case the user is button-happy and advances to the next article several times in quick succession. The tradeoff is that changes in the user's category preferences won't immediately be reflected in the next articles, but I think the performance gain is worth it.

Since I'm not using a database, this buffer has to be stored on the page itself. I decided to use **hidden inputs** in a form. (I also thought about putting the buffer in the session cookie, which already stores the current article and the user's category preferences. But the session cookie isn't big enough to fit all that.)

## What's actually happening at this point

Here's an outline of what happens when the user advances to the next article:

1. The buffer of next articles is submitted as part of the form.
2. On the server side, the first next article is taken from the buffer and immediately sent back in a response, using Turbo Streams to replace the old article with the new one.
3. In the same response, Turbo also removes the first next article from the buffer (the article that the user is about to see), and adds a `<turbo-stream-source>` to the end of the buffer.
4. The user sees a new article and is happy 👍
5. Meanwhile, the newly-added `<turbo-stream-source>` sends a GET request that fetches a new article. It takes a few seconds, but that's not a problem thanks to the buffer of next articles.
6. After the new article is fetched, a Turbo Streams response replaces the `<turbo-stream-source>` with hidden inputs containing the fields of the new article.
7. My Stimulus controller sees that the `<turbo-stream-source>` has been replaced, and proceeds to close that particular connection with the server.

## A demo

You can see all this in action by observing the invisible article buffer in the browser's DOM inspector. Here's a view of when I refresh the page and then rapidly advance through articles:

![A demo of Wiki Stumble, with the browser's DOM inspector open showing the hidden fields of the article buffer being asynchronously filled.](/images/wiki-stumble-demo.gif)

## Smoothing out the rough edges

The app wasn't as smooth as in the demo above until I made a few improvements:

1. The first page load was still slow, because the buffer was starting out empty.
2. The next articles buffer was being filled sequentially rather than concurrently, so the user could easily advance through new articles faster than the buffer was being filled. And when the buffer was emptied, the app would stall and feel slow again.
3. Each connection was occupying a server thread, and since connections were open for several seconds at a time waiting for next articles, the app would slow down if more than a handful of people (or tabs) were using the app simultaneously.

Here's how I solved each of these in turn.

**#1. Show a pre-selected few articles at the beginning.** OK, I'll admit I cheated a little bit here. Now when a user loads the app for the first time (i.e. when there is no session cookie), an article is shown and two others are buffered which are hard-coded into the app. While the user is busy with those first three articles, the app has time to fetch more and add them to the buffer. *(If you still noticed a slow first load time, it's because I'm on Render's free plan and it takes a moment for the instance to spin up.)*

**~~#2 and #3. Increase the thread count.~~** Initially I mitigated these problems by raising Puma's thread count and increasing the size of the article buffer. To raise the thread count, I simply created a file `config/puma.rb` containing `threads 0, 16`. (The first number is the minimum and the second is the maximum number of threads. Puma defaults to 0-5 threads for MRI Ruby.) **However**, more threads made these problems **only slightly less bad**, so I looked for another solution, and found it.

**#2 and #3. Use the Rack hijacking API.** I followed [this guide](https://blog.chumakoff.com/en/posts/rails_sse_rack_hijacking_api) to use Rack hijacking to offload the long API calls from the server threads. This way, all the next articles are fetched simultaneously, and most of the buffer is filled up in the same time it takes to fetch one article, even if I set a maximum of one server thread! 😮

[Here](https://github.com/fpsvogel/wikistumble/blob/4d5d48332a8dc27c278af9cfdaae4232c0866324/app/router.rb#L110-L135) and [here](https://github.com/fpsvogel/wikistumble/blob/4d5d48332a8dc27c278af9cfdaae4232c0866324/app/helpers/stream_helper.rb) is what my streaming code looks like now.

**Side note:** Rack full hijacking feels pretty hacky, but I didn't have much luck with the cleaner approaches that I tried: partial hijacking, [returning a streaming body](https://github.com/rack/rack/pull/1745), and swapping out Puma for the highly concurrent [Falcon](https://socketry.github.io/falcon/) web server. Still, I want to try Falcon again sometime because it's part of the async Ruby ecosystem, which looks great. [Here's an introduction to async Ruby.](https://brunosutic.com/blog/async-ruby) But for now, I've contented myself with Puma and Rack full hijacking because Wiki Stumble performs well enough that way.

## Conclusion: outside-the-box lessons

The "before and after" of Wiki Stumble's performance is like **night and day**. Previously, as a user I had to wait up to **several seconds** to see a new article. Now I can merrily flick through articles, with **instantaneous** loading times.

But the real reason I'm happy with my work on Wiki Stumble is that in order to reach that performance improvement *without adding more layers to my stack*, **I had to think outside the box**, and I learned a lot as a result 💡

I hope my little adventure has helped you learn something, too. Or if not, you could head over to [Wiki Stumble](https://wikistumble.com/) and see if a bit of Wikipedia-surfing will change that 🤓
