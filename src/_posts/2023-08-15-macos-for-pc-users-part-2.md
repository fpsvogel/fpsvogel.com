---
title: MacOS for PC users, part 2
subtitle: more tools for lost souls
description: More tools and hacks for making your MacOS feel more like Windows or Linux, and why I still prefer PCs over my Mac.
---

- [Lessons from my switch to Linux](#lessons-from-my-switch-to-linux)
- [MacOS apps for more PC-ification](#macos-apps-for-more-pc-ification)
- [Conclusion that's longer than the post: joy using my (non-)Mac](#conclusion-thats-longer-than-the-post-joy-using-my-non-mac)

Last year I posted [tips for making a Mac behave more like a PC](/posts/2022/switching-from-pc-windows-to-macos), after having to make the switch for a new job. Since then I've found a bevy of new tools to make my Mac *even more* PC-like.

For all you incurable PC users out there, I hope this post gives you some hope in the land of Apple.

## Lessons from my switch to Linux

Before we get into Mac-specific tools: earlier this year I replaced Windows with Linux on my PC, and a lot of the lessons I learned there are equally applicable to MacOS:

- [Customize Zsh to get a lovely terminal.](/posts/2023/switch-to-linux-from-windows#payoff-1-a-lovely-terminal)
  - [Here is the shell script](https://github.com/fpsvogel/macos-scripts/blob/main/zshrc/shift_select) that enables Shift selection in the terminal.
- [My tricks for staying on the keyboard](/posts/2023/switch-to-linux-from-windows#payoff-2-more-time-spent-on-the-keyboard-less-on-the-mouse) are mostly applicable.

## MacOS apps for more PC-ification

These are in addition to the apps and hacks I recommended [in my previous post on MacOS](/posts/2022/switching-from-pc-windows-to-macos), which for the most part I still use.

- [Rectangle](https://rectangleapp.com/) for window snapping.
- [BetterTouchTool](https://folivora.ai) is the only way I could solve the problem of MacOS keyboard shortcuts that I don't use, can't be customized, and conflict with useful app shortcuts, such as <kbd>Cmd</kbd> + <kbd>H</kbd> (`Hide window` in MacOS, `History` in Firefox). With BetterTouchTool, I can remap these to "No Action", so that they're usable in apps.
  - BetterTouchTool is a great shortcut app in general, too. For me it has completely replaced Keyboard Maestro, which I used last year.
- [Espanso](https://espanso.org) too has replaced Keyboard Maestro in the other way I used it—for snippets. Espanso is cross-platform, so I can effortlessly keep my snippets in sync between my Mac and my PC.
- [Logi Options+](https://www.logitech.com/en-us/software/logi-options-plus.html) (for my recently-acquired [Logitech MX Master 3s](https://www.logitech.com/en-us/products/mice/mx-master-3s.html)) has replaced SteerMouse for customizing mouse speed and scrolling.

## Conclusion that's longer than the post: joy using my (non-)Mac

All this may seem silly to those of you who are thinking, ***"Just give it up and learn how to use a Mac already!"***

This would be a fair point, ***if*** I were committed to using *only* a Mac for the foreseeable future. But the thing is, I still use my PC outside of work, and I don't want to drop $2500 for a personal MacBook Pro that (for my purposes) would be equivalent to my PC.

In fact, I want to *avoid* getting locked into the Apple ecosystem, for a variety of practical and philosophical reasons. I'll pass over the usual suspects (*"I'm a cheapskate"*, *"It makes me feel superior"*, *"FREEEEDOM!!"* etc.) and talk about one motivation that's less obvious: **I learn more by using Linux**.

In a draft of this post, I wrote about how in Linux I didn't have to spend so much time customizing the OS to my liking. Upon further reflection, I realize that's not true: in Linux, [I wrote plenty of shell scripts](https://github.com/fpsvogel/linux-scripts) to tweak various things. But that's the thing: **in Linux I write shell scripts**, whereas in MacOS I may need to buy a $20 app to make the same customization.

I'll admit that in MacOS I got up and running faster, and the $120 that I've spent on convenience apps is certainly less than the dollar value of the time I've spent writing scripts in Linux, unless I were making a little above minimum wage. **But the hours I've spent tinkering in Linux have been valuable on a deeper level:** during that time I also *learned shell scripting*, and even a bit of *how the operating system works* (which is nice to know since web servers run on Linux). My customization of MacOS, either in built-in settings or a third-party app, has taught me fewer generalizable lessons.

In short, I find that **using Linux is more educational**, even if it involves a lengthier setup. (And my only experience with Linux is installing it on formerly-Windows PCs. These days there are lots of PCs that ship with Linux, where there are fewer hardware compatibility issues to work around.)

And even if getting set up in Linux does take longer, that's far outweighed by **the ongoing cost of being a software developer on a Mac**. I've spent more time working around errors installing developer tools on my Mac that *just worked* in Linux, than vice versa. Perhaps this is because I started using a Mac in the M1 generation, when not all tools supported the ARM chips. Perhaps it's because as a newcomer I just don't know the common workarounds. *Perhaps.* But I suspect that when web servers are running on Linux, it's only natural that maintaining a development environment would be simpler on my Linux machine.

I'll stop complaining now. Focus on the positive…

I'm *glad* I get try out a Mac, actually, because when the opportunity arises to switch back to a PC for work, I'll do so with full knowledge, and without any Apple FOMO 😂
