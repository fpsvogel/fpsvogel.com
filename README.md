<h1 align="center">My personal site from 2021</h1>

This is the second iteration of [my website](https://fpsvogel.com), built with [Bridgetown](https://www.bridgetownrb.com/). On my blog you can [read all about how I built it](https://fpsvogel.com/posts/2021/build-a-blog-with-bridgetown/). That post was a nice win for me because it got me [an episode on the Ruby Rogues podcast](https://rubyrogues.com/bridgetown-rb-ft-felipe-vogel-ruby-526), and it was also [featured in Ruby Weekly](https://rubyweekly.com/issues/561#:~:text=Build%20a%20Static%20Site%20in%20Ruby%20with%20Bridgetown).

### Table of Contents

- [Why this ~~is~~ was on my GitHub portfolio](#why-this-is-was-on-my-github-portfolio)
- [Prerequisites](#prerequisites)
- [Install](#install)
- [Development](#development)
  - [Commands](#commands)
- [Deployment](#deployment)

## Why this ~~is~~ was on my GitHub portfolio

I used this project as a stepping stone from Ruby to Rails. I had just finished [my first substantial Ruby project](https://github.com/fpsvogel/readstat), and I wanted to build a site with Ruby. I decided to rebuild my blog using Bridgetown, which was less intimidating than Rails. I built my views in ERB, and more significantly I built [a plugin in Ruby](https://github.com/fpsvogel/blog-2021/blob/main/plugins/builders/load_reading_list.rb) that builds [the Reading page](https://fpsvogel.com/reading/) of my site with the help of [my reading-csv gem](https://github.com/fpsvogel/reading-csv). You can read more about that [in my blog post on this project](https://fpsvogel.com/posts/2021/build-a-blog-with-bridgetown#3-ruby-component-and-plugin).

I also wrote [a Stimulus controller](https://github.com/fpsvogel/blog-2021/blob/main/frontend/javascript/controllers/reading_list_controller.js) for filtering and sorting the list on the Reading page.

My site's previous incarnation is at [fpsvogel-2020.netlify.app](https://fpsvogel-2020.netlify.app/) ([GitHub repo](https://github.com/fpsvogel/blog-2020)) from summer 2020, a year previous to this Bridgetown site. At that time, I had just learned basic HTML, CSS, and JavaScript.

## Prerequisites

- [GCC](https://gcc.gnu.org/install/)
- [Make](https://www.gnu.org/software/make/)
- [Ruby](https://www.ruby-lang.org/en/downloads/)
  - `>= 2.5`
- [Bridgetown Gem](https://rubygems.org/gems/bridgetown)
  - `gem install bundler bridgetown -N`
- [Node](https://nodejs.org)
  - `>= 10.13`
- [Yarn](https://yarnpkg.com)

## Install

```sh
cd bridgetown-site-folder
bundle install && yarn install
```
> Learn more: [Bridgetown Getting Started Documentation](https://www.bridgetownrb.com/docs/).

## Development

To start your site in development mode, run `yarn start` and navigate to [localhost:4000](https://localhost:4000/)!

Use a [theme](https://github.com/topics/bridgetown-theme), add some [plugins](https://www.bridgetownrb.com/plugins/), and/or run some [automations](https://github.com/topics/bridgetown-automation) to get started quickly.

### Commands

```sh
# running locally
yarn start

# build & deploy to production
yarn deploy

# load the site up within a Ruby console (IRB)
bundle exec bridgetown console
```

> Learn more: [Bridgetown CLI Documentation](https://www.bridgetownrb.com/docs/command-line-usage)

## Deployment

You can deploy Bridgetown sites on "Jamstack" hosts (Netlify, Vercel, Render, etc.) or virtually any tranditional web server by simply building and copying the output folder to your HTML root.

> Read the [Bridgetown Deployment Documentation](https://www.bridgetownrb.com/docs/deployment) for more information.
