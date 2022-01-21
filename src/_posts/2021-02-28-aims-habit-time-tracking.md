---
title: Habits and time tracking with aims.md
subtitle: beyond a todo list
---

- [1. Set up templates](#1-set-up-templates)
- [2. Get things done](#2-get-things-done)
- [3. Analyze your progress, and improve!](#3-analyze-your-progress-and-improve)

Some time ago [I proudly wrote about my new todo.txt](/posts/2020/todotxt.html). Well… it was less useful than I'd hoped. Tasks languished at the top of my todo list for days as I looked at it less and less often amid the bustle of daily life. I already had calendar apps to remind me of appointments, and I was already working regularly (however inconsistently) on side projects without needing to be reminded of them. And so my todo list was sidelined.

The good news is that now I've discovered something that meshes much better with daily life: a daily checklist of habits and disciplines, with any one-off "todo" tasks added in. This list I'm checking every day, since it consists of things that I was already doing (or wanted to do) on a daily or weekly basis, and so any "todo" tasks that I throw in are now much more likely to get done as well.

But the real power of this new approach is with those daily and weekly tasks, providing a formal structure that helps me do them more consistently. In school we wouldn't learn much if we didn't have a teacher spurring us on and evaluating our progress. With this new productivity tool, I'm playing the role of teacher (or at least taskmaster) to myself. Here's how.

## 1. Set up templates

I have a file `aims.md` which I edit with the [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one) extension for VS Code. More on that in a bit, but at the top of the file I have templates of lists of tasks to be done every week and every day, marked with tags and a time goal (where applicable). Here is a simple example:

```markdown
## THIS WEEK
- [ ] read: latin: 1h   Seneca - Epistulae
- [ ] call parents

## TODAY
### Study
- [ ] code: 1h          readstat
- [ ] read: math: 30m   Calculus II
### Leisure
- [ ] read: 30m         Freeman - Alexander the Great
### Health
- [ ] exercise 40m
- [ ] no knuckle pops
```

## 2. Get things done

A bit further down in the file (past a list of "todo" tasks) is where the real work happens. Each week I copy my weekly tasks (and any one-off "todo" tasks) and paste them in this lower region, and every morning I similarly copy down my daily tasks, just above yesterday's finished checklist. Here's what it looks like:

```markdown
## THIS WEEK
- [ ] family:           call parents
- [ ] blog:             finish aims.md

## 2021-02-26 - Friday
### Study
- [x] code: 1h          reading tracker
- [ ] read: math: 30m   Calculus II
### Leisure
- [ ] read: 15m/30m         Freeman - Alexander the Great
- [x] read: latin: 1.5h/1h   Seneca - Epistulae
### Health
- [x] exercise 40m
- [ ] no knuckle pops   😩😩
```

Let's say this is a Friday evening when I found myself with a bit of extra time, so I pulled down my weekly Latin reading into today's checklist, and then went over my goal by half an hour—Seneca is that good. Earlier today I exercised and did my daily coding. Now all that's left is math and leisure reading (of which I've already done 15 minutes earlier today). I'm trying to kick the habit of popping my knuckles, but I caught myself doing that *twice* today, so I won't be able to check that off. I emphasize (and quantify) my failure with two sad emojis. This weekend I need to call my parents and finish this blog post, and then I can call it a week well spent.

Editing my daily checklist is made convenient by VS Code's [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one) extension. Headings are colored, a new line in a checklist is filled in with an empty checkbox, and there is a keyboard shortcut for toggling checkboxes. Also, with the [Todo Tree](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree) extension, unchecked boxes are highlighted. Here's what it looks like:

![aims.md todo list in vs code markdown](/images/aims-vscode.png)

It's also convenient to use an app like [AutoHotkey](https://www.autohotkey.com/) to set up a keyboard shortcut for inserting the date heading and emojis, though I use the text expander [Beeftext](https://beeftext.org/) for emojis and other simple snippets.

## 3. Analyze your progress, and improve!

As you fill out these daily checklists, each morning copying the template and pasting it just above yesterday's list, you'll soon see a record of how you've done in past days. Scrolling down my own `aims.md`, I see a patchwork of unfinished tasks and sad emojis mixed in with the successes marked by X's. A mixed record, for sure.

But you know what? After just two months of doing this, I can see an improvement. T are fewer omissions and failures toward the top of the file than near the bottom, which confirms my suspicion that I've become more consistent through the repeated shame of seeing unchecked boxes and sad emojis at the end of a day when I haven't been focused enough. And the improvement is even better than it appears at first glance, because in my own checklists (not the examples above) I've actually raised the bar by gradually adding a few more regular tasks to my templates.

It's also nice to see milestones that I've reached, which I mark with the `⛳ goal:` emoji and tag.

Speaking of tags, it wouldn't be too hard to write an app that analyzes this daily record, answering queries such as these:

- How have I divided up my time, based on tags?
- Which tasks are most often left incomplete?
- On which days of the week am I most productive?
- How has my productivity changed, if I could visualize it over time?

Not a bad idea for a future project…
