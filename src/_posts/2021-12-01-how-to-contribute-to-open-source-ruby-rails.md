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

Here's how I recently got started contributing to open-source Ruby on Rails projects. I'm pretty new to Rails, so if I can do it then you can too! (For more tips for beginning Rubyists, see [my study plan](https://github.com/fpsvogel/learn-ruby-and-cs).)

## Find a project

Here are a few beginner-friendly projects, though there are certainly others.

- [Discourse](https://github.com/discourse/discourse)
- [Lobsters](https://github.com/lobsters/lobsters)
- [Ruby for Good](https://rubyforgood.org/) makes software for nonprofit organizations. Each of their projects has a Slack community, so they're extra easy to get into.
  - [Human Essentials](https://github.com/rubyforgood/human-essentials)
  - [CASA](https://github.com/rubyforgood/casa)
  - [Circulate](https://github.com/rubyforgood/circulate)
  - [InKind Admin](https://github.com/rubyforgood/inkind-admin) and [InKind Volunteer](https://github.com/rubyforgood/inkind-volunteer) (Rails + React)

If you want to widen your search, explore the resources at [First Timers Only](https://www.firsttimersonly.com/). As you consider projects to contribute to, keep these questions in mind:

- Is the project active? Does it have recent activity and frequent commits?
- Does the `README.md` have beginner-friendly instructions?
- Are there a variety of issues tagged "Good First Issue" or something similar?
- Are you interested in helping the project succeed?

## Set up the project on your local machine

Once you've chosen a project, follow the setup instructions in `README.md` or `CONTRIBUTING.md`. You will probably run into problems; use your Google-fu to solve them. For example, here were my setup problems in Ubuntu in WSL2, for two of the projects listed above:

- **Circulate:** The `bin/webpack-dev-server` command didn't work until I [downgraded to a previous version](https://stackoverflow.com/a/69050300/4158773). Also, `chromedriver` (for system tests) is not very straightforward to set up in WSL. The guide that worked for me is [this one](https://linuxtut.com/en/c4d4ed7054b2ada463d6/) supplemented with [this other one](https://www.how2shout.com/how-to/use-gdebi-install-google-chrome-ubuntu-linux.html).
- **Lobsters:** The `mysql2` gem wasn't installing properly. It turns out I needed to first install MySQL (duh). So I followed [this guide](https://ostechnix.com/how-to-use-mysql-with-ruby-on-rails-application/), adding the extra step of `sudo service mysql start` after installing the MySQL packages. I also had to [create some missing files](https://superuser.com/questions/980841/why-is-mysqld-pid-and-mysqld-sock-missing-from-my-system-even-though-the-val) for MySQL and [create a new MySQL user](https://stackoverflow.com/a/42742610/4158773) for the databases used by Rails. Oh, and I had to [disable passwords](https://stackoverflow.com/a/38538641/4158773) before creating the new user, otherwise it couldn't be accessed.

## Become familiar with the codebase

Poke around and get a feel for what the app does and how it works. Here are some good starting points in a Rails app:

- the readme (of course)
- `config/routes.rb`
- the Gemfile
- `db/schema.rb`
- the tests

## Find and fix an issue

You can follow roughly these steps:

1. Make sure you've read the project's `README.md` and (if it has one) `CONTRIBUTING.md`.
2. Find an issue that is well-described and seems simple to fix. Often (but not always) these are tagged as "Good First Issue".
3. At this point, some projects prefer that you claim the issue or leave a comment. Be sure to follow the project's contributing guidelines. Once you have the OK from the project maintainers, or if there are no pre-contributing steps, then it's time to work on the issue.
4. Reproduce the issue on your local machine.
5. Write a test that fails because of the issue. (Not all projects require this, but it's a good rule of thumb.)
6. Fix the issue, and make sure your new test passes.
7. Send back your fix by creating a PR (pull request). To learn how to make a PR, follow the steps in [First Contributions](https://github.com/firstcontributions/first-contributions). [Here is another guide](https://gist.github.com/Chaser324/ce0505fbed06b947d962) with a few extra steps that are good to keep in mind. Also, if you find that you've cloned a project's repo before forking it, [this guide](https://gist.github.com/jagregory/710671) explains how to get back on track by making your local copy point to your fork.
8. Patiently wait for feedback from the project maintainers, and respond if they ask for more input from you.

## Conclusion

If all goes well, your pull request will be accepted and you will have made your first contribution to open source! 🎉 From there you can keep an eye out for new issues in your favorite projects so that you can make even more contributions.
