---
title: How I use MacOS, Linux, Windows, iOS, Android
subtitle: my favorite apps and extensions
description: My favorite apps across operating systems; or, how I use a MacBook, PC, iPhone, and Samsung Galaxy similarly, including keyboard shortcuts and navigability.
updated: 2025-09-02
---

- [Prelude: peripherals](#prelude-peripherals)
- [Mouse customization](#mouse-customization)
- [Keyboard shortcuts](#keyboard-shortcuts)
- [Shell](#shell)
- [Window switcher](#window-switcher)
- [Clipboard manager](#clipboard-manager)
- [Text expander](#text-expander)
- [Code and text editor](#code-and-text-editor)
- [Notes](#notes)
- [Web browser](#web-browser)
- [Password manager](#password-manager)
- [Screen capture](#screen-capture)
- [Mobile apps](#mobile-apps)
  - [Cross-platform](#cross-platform)
  - [iOS](#ios)
  - [Android](#android)

Over the past few years I've hopped across several devices and operating systems. Along the way, I've collected a list of my favorite apps and extensions for each OS. This post is that list.

This post is also a snapshot of how I use my computer and phone regardless of what OS happens to be on them. I still have my preferences, of course, but I've reached a point where I care less about which OS I'm using, thanks to this set of UI enhancements.

Here's my timeline of computer OS changes:

- *through 2022:* Windows
- *2023:* [Linux Mint](https://linuxmint.com). I switched because I realized that the thing I liked best about Windows was WSL (see [shell](#shell) below), so why not go full Linux? Plus, I was having memory leaks in WSL that I couldn't resolve.
- *2024 – present:* MacOS. I switched because at work I'm required to use the company-issued MacBook Pro. Outside of work I'm rarely at a computer these days, with a young family, so my PC is mostly collecting dust 😢

And for phones:

- *through 2024:* Android (Samsung)
- *2025 – present:* iOS (iPhone). I prefer Android, but it was worth switching to have phone notifications and mirroring on my MacBook. Or in other words, `my computer > Android > iOS`.
  - It looks like a similar phone-computer integration can be achieved with Linux + Android via [scrcpy](https://github.com/Genymobile/scrcpy) and [Android 2 Linux Notifications](https://play.google.com/store/apps/details?id=dev.patri9ck.a2ln). Someday I'll give it a try, if I ever work somewhere that doesn't mandate MacBooks.

## Prelude: peripherals

The peripherals I use with my computer are important to me because a few years ago I suffered from RSI in my wrists. The pain went away after I got a better keyboard and pointing devices.

Another way I'm now kinder to my wrists is that I stay on the keyboard as much as possible. This need for more keyboard shortcuts was the impetus that led me to much of the software listed in this post.

Before we get to the software, here are my most important peripherals:

- I type on a [Keyboardio Atreus](https://shop.keyboard.io/products/keyboardio-atreus), with a keyboard layout based on [Colemak-DH](https://colemakmods.github.io/mod-dh).
- My pointing devices are a [Logitech MS Master 3S](https://www.logitech.com/en-us/products/mice/mx-master-3s.html) mouse and a [Kensington SlimBlade Pro](https://www.kensington.com/p/products/electronic-control-solutions/trackball-products/slimblade-pro-trackball) trackball. I switch between them, even switching between my left and right hands.
- I also use a standing desk, actually just a riser that sits on top of a normal desk. Mainly because I have restless leg syndrome, but it actually does alleviate strain on my wrists as well.
- I use a 24-inch monitor—only one, because I prefer quickly switching between windows (see [window switcher](#window-switcher) below) instead of managing multiple monitors or even the two sides of a larger/ultra-wide monitor.

## Mouse customization

I like to speed up pointer and scroll speeds beyond what system preferences typically allow, using these tools:

**MacOS:** [SteerMouse](https://plentycom.jp/en/steermouse/)

**Linux:** dotfile scripts ([1](https://github.com/fpsvogel/dotfiles-linux/blob/a7411323920928b2e62a9ecef0743a3de6bb6dc5/profile/increase_pointer_speed), [2](https://github.com/fpsvogel/dotfiles-linux/blob/a7411323920928b2e62a9ecef0743a3de6bb6dc5/profile/increase_scroll_speed))

**Windows:** none, because system preferences actually allowed fast enough speeds.

## Keyboard shortcuts

**MacOS:**

[BetterTouchTool](https://folivora.ai/) is the easiest way I've found to remove the plethora of otherwise uneditable MacOS keyboard shortcuts that I don't care about, and replace them with more useful shortcuts.

[Shortcat](https://shortcat.app/) allows keyboard-only UI navigation, like Vimium does in the browser ([see below](#web-browser)).

For more PC-like text editing shortcuts, I edited `~/Library/KeyBindings/DefaultKeyBinding.Dict` with the contents of [this gist](https://gist.github.com/fpsvogel/2d8e6695db065e84915451030ec1cbf2).

**Linux:**

I didn't feel the need for an extra tool, thanks to the extensive keyboard settings in system preferences.

**Windows:**

[AutoHotkey](https://www.autohotkey.com/) for keyboard shortcuts to launch apps, and pretty much anything else you can think of. AutoHotkey is the one thing from Windows that I miss in MacOS and Linux.

## Shell

[Fish](https://fishshell.com) with [lots of aliases](https://github.com/fpsvogel/fish-config/blob/main/alias), mostly for Git.

Also:

*Windows:* [WSL (Windows Subsystem for Linux)](https://learn.microsoft.com/en-us/windows/wsl/install)

*MacOS:* [iTerm2](https://iterm2.com)

## Window switcher

*MacOS:* [AltTab](https://alt-tab-macos.netlify.app)

*Linux/Windows:* built in

## Clipboard manager

*MacOS:* [PasteBot](https://tapbots.com/pastebot)

*Linux:* [Parcellite](https://github.com/rickyrockrat/parcellite)

*Windows:* [Ditto](https://ditto-cp.sourceforge.io)

## Text expander

[Espanso](https://espanso.org). I use it for links, code snippets, emojis, and shell command "templates" that I often edit or fill in before entering.

## Code and text editor

VS Code. [See all of my extensions here](https://howivscode.com/fpsvogel), but these are a few of my favorites:

- [Copy GitHub URL](https://marketplace.visualstudio.com/items?itemName=mattlott.copy-github-url)
- [Error Lens](https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens) for error visibility
- [move-fast](https://marketplace.visualstudio.com/items?itemName=selbh.move-fast) to move up/down by 5 lines with keyboard shortcuts
- [Multiple cursor case preserve](https://marketplace.visualstudio.com/items?itemName=cardinal90.multi-cursor-case-preserve)
- [Rails Run Specs](https://marketplace.visualstudio.com/items?itemName=noku.rails-run-spec-vscode) for running RSpec (whole file or single example) via keyboard shortcuts

## Notes

A few long plain text files synced across devices with Dropbox.

For better readability and organization of notes, I use [my own markup language that I've made syntax highlighting for](https://marketplace.visualstudio.com/items?itemName=fpsvogel.supertext).

## Web browser

[Firefox Developer Edition](https://www.mozilla.org/en-US/firefox/developer). My favorite extensions:

- [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin)
- [Vimium](https://addons.mozilla.org/en-US/firefox/addon/vimium-ff) with keys remapped, because I don't actually use Vim. [SurfingKeys](https://github.com/brookhong/Surfingkeys) is a more flexible alternative that I discovered recently, but Vimium meets my needs.
- [Bulk URL Opener](https://addons.mozilla.org/en-GB/firefox/addon/bulkurlopener) for copying URLs from tabs, or opening tabs by pasting in URLs
- [Library Extension](https://www.libraryextension.com) for finding a book across libraries

## Password manager

[Bitwarden](https://bitwarden.com) browser extension and mobile app.

## Screen capture

**MacOS:** [Zappy](https://zapier.com/zappy) for screenshots and recordings. It produces large video files, so I use [Handbrake](https://handbrake.fr/) to compress them.

**Linux and Windows:** I don't recall finding a tool that I like as much as Zappy.

## Mobile apps

### Cross-platform

- Firefox, though on iOS it is sadly inferior. I can look past the missing UI conveniences that I'm used to from Firefox on Android, but I will forever mourn the fact that I can't use uBlock Origin on any browser on iOS <nobr>༼;´༎ຶ ۝ ༎ຶ༽</nobr>
- Gmail
- Spotify for podcasts
- Dropbox for plain-text notes
- [Bitwarden](https://bitwarden.com/help/getting-started-mobile)
- [Authy](https://www.authy.com) for 2FA
- [Localsend](https://localsend.org) for file transfer (like a cross-platform AirDrop)

### iOS

- [Yomu](https://www.yomu-reader.com) and [PDF Viewer](https://pdfviewer.io/) for ebooks
- [BookPlayer](https://apps.apple.com/us/app/bookplayer/id1138219998) for audiobooks
- [foobar2000](https://apps.apple.com/us/app/foobar2000/id1072807669) for my local music library. I last used foobar2000 about 20 years ago in Windows, so it's funny to run across it again in iOS.

### Android

- [Nova Launcher](https://novalauncher.com) for a better home screen
- [Moon+ Reader Pro](https://play.google.com/store/apps/details?id=com.flyersoft.moonreaderp) for ebooks
- [Smart Audiobook Player](https://play.google.com/store/apps/details?id=ak.alizandro.smartaudiobookplayer)
- [mMusic Mini Audio Player](https://play.google.com/store/apps/details?id=mindmine.music.mini) for my local music library
- [Simple Text](https://play.google.com/store/apps/details?id=simple.text.dropbox) is better than Dropbox for text editing
