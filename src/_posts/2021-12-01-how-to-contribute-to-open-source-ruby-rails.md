---
title: How to contribute to open source
subtitle: a guide for Rails beginners
description: How to make your first open-source contribution, including tips on finding a project, setting it up on your machine, and opening your first PR.
---

- [Find a project](#find-a-project)
- [Set up the project on your local machine](#set-up-the-project-on-your-local-machine)
- [Become familiar with the codebase](#become-familiar-with-the-codebase)
- [Find and fix an issue](#find-and-fix-an-issue)
- [Conclusion](#conclusion)

Here's how I recently got started contributing to open-source Ruby projects. I'm pretty new to Ruby, so if I can do it then you can too! (For more tips for beginning Rubyists, see [my study plan](https://github.com/fpsvogel/learn-ruby).)

*UPDATE: If you don't mind watching a video, I suggest hopping right over to the RubyConf talk [Your First Open-Source Contribution](https://www.youtube.com/watch?v=ctBBrdHVbo0) by Rachael Wright Munn.*

## Find a project

[Ruby for Good](https://rubyforgood.org/) makes software for nonprofit organizations, and is a good place to start as a first-time contributor. Some of their projects have a Slack community, which could come in handy as you learn your way around a project.

If you want to widen your search, see:

- [A list of open-source Rails codebases](https://github.com/fpsvogel/learn-ruby#rails-codebases-to-study) that I've compiled.
- [CodeTriage – Ruby](https://www.codetriage.com/?language=Ruby)
- [Awesome Ruby and Rails Open Source applications](https://github.com/asyraffff/Open-Source-Ruby-and-Rails-Apps)
- [First Timers Only](https://www.firsttimersonly.com/)

As you consider which project to contribute to, keep these questions in mind:

- Is the project active? Does it have recent activity and fairly frequent commits?
- Does the README have beginner-friendly instructions?
- Are there a variety of issues tagged "Good First Issue" or something similar?
- Are you interested in helping the project succeed?

## Set up the project on your local machine

Once you've chosen a project, follow the setup instructions in the README or CONTRIBUTING. You will probably run into problems; use your Google-fu to solve them.

## Become familiar with the codebase

Poke around and get a feel for what the app does and how it works. Here are some good starting points in a Rails app:

- the README
- `config/routes.rb`
- the Gemfile
- `db/schema.rb`
- the tests

## Find and fix an issue

You can follow roughly these steps:

1. Make sure you've read the project's README and (if it has one) CONTRIBUTING.
2. Find an issue that is well-described and seems simple to fix. Often (but not always) these are tagged as "Good First Issue".
3. At this point, some projects prefer that you claim the issue or leave a comment. Be sure to follow the project's contributing guidelines. Once you have the OK from the project maintainers, or if there are no pre-contributing steps, then it's time to work on the issue.
4. Reproduce the issue on your local machine.
5. Write a test that fails because of the issue. (Not all projects require this, but it's a good rule of thumb.)
6. Fix the issue, and make sure your new test passes.
7. Send back your fix by creating a PR (pull request). To learn how to make a PR, follow the steps in [First Contributions](https://github.com/firstcontributions/first-contributions). [Here is another guide](https://gist.github.com/Chaser324/ce0505fbed06b947d962) with a few extra steps that are good to keep in mind. Also, if you find that you've cloned a project's repo before forking it, [here's a guide that explains how to get back on track by making your local copy point to your fork](https://gist.github.com/jagregory/710671).
8. *Patiently* wait for feedback from the project maintainers. Your PR may get pushback, or (worse) it may be ignored. If your PR isn't accepted despite your best efforts, dust yourself off and try again in a different project.

## Conclusion

If all goes well, your pull request will be accepted and you will have made your first contribution to open source! 🎉 From there you can keep an eye out for new issues in your favorite projects so that you can make even more contributions.

And if you want to go further as an open-source contributor, you might want to check out the book [How to Open Source](https://howtoopensource.dev/) by Richard Schneeman.
