---
title: Build a blog with Bridgetown
subtitle: templates, components, and plugins all in Ruby
---

- [1. Setup](#1-setup)
- [2. Ruby component and plugin](#2-ruby-component-and-plugin)
- [3. Deployment and beyond](#3-deployment-and-beyond)
- [UPDATE: It's alive!](#update-its-alive)
- [Conclusion](#conclusion)

***UPDATE, January 2022:** Bridgetown 1.0 beta has been released! 🎉 I've updated the setup instructions below.*

Once upon a time, in ye olden days of 2008, the world saw the release of Jekyll, the first popular static site generator. Fast forward 2+ decades, and its popularity has been eclipsed by newer JavaScript counterparts like Gatsby and Eleventy. And why not? Jekyll runs on Ruby *(boo!)* so it is unsexy and [obviously super slow](https://css-tricks.com/comparing-static-site-generator-build-times/#jekyll-the-odd-child). (Hint: in that article, read down to where the author notes, "Also surprising is that Jekyll performed faster than Eleventy for every run.")

Sarcasm aside, Jekyll seems to be built on a solid enough foundation, but unfortunately it has not received a lot of updates in recent years. Is this another arena where, as they say, Ruby is dead?

Enter [Bridgetown](https://edge.bridgetownrb.com/), a fork of Jekyll which aims to compete toe-to-toe with its modern JS cousins, providing even more Ruby tools for building static sites. Very exciting.

Many of Bridgetown's Ruby upgrades are already released, so I (happy for any chance to write Ruby) rebuilt and extended this blog with Bridgetown. Here's how I did it. Note that these instructions apply to [Bridgetown 1.0](https://edge.bridgetownrb.com/release/beta-1-is-feature-complete/), the latest version at the time of writing. Also note that a knowledge of Ruby is assumed here, but not necessarily any prior experience in building a static site.

You can see the final result of this process in [my site's GitHub repo](https://github.com/fpsvogel/blog-2021).

## 1. Setup

1. Follow the steps on Bridgetown's [Getting Started](https://edge.bridgetownrb.com/docs) page.
  - To create the site, I ran `bridgetown new blog -t erb`. The added option is to use ERB tempates, rather than the default of Liquid.
  - See also [all the command line options](https://edge.bridgetownrb.com/docs/command-line-usage).
  - If you already know of some bundled configurations that you need (see below), you can include them in the `new` command. In my case: `bridgetown new blog -t erb -c turbo,stimulus,bt-postcss`
2. Add [bundled configurations](https://edge.bridgetownrb.com/docs/bundled-configurations) that you need. In my case:
  - [Turbo](https://edge.bridgetownrb.com/docs/bundled-configurations#turbo) for faster page transitions.
  - [Stimulus](https://edge.bridgetownrb.com/docs/bundled-configurations#stimulus) for adding JavaScript sprinkles (more on that below). Alternatively you could use LitElement, as explained in [the Components doc](https://edge.bridgetownrb.com/docs/components) and in [this guide to web components on Fullstack Ruby](https://www.fullstackruby.dev/fullstack-development/2022/01/04/how-ruby-web-components-work-together/).
  - [Recommended PostCSS plugins](https://edge.bridgetownrb.com/docs/bundled-configurations#bridgetown-recommended-postcss-plugins). I also installed [this extra PostCSS plugin](https://github.com/postcss/postcss-scss#2-inline-comments-for-postcss) that adds support for inline comments in CSS files.
3. Install [plugins](https://edge.bridgetownrb.com/docs/plugins) that you need. In my case:
  - [SEO tags](https://github.com/bridgetownrb/bridgetown-seo-tag)
  - [Sitemap generator](https://github.com/ayushn21/bridgetown-sitemap)
  - [Atom feed](https://github.com/bridgetownrb/bridgetown-feed)
  - [SVG inliner](https://github.com/ayushn21/bridgetown-svg-inliner)
4. Set your preferred [permalink style](https://edge.bridgetownrb.com/docs/content/permalinks).
5. Set up [pagination](https://edge.bridgetownrb.com/docs/content/pagination).
6. Set your site's info in `src/_data/site_metadata.yml`.
7. Kickstart your site's design with a CSS theme. I chose [holiday.css](https://holidaycss.js.org/), a classless stylesheet for semantic HTML. Or you could use an actual Bridgetown theme, such as [Bulmatown](https://github.com/whitefusionhq/bulmatown). (That's the only Bridgetown theme as of January 2022, but I expect more will come soon from the community.)
8. Add a Pygments CSS theme for code syntax highlighting.
  - Either [download one of the handily premade CSS files](https://jwarby.github.io/jekyll-pygments-themes/languages/ruby.html), or [pick from the full list](https://pygments.org/demo/#try) then [install Pygments and make it generate a CSS file](https://stackoverflow.com/a/14989819/4158773). (I picked one of the premade stylesheets and then created a second one to override some of the colors.)
  - Place the CSS file in `frontend/styles`.
  - Import it into `frontend/styles/index.css`: for example, for Monokai place `@import "monokai.css";` near the top of `index.css`.

## 2. Ruby component and plugin

Next I designed and built my site, a process which was mostly unremarkable, except for one thing: I built a Ruby component and plugin for a complex, data-heavy part of a page. For simpler parts of a page I just used partials, such as `_tweet_button.erb`. But for any significant manipulation of data prior to rendering, building a Ruby component makes more sense. In my case, I wanted a "Reading" page that lists titles from my `reading.csv` file (my homegrown alternative to Goodreads), including only books that I rated at least a 4 out of 5.

Following [the doc on Ruby components](https://edge.bridgetownrb.com/docs/components/ruby), I created a `ReadingList` component in `_components/reading_list.rb`, and its template `_components/reading_list.erb`.

After writing the HTML + ERB + CSS for the reading list element, I used Stimulus to add JavaScript sprinkles to expand/collapse rows with reading notes or long blurbs, to filter rows by rating or genre, and to sort rows (though sorting is disabled on my site, since I went with the minimal "favorite or not" way of showing ratings).

Then I fleshed out `reading_list.rb` to load my reading list and provide data for the template `reading_list.erb`. The CSV-parsing code is pretty complex, so I separated it out [into a gem](https://github.com/fpsvogel/reading-csv).

Thanks to a tip (one of many) from the Bridgetown creators on [the Discord server](https://discord.gg/Cugms94QFM), I realized my Ruby component had way too much logic in it which should be separated out into a plugin. So I dove into [the docs on plugins](https://edge.bridgetownrb.com/docs/plugins) and moved nearly all of my component's code into a plugin.

So now the plugin parses my CSV file (using my parsing gem) and saves it into the site's data. Then my component's `.rb` file pulls that data into instance variables. Finally, the ERB template uses the instance variables as it displays the reading list.

If you create a plugin and want to make it more easily available to other Bridgetown site creators, you should [make it into a gem](https://edge.bridgetownrb.com/docs/plugins#creating-a-gem) and possibly create an [automation](https://edge.bridgetownrb.com/docs/automations) for it. I didn't for my reading list plugin, because the intersection of people who track their reading in a CSV file and people who will make a Bridgetown site is… very few people, I'm sure.

## 3. Deployment and beyond

Publishing my site was as simple as [choosing the GitHub repo on Netlify](https://www.netlify.com/blog/2016/09/29/a-step-by-step-guide-deploying-on-netlify/) and [configuring the custom domain](https://docs.netlify.com/domains-https/custom-domains/).

One possible improvement remains. Currently, to update the reading list I must delete it (`_data/reading.yml`) and rebuild the site locally (so that my `reading.csv` can be re-parsed) before pushing it to be built and deployed on Netlify. I could avoid these manual steps by taking advantage of the fact that my `reading.csv` is automatically synced to Dropbox: I could change my plugin to connect to Dropbox and update the list from there instead of from the copy on my local machine.

## UPDATE: It's alive!

Now in October, three months later, I've made the improvement proposed above. My Bridgetown plugin now connects to my Dropbox account, reads my `reading.csv` file from there, parses newly added items, and adds them to my site's data. I'm storing my Dropbox keys in Netlify environment variables, which are passed into Bridgetown in `ENV`. Now my reading list can be updated in a Netlify build, without me having to first build it locally and push it.

This paved the way for an even cooler improvement: I followed [this guide](https://www.stefanjudis.com/snippets/how-to-schedule-jamstack-deploys-with-netlify-and-github/) to setting up automatic Netlify redeploys via GitHub Actions, and now my site rebuilds itself every week. This means that my site's Reading page is synced weekly to my `reading.csv`, and it's completely automatic! Now I'm starting to see how static sites, in spite of their simplicity, can feel quite dynamic if they are automatically rebuilt often, using content added via APIs.

## Conclusion

Besides Bridgetown itself, I learned a number of new things in this project, such as how to use Stimulus to make a page dynamic with a bit of JavaScript.

But what I really loved was using what I *already* knew (Ruby) in a completely new way. Bridgetown is doing a wonderful job of bringing the joy of Ruby into the world of modern static site generators.
