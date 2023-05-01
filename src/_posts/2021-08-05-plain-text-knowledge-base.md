---
title: Plain-text, flat-file knowledge base with syntax highlighting
subtitle: notes with tags and dates, effortlessly
description: Sometimes the best note-taking system is a simple one. Mine is a .txt file with syntax-highlighted headings and tags via the VS Code extension Supertext.
---

- [An example](#an-example)
- [The rationale](#the-rationale)
- [Other possibilities](#other-possibilities)

The simplest and most enjoyable note-taking system I've found is to keep notes in a single text file, grouped under heirarchical tags so that I can jump to a tag by looking it up with `Ctrl+F`. Syntax highlighting is provided by my [Supertext VS Code extension](https://marketplace.visualstudio.com/items?itemName=fpsvogel.supertext).

## An example

```
``frontend
`frontend`web components
https://gorails.com/episodes/rails-web-components 2021/06/18
https://github.com/mateusortiz/webcomponents-the-right-way 2021/06/22
`frontend`stimulusreflex
https://github.com/obie/guide-to-reactive-rails 2020-12-22
Building Reactive Apps With Stimulus Reflex https://www.youtube.com/watch?v=lUwZ9rS0SeM

``git
git config --global push.default current
git update-index --add --chmod=+x netlify.sh ~if Netlify gives a deploy error about permissions
`git`learning
https://github.com/bobbyiliev/introduction-to-git-and-github-ebook
https://github.com/git-tips/tips
```

Here is what that looks like with syntax highlighting:

![supertext plain text knowledge base syntax highlighting VS Code extension](/images/supertext.png)

## The rationale

Why do I love this approach? To some it might seem crude and limiting. But something simple and fast is exactly what I need.

The #1 reason I take notes is that I often come across tools and learning resources that I want to come back to later, usually because they're too advanced for me at the time, or they're just not the right next step.

To jot these down in the heat of the moment and come back to them later, I've found that my notes need to be:

- **Quick to navigate:** When I want to (for example) save a URL, I want to simply drop it in my notes. I don't want extra steps like creating new note or file, or navigating a hierarchy of tags/categories. The same goes for viewing past notes: I want to see them all in one place, rather than having to open up different notes/files or navigate a hierarchy.
- **Easy to find past notes:** When I want to find (for example) my notes on Git, I want to pull them up right away, all in one place. I don't want to hunt for them. My notes should also be easy to browse: sometimes I want to look through my notes and remind myself of what all is there.

These two goals are in tension: the absolute quickest way to save a URL is to add it to the top of a text file containing all your notes, one on each line, newest at the top. But of course, this would make finding past notes horribly difficult since they aren't organized in any way except chronologically.

On the other hand, to maximize my chances of finding a note in the future, I could place it in a hierarchy of categories, mark its date, and add several tags to it. But for me, doing all of this every time for a simple URL is cumbersome.

So I found a compromise where I don't lose much from either. I keep my notes in a single text file, each note under a heading of heirarchical categories. So the *organization* is heirarchical, but the *navigation* is that of a flat text file. And note metadata is optional—in the example above, I added a date to some of the notes on frontend notes because frontent tech changes more rapidly and so it's more useful to see how far back I added that kind of note.

## Other possibilities

After I started taking notes this way, I found that [someone else had a similar idea before me](https://illdoitlater.xyz/t/plaintext), just without the syntax highlighting.

If you want to tweak the approach and use different syntax or even add new ones, and/or change the colors, that is possible! See [the instructions on the VS code extension page](https://marketplace.visualstudio.com/items?itemName=fpsvogel.supertext#syntax-settings). Happy note-taking!
