---
title: Switching to Linux
subtitle: notes from a former Windows user
description: A Windows user's experience switching to Linux Mint, and what I gained in a better terminal and more time spent on the keyboard. Shell scripts included!
---

- [Why Linux?](#why-linux)
- [Installing Linux Mint](#installing-linux-mint)
- [Payoff #1: a lovely terminal](#payoff-1-a-lovely-terminal)
- [Payoff #2: more time spent on the keyboard, less on the mouse](#payoff-2-more-time-spent-on-the-keyboard-less-on-the-mouse)
- [What about AutoHotkey?](#what-about-autohotkey)
- [Conclusion: an educational change](#conclusion-an-educational-change)
- [Next steps](#next-steps)

I did it. I finally switched to Linux 🐧 Here's how it went and what I learned!

## Why Linux?

Until a few days ago, I was a longtime Windows user. Recently at work I've been using an obligatory MacBook Pro, but otherwise I still preferred my PC with Windows, mainly because I was used to it, but also because Windows provides [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) (Windows Subsystem for Linux), which I've found to be less troublesome for development than MacOS.

**But WSL has limitations.** Running graphical Linux apps, while possible, is not pretty. Worse, WSL uses a lot of memory, and lately I've been having to restart it after a few hours' use due to what seems to be a memory leak. Yikes!

Plus, **Windows itself is a pain.** To point to a well-known example, it's been increasingly difficult to *find where to change a simple setting* in Windows, amid the proliferation of new and half-finished settings UIs.

So I thought, ***why not switch to pure, unadulterated Linux?***

## Installing Linux Mint

I chose [Linux Mint](https://linuxmint.com/) because it has a familiar Windows-like UI, and it's right up there with Ubuntu as one of the commonly-recommended distros for beginners.

As I installed it on my Alienware m15 R4, I had to do only a few things out of the ordinary:

- The Mint installer complained about Intel RST. To disable it, I opened up BIOS settings and switched from RAID to AHCI. I still wanted to use both my physical drives as one logical unit (i.e. RAID0), so I installed Mint using LVM, following [this guide](https://opensource.com/article/21/8/install-linux-mint-lvm).
- After installation, I decided to go into BIOS settings and disable Secure Boot, because it's a pain to have to enter a password when I install certain drivers. See [here](https://askubuntu.com/a/843678) and [here](https://askubuntu.com/a/889717) on why for the average Linux desktop user, Secure Boot is more trouble than it's worth.
- To prevent screen tearing on my external monitor, I had to open up NVIDIA settings via the tray icon and switch to "Performance Mode".
- Bash was having issues wrapping lines, so I [installed Zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH) and that fixed the problem.
- I fixed a few other annoyances with [my startup scripts](https://github.com/fpsvogel/linux-scripts/blob/1bd0d357507a4fa5153862a041d421f13d79d488/my_profile). (See all the rest of my Linux scripts [here](https://github.com/fpsvogel/linux-scripts).)

So the switch took some time, but I'm already seeing a payoff in two areas: **a lovely terminal**, and **more time spent on the keyboard**. Of course, neither of these is unique to Linux, and I'm bringing these lessons back to MacOS—but **somehow it was easier for me to make these discoveries in Linux.**

## Payoff #1: a lovely terminal

Along with Zsh, I installed [Oh My Zsh](https://ohmyz.sh/#install) and a bunch of handy plugins:

- [copybuffer](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/copybuffer)
- [copyfile](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/copyfile)
- [copypath](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/copypath)
- [gitfast](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gitfast)
- [rake-fast](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/rake-fast)
- [sudo](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo)
- [thefuck](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/thefuck)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-navigation-tools](https://github.com/z-shell/zsh-navigation-tools)
- [zsh-z](https://github.com/agkozak/zsh-z)

I also copied some aliases from the [git](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git) and [rails](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/rails) plugins.

Next, I [cobbled together key bindings](https://github.com/fpsvogel/linux-scripts/blob/1bd0d357507a4fa5153862a041d421f13d79d488/zsh/big_key_bindings/zsh_shift_select) to enable Shift selection on the command line. Just this one improvement takes a lot of the pain out of the terminal for me, because now I can edit text on the command line much as I do everywhere else.

## Payoff #2: more time spent on the keyboard, less on the mouse

I have a history of wrist pain from being on the computer all day long. [Taking breaks](https://workrave.org/) and [stretching](https://www.youtube.com/watch?v=fdD7CgN5FGg) helps, but ultimately I need to use the mouse less, and keyboard shortcuts more.

Switching to a new OS is the perfect time to look for more ways to stay on the keyboard, and in Linux it's actually pretty easy since nearly everything is customizable.

Besides Mint's keyboard shortcut settings UI and my now-likable terminal, I've found a few other tools that help me stay on the keyboard:

- My [Keyboardio Atreus](https://shop.keyboard.io/products/keyboardio-atreus) keyboard. I've had it for a while now, but it's worth mentioning because I **love** it so much, and now I've further customized its layout to make keyboard-only navigation easier.
- [Vimium](https://vimium.github.io/) Chrome/Firefox extension. Navigate the web with your keyboard!
- Caret browsing (F7 in most browsers). Vimium also has a [visual mode](https://github.com/philc/vimium/wiki/Visual-Mode) if you prefer vim-style shortcuts.
- [Espanso](https://espanso.org/) text expander.
- [Porcellite](https://parcellite.sourceforge.net/) clipboard manager. Despite being apparently unmaintained (the last update was in 2017), it's my favorite one. Its search function is not as good as in [Ditto](https://ditto-cp.sourceforge.io/) (which is Windows-only), but otherwise Porcellite is perfect.
- [The compose key](https://help.ubuntu.com/stable/ubuntu-help/tips-specialchars.html.en) for typing Unicode characters.

Soon I'll have to challenge myself to see how long I can go without my mouse. Maybe stick it in a drawer on the other side of the house? 😈

## What about AutoHotkey?

On Windows I was a big fan of [AutoHotkey](https://www.autohotkey.com/). There's no equivalent in Linux, except for in-progress projects ([AHK_X11](https://github.com/phil294/AHK_X11) and [Keysharp](https://bitbucket.org/mfeemster/keysharp/src/master/)).

But you know what? **I'm not missing AutoHotkey.** Most of what I did in AutoHotkey, I can now do via keyboard shortcuts and/or scripts. And anyway, most of my AutoHotkey shortcuts were for my mouse, which (as I now see in retrospect) did more harm than good.

## Conclusion: an educational change

There are a few things that it'll take me a long time to get used to in Linux, such as the confusing filesystem hierarchy. (At least I'm comforted in seeing [I'm not the only one](http://lists.busybox.net/pipermail/busybox/2010-December/074114.html) who is unimpressed by the common rationalizations for it. There's even [a Linux distro](https://gobolinux.org/) that abandons the standard filesystem hierarchy altogether.)

But on the whole it's been **a surprisingly enjoyable switch.** Not because it was a perfect experience out of the box, but because as I'm customizing and fixing things, I'm improving my scripting skills and learning how Linux works under the hood.

MacOS and (especially) Windows are more opaque, in my experience. In Windows my tools of customization were AutoHotkey and other free utilities, and in Mac I use an assortment of (usually) paid apps to get a similar effect. But **I don't gain anything from these tools** beyond the immediate problem being fixed. I don't *learn* very much from them.

But in Linux I get to customize the OS in the same way that I do programming. (By Googling for hours and tweaking what I copy-paste until something works 😂) And in the end, as I look with pride on the barely-significant thing that I've fixed or adjusted, I realize that **the tidbits of Linux knowledge I've picked up along the way may be just as valuable as end result.** Already I've had a few "lightbulb moments" when some Unix-related features of Ruby finally made sense, and I'm sure more of those moments are to come—the whole Internet runs on Linux servers, after all, so learning more about Linux can only help me as a developer.

## Next steps

Where to go from here? My plan is to keep using Linux and to get started on [my Linux/command-line reading list](https://github.com/fpsvogel/learn-ruby#linux--command-line) as well as [my Ruby scripting list](https://github.com/fpsvogel/learn-ruby#ruby-scripting). (A few hours of Bash scripting was enough to make me want to use a friendlier language for all but performance-intensive tasks.)

And now that I have a graphical Linux environment for development, the way is open for me to try out the [DragonRuby Game Toolkit](https://dragonruby.itch.io/)… *(cue ominous music).*
