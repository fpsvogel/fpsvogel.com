---
title: Build a blog with Bridgetown
subtitle: templates, components, and plugins all in Ruby
description: How to build a blog with Bridgetown, a progressive site generator and full-stack framework powered by Ruby.
updated: 2025-10-12
---

- [1. Setup](#1-setup)
- [2. Deployment](#2-deployment)
- [3. Ruby component and plugin for showing external data](#3-ruby-component-and-plugin-for-showing-external-data)
- [4. Scheduled deploys to automatically sync to the external data source](#4-scheduled-deploys-to-automatically-sync-to-the-external-data-source)
- [Conclusion](#conclusion)

Do you ever feel like building a website with Ruby, but Rails seems like overkill?

Enter [Bridgetown](https://www.bridgetownrb.com/). It started out as a fork of Jekyll, the granddaddy of static site generators from way back in 2008. Today, Bridgetown is much more than a static site generator, with features like [server-rendered routes](https://www.bridgetownrb.com/docs/routes), [islands architecture](https://www.bridgetownrb.com/docs/islands), and [server-rendered Lit web components](https://www.bridgetownrb.com/docs/components/lit).

In this tutorial, we'll keep it simple by building a blog. It's the quintessential static site, but with a twist: this blog will have some auto-updating content. ✨

This tutorial has been updated for Bridgetown 2.0.1.

The final result is the site that you're looking at. See also [the GitHub repo](https://github.com/fpsvogel/fpsvogel.com).

## 1. Setup

1. Make sure you have at least Ruby 3.1 installed.
  - If you've never installed Ruby before, [rbenv](https://github.com/rbenv/rbenv) is a fairly simple way to do it.
  - If you're on Windows, I recommend using the [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install) rather than installing Ruby directly in Windows.
2. Follow the steps on Bridgetown's [Getting Started](https://www.bridgetownrb.com/docs) page to create an empty site.
3. Add [bundled configurations](https://www.bridgetownrb.com/docs/bundled-configurations) and [plugins](https://www.bridgetownrb.com/plugins/). Here are a few that are useful for a blog.
  - [Feed](https://www.bridgetownrb.com/docs/bundled-configurations#feed) generates an Atom (RSS-like) feed.
  - [SEO](https://www.bridgetownrb.com/docs/bundled-configurations#seo) adds SEO tags to make your site more discoverable on search engines and more sharable on social media. (Be sure to add site-wide metadata to [src/_data/site_metadata.yml](https://github.com/fpsvogel/fpsvogel.com/blob/main/src/_data/site_metadata.yml).)
  - [Sitemap generator](https://github.com/ayushn21/bridgetown-sitemap) to further improve SEO.
  - [Turbo](https://www.bridgetownrb.com/docs/bundled-configurations#turbo) makes page transitions smoother.
  - [SVG inliner](https://github.com/ayushn21/bridgetown-svg-inliner) if you want to display SVG images on your site.
4. Set your preferred [permalink style](https://www.bridgetownrb.com/docs/content/permalinks).
5. Set up [pagination](https://www.bridgetownrb.com/docs/content/pagination) if you want it. Originally my Posts page had pagination, but I've come to prefer [one long Posts page](https://fpsvogel.com/posts/). ([Here's the diff of that adjustment](https://github.com/fpsvogel/fpsvogel.com/commit/c9ec250de94cebd9a891761261fc1bf27e81a106), if you're curious.)
6. Kickstart your site's design with a CSS theme. For my blog I chose [holiday.css](https://holidaycss.js.org/), one of many [classless stylesheets](https://github.com/dbohdan/classless-css) for semantic HTML.
7.  Add a Pygments CSS theme for code syntax highlighting.
  - Either [download one of the handily premade CSS files](https://jwarby.github.io/jekyll-pygments-themes/languages/ruby.html), or [pick from the full list](https://pygments.org/demo/#try) then [install Pygments and make it generate a CSS file](https://stackoverflow.com/a/14989819/4158773). (I picked one of the premade stylesheets and then [created a second one](https://github.com/fpsvogel/fpsvogel.com/blob/main/frontend/styles/monokai-fpsvogel-edits.css) to override some of the colors.)
  - Place the CSS file in `frontend/styles`.
  - Import it into `frontend/styles/index.css`: for example, for Monokai place `@import "monokai.css";` near the top of `index.css`.

## 2. Deployment

Now that you have the skeleton of your site, let's deploy it!

There are many ways to deploy a Bridgetown site. I recommend using a service that automatically deploys your site after you push up changes. Bridgetown provides bundled configurations for a few of these services:

- [Render](https://www.bridgetownrb.com/docs/bundled-configurations#render-yaml-configuration)
- [Netlify](https://www.bridgetownrb.com/docs/bundled-configurations#netlify-toml-configuration)
- [GitHub Pages](https://www.bridgetownrb.com/docs/bundled-configurations#github-pages-configuration)

I use Netlify, only because I've had trouble with assets not being cached with Render.

I followed the steps in [Netlify's deployment tutorial](https://www.netlify.com/blog/2016/09/29/a-step-by-step-guide-deploying-on-netlify/), and in their [doc on custom domains](https://docs.netlify.com/manage/domains/configure-domains/bring-a-domain-to-netlify/). I bought a custom domain on [Porkbun](https://porkbun.com/).

## 3. Ruby component and plugin for showing external data

Back to building your site 👷

All that's left now is to create the various pages of your site (home, posts, "about", etc.), and eventually to start writing posts. Along the way you'll make dozens of tweaks to styling.

All of that remaining work is generally unremarkable, or at least it varies so much from my site to yours that I'll just leave you to it.

I do want to show you with one more thing, though, which will take up the rest of this post: **how to build a Ruby component and plugin for a page that shows data from an external source**. If this doesn't sound like it applies to your site, then farewell, good luck on your blog-making endeavors, and be sure to stop by [the Bridgetown Discord server](https://discord.gg/Cugms94QFM) if you get stuck. But if this extra bit does sound useful, then here we go! 🚀

More concretely, I wanted to build a ["Reading" page](https://fpsvogel.com/reading) that displays data parsed and filtered from my reading log (a plain text file). How should I build that giant list in the view template?

A template partial (such as [src/_partials/_navbar.erb](https://github.com/fpsvogel/fpsvogel.com/blob/main/src/_partials/_navbar.erb)) didn't seem right, because I needed to build the data before rendering it, and naturally I wanted to avoid writing a bunch of Ruby in an ERB file. I needed something more spacious: **a Ruby component**.

Following [the doc on Ruby components](https://www.bridgetownrb.com/docs/components/ruby), I created a `ReadingList` component in [src/_components/reading_list.rb](https://github.com/fpsvogel/fpsvogel.com/blob/main/src/_components/reading_list.rb), and its template [src/_components/reading_list.erb](https://github.com/fpsvogel/fpsvogel.com/blob/main/src/_components/reading_list.erb). It's the same basic idea as [ViewComponent](https://viewcomponent.org/), if you're familiar.

You may have noticed that my component's `.rb` file doesn't do much at all. Where's all the data-building logic I mentioned a moment ago? The logic was extensive enough that I ended up moving it into a [plugin](https://www.bridgetownrb.com/docs/plugins) in [plugins/builders/load_reading_list.rb](https://github.com/fpsvogel/fpsvogel.com/blob/main/plugins/builders/load_reading_list.rb), and then later I separated much of it even further [into a gem](https://github.com/fpsvogel/reading).

I then wrote some JS to add client-side behaviors to my component, such as expanding/collapsing rows that have reading notes, and filtering rows by rating or genre. I wrote the JS [as a Stimulus controller](https://github.com/fpsvogel/fpsvogel.com/blob/main/frontend/javascript/controllers/reading_list_controller.js). That was a few years ago; today I would probably use vanilla JS or [Lit](https://www.bridgetownrb.com/docs/components/lit).

To recap:

1. [The plugin](https://github.com/fpsvogel/fpsvogel.com/blob/main/plugins/builders/load_reading_list.rb) parses my reading log file (using my gem) and saves it into the site's data.
2. [The Ruby component's `rb` file](https://github.com/fpsvogel/fpsvogel.com/blob/main/src/_components/reading_list.rb) pulls that data into instance variables accessible in the ERB template, and provides a helper method for the ERB template.
3. [The Ruby component's ERB template](https://github.com/fpsvogel/fpsvogel.com/blob/main/src/_components/reading_list.erb) displays the reading list.

## 4. Scheduled deploys to automatically sync to the external data source

At this point, it was a manual process to update my site's reading list: I had to rebuild the site locally (so that my reading log can be re-parsed) before pushing it up to be built and deployed on Netlify.

I wondered: *could I avoid having to rebuild locally?* After all, my reading log is automatically synced to Dropbox. If I adjusted my plugin to connect to Dropbox instead of using my local copy of my reading log, then my site's Reading page could be updated from within a Netlify build, without me having to first build it locally and push up the changes.

And that's exactly what I did next. I store my Dropbox keys in Netlify environment variables, which are passed into Bridgetown in `ENV`, and from there my custom plugin [uses the keys to connect to Dropbox](https://github.com/fpsvogel/fpsvogel.com/blob/main/plugins/builders/load_reading_list.rb#L52-L78).

This paved the way for an even cooler improvement: I followed [this guide to setting up automatic Netlify redeploys via GitHub Actions](https://www.stefanjudis.com/snippets/how-to-schedule-jamstack-deploys-with-netlify-and-github/), and now my site rebuilds itself every week. This means that my site's Reading page is synced weekly to my reading log file, and it's completely automatic.

You can use a similar approach of automatically rebuilding your site based on content from APIs, whenever you need a site that is updated frequently but not in real time.

## Conclusion

For me, Bridgetown was a wonderful way to ease into web development with Ruby. Not only that, but to this day I enjoy tweaking my site because of how refreshingly simple it is compared to a Rails app.

Don't get the wrong idea, though: **Bridgetown is not only for static sites** like the blog we've built here! There's *so much* that we haven't covered in this tutorial, so if you're wondering whether Bridgetown is right for a project you have in mind, check out [the Bridgetown docs](https://www.bridgetownrb.com/docs) and stop by Bridgetown's friendly [Discord server](https://discord.gg/Cugms94QFM).
