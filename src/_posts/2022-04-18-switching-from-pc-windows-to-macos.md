---
title: MacOS for PC users
subtitle: a guide for lost souls
---

- [Mouse usability](#mouse-usability)
- [Keyboard usability](#keyboard-usability)
- [Banishing the top menu](#banishing-the-top-menu)
- [Scaling on my 1440p monitor](#scaling-on-my-1440p-monitor)
- [A clipboard manager](#a-clipboard-manager)
- [A better terminal](#a-better-terminal)
- [Conclusion](#conclusion)

I've always been a PC user, and I remained one even after I got into software development. *Unpleasant* and *awful* are words that come to many people's minds when they fathom development on Windows. But by the time I started coding just a few years ago, [WSL](https://docs.microsoft.com/en-us/windows/wsl/install) had come onto the scene, which I think is even more developer-friendly than MacOS because it's *real* Linux.

But recently, as I started my first developer job, I got an obligatory MacBook Pro in the mail. I could no longer avoid the switch. And so, resigned to my fate, I proceeded to customize my Mac to suit my PC-tainted tastes. Here's what I did.

## Mouse usability

MacOS is not friendly to mouse users (except for Apple's Magic Mouse, but I shudder at the thought of using a mouse with only two buttons). My main issues out of the box were that the mouse cursor was way too slow, and scrolling was unusable with the mouse wheel. [SteerMouse](https://plentycom.jp/en/steermouse) gave me options to fix both issues.

## Keyboard usability

To enable Windows-style keyboard shortcuts, I did the following:

- Installed [AltTab](https://alt-tab-macos.netlify.app/).
- Edited `~/Library/KeyBindings/DefaultKeyBinding.Dict` to consist of the snippet below. In case you're wondering, [here](https://developer.apple.com/documentation/appkit/nsstandardkeybindingresponding) is a full list of possible commands, and [here](https://github.com/ttscoff/KeyBindings) are the defaults.
```
{
  "\UF729"  = moveToBeginningOfLine:; // home
  "\UF72B"  = moveToEndOfLine:; // end
  "$\UF729" = moveToBeginningOfLineAndModifySelection:; // shift home
  "$\UF72B" = moveToEndOfLineAndModifySelection:; // shift end
  "@\UF729" = moveToBeginningOfDocument:; // ctrl home
  "@\UF72B" = moveToEndOfDocument:; // ctrl end
  "@$\UF729" = moveToBeginningOfDocumentAndModifySelection:; // ctrl shift home
  "@$\UF72B" = moveToEndOfDocumentAndModifySelection:; // ctrl shift end
  "@\UF702" = moveWordLeft:; // ctrl left
  "@\UF703" = moveWordRight:; // ctrl right
  "@$\UF702" = moveWordLeftAndModifySelection:; // ctrl shift left
  "@$\UF703" = moveWordRightAndModifySelection:; // ctrl shift right
}
```
- Added [this script](https://stackoverflow.com/questions/5407916/zsh-zle-shift-selection/30899296#30899296) to Zsh config to enable familiar text-editing shortcuts in the terminal.
- Followed [these steps](https://stackoverflow.com/a/24100077) to remove alt shortcuts for Unicode characters. This way I can use alt shortcuts for other things.
- Installed [Keyboard Maestro](https://www.keyboardmaestro.com/main/) and set up additional keyboard shortcuts that I like. I'm also using Keyboard Maestro for text expansion. (On Windows I use [Beeftext](https://beeftext.org/).)

## Banishing the top menu

I don't like the MacOS top menu because it forces apps to break [Fitts's Law](https://www.uxtoast.com/ux-laws/fittss-law), which suggests that important UI elements should be hard to miss with the mouse. For example, when I'm a fullscreen browser and I flick the mouse up to a tab that I want to switch to, the cursor usually ends up flying past the browser tabs and up into the top menu, requiring me to move back down a bit. This may seem like no big deal, but when I do these mouse movements many times every day, the extra movement adds up.

To fix this, I set the top menu to auto-hide. Then, to prevent the cursor from revealing the menu, I created a macro in Keyboard Maestro that sets a variable to `%CurrentMouse[2]%` (the cursor Y position), and then moves the mouse down 10 pixels if that value is less than 10 pixels. This macro always runs, repeating every 0.03 seconds. In other words, I've made an invisible barrier 10 pixels below the top of the screen. To reveal the menu, I've set a shortcut in MacOS keyboard settings. The fact that I can no longer access the menu with the mouse is fine because I only rarely need to access the menu, compared with how often I need to press something at the top of an app.

Another annoyance of the top menu is that, shockingly, there's no overflow menu for menu bar icons. When I'm using my laptop screen rather than my external monitor, there's not much extra space on the right side of the menu, and not all the menu bar icons fit. Which means I'm out of luck if I need to get to an icon that isn't one of the lucky few that are visible. [Bartender](https://www.macbartender.com) adds the much-needed overflow menu so that all icons are accessible.

## Scaling on my 1440p monitor

On my laptop monitor I can scale text and UI elements to be larger, but MacOS doesn't give me the same option for my external monitor, where everything appears even more tiny. I could switch to a lower (non-native) resolution, but then everything gets blurry. Apparently, MacOS allows scaling only for 4K monitors. To fix this, I'm using [BetterDummy](https://github.com/waydabber/BetterDummy), which gives me those missing scaling options.

## A clipboard manager

Clipboard manager apps are awesome, and there are a bajillion of them out there. On Windows I use Ditto. The closest thing I found for MacOs is [PasteBot](https://tapbots.com/pastebot).

## A better terminal

To replace MacOS's ugly Terminal I downloaded [iTerm2](https://iterm2.com/) and configured it according to [this guide](https://medium.com/@Clovis_app/configuration-of-a-beautiful-efficient-terminal-and-prompt-on-osx-in-7-minutes-827c29391961) (minus installing Zsh, which now ships with MacOS).

## Conclusion

I don't think I'll ever buy a Mac for personal use, and you can bet that if my company ever gives the option of a company PC laptop, I'll jump on it and make the switch back without a second thought. But until then, my MacBook is at least tolerable. Plus, I can finally stop feeling inferior for using a PC when so many developers rave about their Apple products. Now I've been to the other side, and the grass is not greener there.
