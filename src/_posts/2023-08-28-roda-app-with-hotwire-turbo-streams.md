---
title: Roda + Turbo Streams = ❤️
subtitle: porting Wiki Stumble from Rails
description: I rewrote a Ruby on Rails app in Roda, using Turbo Streams for an SPA-like feel. And you can too!
---

- [Roda, the DIY framework](#roda-the-diy-framework)
- [Dropping in Turbo Streams](#dropping-in-turbo-streams)
- [Up next: improve performance](#up-next-improve-performance)

Two years ago, amid throwaway projects furiously hammered out ahead of my first developer job hunt, I made a little Rails app that I **actually liked**, a mashup of StumbleUpon and Wikipedia called Wiki Stumble. [Here's my post from back then](/posts/2021/wikipedia-explorer-discover-articles-like-stumbleupon) on how I made the app.

Now, as I'm circling back to tie up some loose ends, I took the opportunity **to learn a Ruby app framework besides Rails**, and **to practice my Hotwire skills**.

[Here's the GitHub repo](https://github.com/fpsvogel/wikistumble) of the new Wiki Stumble app, and [here's the live site](https://wikistumble.onrender.com/) deployed to Render.

## Roda, the DIY framework

I chose [Roda](https://roda.jeremyevans.net/) because it's simple and flexible. I was already somewhat familiar with it from using [Bridgetown](https://www.bridgetownrb.com/), another framework that supports hybrid static/SSR architecture by using Roda. Wiki Stumble has only one page and it's not static, so I went ahead and built it with Roda directly.

Janko Marohnić's [budget app](https://github.com/janko/budget) was handy as a template of a Roda app that uses Turbo Streams. Roda's tagline of "Web Toolkit" is accurate, because rather than giving you a complete app like the `rails new` command does, **it lets you piece an app together from scratch using whatever plugins you want, organized in whatever way you want**.

It was a good exercise to design my app **in a way that makes sense for my app**, and in the end it's aesthetically pleasing to see the simplicity of the app mirrored in its being composed of just a dozen source files.

I also learned how to set up certain things myself that Rails handles behind the scenes, such as code hot-reloading with [Zeitwerk](https://github.com/fxn/zeitwerk).

## Dropping in Turbo Streams

After I'd copied and re-organized my code from the old Rails app, it was time to give the new Wiki Stumble a seamless SPA feel using [Turbo Streams](https://turbo.hotwired.dev/handbook/streams), part of the [Hotwire](https://hotwired.dev/) suite of tools for "HTML over the wire".

There was a specific problem I wanted to solve: every time the user pressed the "Next article" button, **the entire page was being reloaded**, and the user would have to scroll down a bit from the top to see the article again. To avoid this, I could use a Turbo Stream response to **re-render just the part of the page that shows the article**.

Thanks to the [roda-turbo](https://github.com/bridgetownrb/roda-turbo/) plugin, this boiled down to replacing one line at the end of the router branch that handles the "update" route. Before, I was re-loading the page:

```ruby
r.redirect root_path
```

I replaced that with a Turbo Stream rendering just the article:

```ruby
turbo_stream.replace(
  "article", # the ID of the DOM element to be replaced
  partial("partials/article", locals: article.contents),
)
```

Soon I needed to make another stream update at the same time, to hide a flash error message if there had been an error loading the previous article. To do that, I just replaced the above line with rendering a new template:

```ruby
render("next_article_stream", locals: { article: })
```

And in the new template I put the two stream updates:

```ruby
<%%= turbo_stream.replace "article", partial("partials/article", locals: article.contents) %>
<%%= turbo_stream.remove "flash" %>
```

Easy peasy!

## Up next: improve performance

Despite the Turbo Streams updates, Wiki Stumble still **doesn't feel snappy**. The reason is on the back end: fetching the next article that matches the user's preferences is **expensive**, involving up to a dozen API calls across multiple Wikipedia APIs.

Doing all of that within each server request adds a delay of up to several seconds, so I'll have to engineer a way to call the APIs outside of the request-response cycle. Once I've solved that problem, I'll have fixed all the issues that plagued the app back when I built it with Rails, and I can call it done.

But for now, I'm glad to have found Roda and Turbo Streams to be such a pleasant and powerful combination ❤️
