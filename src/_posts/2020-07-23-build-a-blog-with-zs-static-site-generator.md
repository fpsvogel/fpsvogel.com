---
title: How I built this blog
subtitle: an exploration of minimalism and programming jokes
description: How I built this blog with zs and Lua.
---

- [A minimalist static site generator](#a-minimalist-static-site-generator)
- [The upshot](#the-upshot)

*NOTE: You're reading this on a more recent iteration of my blog. This post refers to [the first version from 2020](https://fpsvogel-2020.netlify.app/).*

Of all the grand plans that a fledgling developer inevitably dreams up and expands to impossible proportions, the most urgent is (thankfully) the least impossible: **to make a blog**.

The humble blog is the doorway into dreams, the launchpad into the infinity of all the earth-shaking projects soon to be realized. (That's how it goes in my imagination, at least.)

So I made this blog, and here's what I learned.

## A minimalist static site generator

When it comes to static site generators, [Eleventy](https://www.11ty.dev/) seems to be the coolest kid on the block these days. But instead I went with [zs](https://github.com/zserge/zs), which is even more elegantly minimalist. Also it's more obscure and therefore much more hip.

Here's what I love about zs:

- It's tiny but very extensible through shell scripts.
- Its [Amber](https://github.com/eknkc/amber/) templating is simple and clean.

Here's a snippet from `layout.amber` (actually it's nearly the whole thing):

```
import siteheader
article
    h1 #{title}
    div.posttop-subtitle
        #{subtitle}
    div.posttop-date
        {{ lua .zs\postdate.lua }}
    #{unescaped(content)}
footer
    ul.flexrow.center.wrap
        li.back-to-top
            a[href="#top"]
                i.fas.fa-chevron-up
        li.tweet
            {{ lua .zs\tweetbutton.lua }}
```

So much zen. `title` and `subtitle` come from each post's YAML headers. The Lua scripts are plugins that I wrote: `postdate.lua` looks at the post's filename to extract the date, and `tweetbutton.lua` creates a tweet link with the current page's title and URL.

I wrote another Lua plugin to populate the index page with a list of posts, based on the files in the "posts" folder. (In case you haven't noticed, I love Lua for scripting. Not only is it simple and quick to write, but it has a blazing fast startup time, beaten by only [a handful](https://github.com/chocolateboy/startup-time) of [other languages](https://github.com/bdrung/startup-time). Incidentally, the creator of zs also made the [luash](https://zserge.com/posts/luash/) library for more conveniently using Lua in place of shell scripts. Nice!)

Instead of zs's default GCSS, I went with Sass and learned some of its neat shortcuts: nesting, mixins, and doing math on variables.

## The upshot

Most of all, I learned that creating something simple from scratch can be more joyful than creating something more complex in a system that you don't understand.

And now writing a new post is a breeze:

- Create a Markdown file with the date in the filename (such as "2020-07-23-zs.md").
- Set the title and subtitle in the YAML header.
- Write the content.
- Rebuild the site with zs (also compile my Sass; I do both at once with a batch script).
- Push to Github, and my site on Netlify automatically updates.

Oh, and I had fun [finding programming jokes](http://www.devtopics.com/best-programming-jokes/) for my mascot owl in the site's header section.
