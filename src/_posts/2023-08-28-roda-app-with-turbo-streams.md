---
title: Roda + Turbo Streams = ❤️
subtitle: porting Wiki Stumble from Rails
description: I rewrote a Ruby on Rails app in Roda, using Turbo Streams for an SPA-like feel. And you can too!
---

- [Roda, the DIY framework](#roda-the-diy-framework)
- [Dropping in Turbo Streams](#dropping-in-turbo-streams)
- [Future plans](#future-plans)

Two years ago, amid throwaway projects furiously hammered out ahead of my first developer job hunt, I made a little Rails app that I **actually liked**, a mashup of StumbleUpon and Wikipedia called Wiki Stumble. [Here's my post from back then](https://fpsvogel.com/posts/2021/wikipedia-explorer-discover-articles-like-stumbleupon) on how I made the app.

Now, as I'm circling back to tie up some loose ends, I took the opportunity **to learn a Ruby app framework besides Rails**, and **to practice my Hotwire skills**.

[Here's the GitHub repo](https://github.com/fpsvogel/wikistumble) of the new Wiki Stumble app, and [here's the live site](https://wikistumble.onrender.com/) deployed to Render.

## Roda, the DIY framework

I chose [Roda](https://roda.jeremyevans.net/) because it's simple and flexible. I was already somewhat familiar with it from using [Bridgetown](https://www.bridgetownrb.com/), another framework that supports hybrid static/SSR architecture by using Roda. Wiki Stumble has only one page and it's not static, so I went ahead and built it with Roda directly.

Janko Marohnić's [budget app](https://github.com/janko/budget) was handy as a template of a Roda app that uses Turbo Streams. Roda's tagline of "Web Toolkit" is accurate, because rather than giving you a complete app like the `rails new` command does, **it lets you piece an app together from scratch using whatever plugins you want, organized in whatever way you want**.

It was a good exercise to design my app **in a way that makes sense for my app**, and in the end it's aesthetically pleasing to see the simplicity of the app mirrored in its being composed of just a dozen source files.

I also learned how to set up certain things myself that Rails handles behind the scenes, such as code hot-reloading with [Zeitwerk](https://github.com/fxn/zeitwerk).

## Dropping in Turbo Streams

After I'd copied and re-organized my code from the old Rails app, it was time to give the new Wiki Stumble a snappy SPA feel.

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

## Future plans

I thought about continuing further with the Wiki Stumble app, adding user accounts and authentication. But the app wouldn't gain much by that. Small as it is, it fulfills its purpose as a toy well enough already.

So I'll come up with a new project to learn other tools that I didn't yet get a chance to explore:
  - [Sequel](https://github.com/jeremyevans/sequel) as an alternative to Active Record.
  - [ViewComponent](https://viewcomponent.org/) or [Phlex](https://www.phlex.fun/) to organize view-related code.
  - Turbo enhancements by the StimulusReflex team: [Turbo Boost Commands](https://hopsoft.io/@turbo-boost/commands), [Turbo Boost Streams](https://hopsoft.io/@turbo-boost/streams), and [TurboPower](https://github.com/marcoroth/turbo_power).

In the meantime, I wish you happy Wikipedia-surfing!
