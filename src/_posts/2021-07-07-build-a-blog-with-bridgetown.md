---
title: Build a blog with Bridgetown
subtitle: templates, components, and plugins all in Ruby
---

- [1. Setup](#1-setup)
- [2. Design](#2-design)
- [3. Ruby component and plugin](#3-ruby-component-and-plugin)
- [4. Deployment and beyond](#4-deployment-and-beyond)
- [UPDATE: It's alive!](#update-its-alive)
- [Conclusion](#conclusion)

Once upon a time, in ye olden days of 2008, the world saw the release of Jekyll, the first popular static site generator. Fast forward 2+ decades, and its popularity has been eclipsed by newer JavaScript counterparts like Gatsby and Eleventy. And why not? Jekyll runs on Ruby *(boo!)* so it is unsexy and [obviously super slow](https://css-tricks.com/comparing-static-site-generator-build-times/#jekyll-the-odd-child). (Hint: in that article, read down to where the author notes, "Also surprising is that Jekyll performed faster than Eleventy for every run.")

Sarcasm aside, Jekyll seems to be built on a solid enough foundation, but unfortunately it has not received a lot of updates in recent years. Is this another arena where, as they say, Ruby is dead?

Enter [Bridgetown](https://www.bridgetownrb.com/), a fork of Jekyll which aims to compete toe-to-toe with its modern JS cousins, providing even more Ruby tools for building static sites. Very exciting.

Many of Bridgetown's Ruby upgrades are already released, so I (happy for any chance to write Ruby) rebuilt and extended this blog with Bridgetown. Here's how I did it. Note that these instructions apply to [Bridgetown 0.21](https://www.bridgetownrb.com/release/embracing-ruby-in-0.21/), the latest version at the time of writing. Also note that a knowledge of Ruby is assumed here, but not necessarily any prior experience in building a static site.

You can see the final result of this process in [my site's GitHub repo](https://github.com/fpsvogel/blog-2021).

## 1. Setup

1. Follow the steps on Bridgetown's [Getting Started](https://www.bridgetownrb.com/docs/) page.
   - If you want to use a CSS framework: [Bulmatown](https://github.com/whitefusionhq/bulmatown) or [Bootstrap blog theme](https://github.com/bt-rb/bridgetown-theme-bootstrap-blog). But instead I used a classless CSS framework (see below in "Design").
   - If you see strange or missing styling when serving up your site locally, just wait a bit when running `yarn start` until the Webpack manifest is generated (you'll be notified in the console when it is generated), then exit and run `yarn start` again. ***UPDATE:** I realized that I was having this problem only because I was running Ruby in WSL but my site was stored in the mounted Windows filesystem. So if you use WSL, be sure to store your site in the Linux filesystem. That way your site will build quickly with no Webpack delay, and you'll get automatic site regeneration and browser reload after file changes.*
2. Install plugins:
   - [SEO tags](https://github.com/bridgetownrb/bridgetown-seo-tag)
   - [Sitemap generator](https://github.com/ayushn21/bridgetown-sitemap)
   - [Atom feed](https://github.com/bridgetownrb/bridgetown-feed)
   - [SVG inliner](https://github.com/ayushn21/bridgetown-svg-inliner)
   - [Turbo](https://www.bridgetownrb.com/docs/bundled-configurations#turbo) for quick page transitions without a full reload.
   - [Stimulus](https://www.bridgetownrb.com/docs/bundled-configurations#stimulus) if you need JavaScript sprinkles. (Alternatively you could use LitElement, as explained in [the Components doc](https://www.bridgetownrb.com/docs/components)).
3. Switch to the resource content engine.
   - Doc: [Resources](https://www.bridgetownrb.com/docs/resources)
   - In `bridgetown.config.yml`, add `content_engine: resource`.
   - In the Liquid templates, change `page` to `resource`, and access front matter via the `data` variable. For example: instead of `page.title`, use `resource.data.title`.
4. Switch from Liquid to ERB templating.
   - Doc: [ERB and Beyond](https://www.bridgetownrb.com/docs/erb-and-beyond)
   - In `bridgetown.config.yml`, add `template_engine: erb`.
   - Convert the Liquid templates in `src/_layouts` and `src/_components` to ERB. Then move the templates from `_components` into a new `src/_partials` directory, and add an underscore to the beginning of each filename, e.g. `head.liquid` becomes `_head.erb`.
   - Convert the Liquid code in `posts.md` to ERB.
5. Set your preferred permalink style.
   - Docs: [Permalinks](https://www.bridgetownrb.com/docs/structure/permalinks) and [how they're different with the resource content engine](https://www.bridgetownrb.com/docs/resources#configuring-permalinks).
6. Set up pagination.
   - Docs: [Pagination](https://www.bridgetownrb.com/docs/content/pagination) and [how it's different with the resource content engine](https://www.bridgetownrb.com/docs/resources#loops-and-pagination).
7. Create a `_posts-drafts/` directory for drafts that will not be published with your other posts. ([The documented way of doing this](https://www.bridgetownrb.com/docs/posts#hiding-in-progress-posts-aka-drafts) works only for the legacy content engine, but the docs will be updated by the time the resource content engine becomes the default.)
8. Set your site's info in `src/_data/site_metadata.yml`.
9. Add a Pygments CSS theme for code syntax highlighting.
   - Either [download one of the handily premade CSS files](https://jwarby.github.io/jekyll-pygments-themes/languages/ruby.html), or [pick from the full list](https://pygments.org/demo/#try) then [install Pygments and make it generate a CSS file](https://stackoverflow.com/a/14989819/4158773). (I picked one of the premade stylesheets and then created a second one to override some of the colors.)
   - Place the CSS file in `frontend/styles/`.
   - Import it into `frontend/styles/index.scss`: for example, for Monokai place `@import "monokai.css";` near the top of `index.scss`.

## 2. Design

As a foundation I used [holiday.css](https://holidaycss.js.org/), a classless stylesheet for semantic HTML, and then I [extended it with custom elements](https://dev.to/jaredcwhite/custom-elements-everywhere-for-page-layout-parts-i-and-ii-438p).

However, I still used CSS classes wherever a custom element would need to inherit from an element other than `span` or `div`, because this inheritance can only be set up via JavaScript, and that seems like more trouble than it's worth at this point.

Occasionally I took a part of a page and abstracted it out into a partial, such as `_page_selector.erb` and `_tweet_button.erb`.

## 3. Ruby component and plugin

Partials work great for simply sectioning off parts of the page, but for any significant manipulation of data prior to rendering, building a Ruby component makes more sense. In my case, I wanted a "Reading" page that lists titles from my `reading.csv` file (my homegrown alternative to Goodreads), including only books that I rated at least a 4 out of 5.

Following [the doc on Ruby components](https://www.bridgetownrb.com/docs/components/ruby), I created a `ReadingList` component in `_components/reading_list.rb`, and its template `_components/reading_list.erb`.

After writing the HTML + ERB + CSS for the reading list element, I used Stimulus to add JavaScript sprinkles to expand/collapse rows with reading notes or long blurbs, to filter rows by rating or genre, and to sort rows (though sorting is disabled on my site, since I went with the minimal "favorite or not" way of showing ratings).

Then I filled out `reading_list.rb` to load my reading list and provide data for `reading_list.erb`. This was just a matter of extracting CSV-parsing code from [a previous app](https://github.com/fpsvogel/readstat) into a gem, then including it in my component and tying up the loose ends.

Thanks to a tip (one of many) from the Bridgetown creators on [the Discord server](https://discord.gg/Cugms94QFM), I realized my Ruby component had way too much logic in it which should be separated out into a plugin. So I dove into [the docs on plugins](https://www.bridgetownrb.com/docs/plugins) and moved nearly all of my component's code into a plugin.

So now the plugin parses my CSV file and saves it into the site's data, then my component's `.rb` file pulls that data into instance variables, then the ERB template uses the instance variables as it displays the reading list.

If you create a plugin and want to make it more easily available to other Bridgetown site creators, you should [make it into a gem](https://www.bridgetownrb.com/docs/plugins#creating-a-gem) and possibly create an [automation](https://www.bridgetownrb.com/docs/automations) for it. I didn't for my reading list plugin, because the intersection of people who track their reading in a CSV file and people who will make a Bridgetown site is… very few people, I'm sure.

## 4. Deployment and beyond

Publishing my site was as simple as [choosing the GitHub repo on Netlify](https://www.netlify.com/blog/2016/09/29/a-step-by-step-guide-deploying-on-netlify/) and [configuring the custom domain](https://docs.netlify.com/domains-https/custom-domains/).

One possible improvement remains. Currently, to update the reading list I must delete it (`_data/reading.yml`) and rebuild the site locally (so that my `reading.csv` can be re-parsed) before pushing it to be built and deployed on Netlify. I could avoid these manual steps by taking advantage of the fact that my `reading.csv` is automatically synced to Dropbox: I could change my plugin to connect to Dropbox and update the list from there instead of from the copy on my local machine.

## UPDATE: It's alive!

Now in October, three months later, I've made the improvement proposed above. My Bridgetown plugin now connects to my Dropbox account, reads my `reading.csv` file from there, parses newly added items, and adds them to my site's data. I'm storing my Dropbox keys in Netlify environment variables, which are passed into Bridgetown in `ENV`. Now my reading list can be updated in a Netlify build, without me having to first build it locally and push it.

This paved the way for an even cooler improvement: I followed [this guide](https://www.stefanjudis.com/snippets/how-to-schedule-jamstack-deploys-with-netlify-and-github/) to setting up automatic Netlify redeploys via GitHub Actions, and now my site rebuilds itself every week. This means that my site's Reading page is synced weekly to my `reading.csv`, and it's completely automatic! Now I'm starting to see how static sites, in spite of their simplicity, can feel quite dynamic if they are automatically rebuilt often, using content added via APIs.

## Conclusion

Besides Bridgetown itself, I learned a number of new things in this project:

- Semantic HTML.
- More CSS.
- Stimulus, and more JavaScript than I'd written before.

But what I really loved was using what I *already* knew (Ruby) in a completely new way. Bridgetown is doing a wonderful job of bringing the joy of Ruby into the world of modern static site generators.**
