---
title: My first Rails app, Plain Reading
subtitle: how I built it
description: How I built my first Ruby on Rails app, from learning Rails basics, to choosing frontend libraries, to building and deploying the app.
---

- [1. Learn the basics of Rails](#1-learn-the-basics-of-rails)
- [2. Choose frontend libraries](#2-choose-frontend-libraries)
- [3. Build the app](#3-build-the-app)
- [4. Deploy it](#4-deploy-it)
- [5. Next improvements](#5-next-improvements)
- [Conclusion](#conclusion)

After [a year of studying pure Ruby and basic frontend skills](https://github.com/fpsvogel/learn-ruby-and-cs), I've finally started learning Rails and built my first app: [Plain Reading](https://github.com/fpsvogel/plainreading).

Rails is loved for its speed of development, and in that regard it did not disappoint. A month ago I had just finished watching my first Rails tutorial and my app was 0% done. Now, one month later, I've built a working, useful app *just by working on it a little bit each day*, in the time left over from life as an adult with a full-time job. Here's how I built it.

## 1. Learn the basics of Rails

I did the free [Rails for Beginners](https://gorails.com/series/rails-for-beginners) course by GoRails. I made sure to build the example app as I went through the course.

## 2. Choose frontend libraries

[Bootstrap](https://getbootstrap.com/) would have been an easy choice, especially because it's used in the Rails for Beginners example app.

But instead I chose [Pico.css](https://picocss.com/) and [Shoelace](https://shoelace.style/). Why?

- Bootstrap doesn't have dark mode built in 🤦‍♂️ There are [a few hacks for it](https://github.com/vinorodrigues/bootstrap-dark-5), but I don't really want to go there.
- Bootstrap involves somewhat messy HTML. For example, [here is a comparison](https://www.sessions.edu/notes-on-design/www-wednesday-shoelace-2-0/) of a Bootstrap modal vs. a Shoelace modal.
- Bootstrap has fewer and less flexible components than Shoelace.

But Shoelace's included themes don't include styling for standard HTML elements (only Shoelace elements), and that's why I'm also using Pico. Pico is only one of [many minimalist or classless CSS themes](https://github.com/dbohdan/classless-css), but it's my favorite because it looks so good. And unlike most of the others, it has [several example pages](https://picocss.com/#examples) that can be used for inspiration.

I bashed Bootstrap just now, but to be fair this Pico-and-Shoelace approach has difficulties of its own:

- Pico's styling is a bit different than Shoelace's, so I had to customize Pico's CSS to match.
- In Rails it's not always easy to use custom elements. For example, there's no built-in way to use Shoelace components with Rails form helpers. [This thread](https://github.com/github/view_component/discussions/420#discussioncomment-867525) and [this post](https://www.crossingtheruby.com/2021/05/15/form-formation-rails-view-components.html) are good starting points for further research, but there's also the fact (due to the way web components work) that Shoelace forms ["don't submit the same way as native forms"](https://shoelace.style/components/form). That sounds complicated. It's a good thing I haven't needed Shoelace components in forms, so far.

Despite these complications, Pico + Shoelace on the whole feels cleaner than Bootstrap and provides more interesting possibilities for the future.

## 3. Build the app

I ended up doing this in five stages:

1. **Skeleton site.** Build a homepage and basic user management with register and login pages. The GoRails tutorial helped immensely here.
2. **Dropbox connectivity.** This took longer than I thought it would, and involved monkey-patching the Dropbox API gem to incorporate (and tweak) [an open PR](https://github.com/Jesus/dropbox_api/pull/83).
3. **Models design.** [This guide helped](https://www.startuprocket.com/articles/how-to-design-and-prep-a-ruby-on-rails-model-architecture). After that was done, finishing up the Settings page was straightforward.
4. **CSV reading list parser.** The main backend component. I made use of [a gem](https://rubygems.org/gems/reading-csv) that I previously created for a related project, but I added a lot of new features and heavily refactored it along the way, so this stage actually took the longest.
5. **My List page.** Finally, the point of the whole thing! This is where items parsed from the CSV are displayed in a pretty way so that you can show your reading list to other people. I adapted the view from [my reading page](https://fpsvogel.com/reading/) on my blog. I will improve on that soon, but in the meantime it's pretty neat that I can copy over essentially the same ERB file and Stimulus controller from my blog, thanks to my blog being made with Bridgetown. ([Here's more](https://fpsvogel.com/posts/2021/build-a-blog-with-bridgetown#2-ruby-component-and-plugin) on how I built that.)

## 4. Deploy it

I'm still ironing out some deployment issues: Dropbox is not connecting in production, my Stimulus JS is not working due to header issues… but hey, at least it's now a site on the web.

## 5. Next improvements

There are some other holes to fill too, partly because toward the end I became slightly obsessed with deploying my first app within a month. So these are coming up next:

- **Friends page.** For finding and adding friends, who by default can see more of your reading list.
- **Improve the frontend.** I've already added Stimulus for the My List and Settings pages, so now I just need to polish up the UI and add a light mode.
- **Improve performance.** Beyond a few hundred items, My List takes a long time to load because it has to filter out items based on Visibility settings. My improvised attempts at caching didn't make any difference, so this will have to wait until I learn to do it properly.

## Conclusion

As satisfying as it is to build my first app in a month, that is the easy part. The hard part will be learning how to build an app *well*, because let's be honest, right now my app's code looks like a steaming pile of dog poo to anyone who has real experience in Rails. Rails makes it easy for a newbie to slap together an app with only a vague notion of what I'm doing. It's a blessing and (increasingly as the app grows) a curse.

That's why I'll buckle down and learn the hard lessons: maintainable architecture, Rails internals, better UX/UI, performance optimization, and codebases to dig into and learn by example. It's [all in my study plan](https://github.com/fpsvogel/learn-ruby-and-cs#rails)).

Meanwhile I have to start somewhere—no beginner can build a well-architected app on their first try, but we improve as we go. It's hugely encouraging to have built a functioning app in a few weeks, and now I'm more motivated than ever to learn those more serious lessons and use them to improve my little app.

Next on my list: the [Ruby on Rails Tutorial](https://www.railstutorial.org) and the [Rails Guides](https://guides.rubyonrails.org/). Onward!
