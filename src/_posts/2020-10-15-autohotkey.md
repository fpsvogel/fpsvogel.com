---
title: AutoHotkey - Windows key, home row arrow keys, mouse shortcuts
subtitle: and other hacks for Windows productivity
---

- [SharpKeys for key remapping](#sharpkeys-for-key-remapping)
- [AutoHotkey: opening apps with the Windows key](#autohotkey-opening-apps-with-the-windows-key)
- [AutoHotkey: mouse shortcuts](#autohotkey-mouse-shortcuts)
- [AutoHotkey: home row arrow keys](#autohotkey-home-row-arrow-keys)
- [AutoHotkey: modifier functions](#autohotkey-modifier-functions)
- [The upshot](#the-upshot)

Constantly switching between your keyboard and mouse can be frustrating, especially once you start paying attention to just how much you do it every day. (And now that I've made you start thinking about it, you won't be able to stop. It's the [pink elephant game](https://en.wikipedia.org/wiki/Ironic_process_theory) all over again. You're welcome.)

So I've been on a quest to use my keyboard and mouse more efficiently, and here's what I have so far.

## SharpKeys for key remapping

In Windows, [AutoHotkey](https://www.autohotkey.com/) is the Swiss Army knife of productivity. But I use [SharpKeys](https://github.com/randyrants/sharpkeys) for lower-level key remapping, and my AutoHotkey scripts only make sense in the context of those remappings, so let's start there.

In SharpKeys I've remapped the following keys:

* <kbd>Caps Lock</kbd> to <kbd>Backspace</kbd>
* <kbd>Right Shift</kbd> to <kbd>Delete</kbd>
* <kbd>Backspace</kbd> to <kbd>Calculator</kbd>
* <kbd>Left Windows</kbd> to <kbd>F13</kbd>

The first two are to bring Backspace and Delete closer to the home row. (I hardly ever used Caps Lock and Right Shift anyway.) The third is just to make use of the now-replaced Backspace key. Or you could remap it to <kbd>F14</kbd> and make a script for <kbd>F14</kbd> in AutoHotkey (see below).

The last remapping in the list disables Windows shortcuts, which are more annoying than useful, and in the process you gain a whole new modifier key. We'll now use this wiped-clean Windows key to set up app hotkeys on the left side of the keyboard, and home row arrow keys on the right side.

## AutoHotkey: opening apps with the Windows key

Previously I've shared [how to set up a Windows Terminal hotkey](/posts/2020/windows-terminal.html) using this same technique of remapping the Windows key. Here are some other essential hotkeys for our wiped-clean Windows key. You can also add hotkeys for favorite apps: for example, for work apps I have several "Run" lines under `F13 & w::` (i.e. <kbd>Win</kbd> + <kbd>W</kbd>).

```cpp
#CommentFlag //
#NoEnv
SendMode Input
// so that the right-click menu is not shown after using the
//   right button as modifier (see mouse shortcuts below)
blockContextMenu := false

// = = = = = = = PROGRAMS = = = = = = =

// LWin is remapped to F13 in SharpKeys, to avoid Windows shortcuts
F13 & q::Send ^{Esc}  // start menu
F13 & e::Run explore "C:\Users\User1\Downloads"  // open Explorer
F13 & t::Run "C:\Program Files\Microsoft VS Code\Code.exe" "C:\Users\User1\Dropbox\.archive\.bin\Felipe-hotkeys.ahk"
// make AutoHotkey reload this script (do it right after saving the file)
F13 & s::Reload
return

// = = = = = = = USABILITY = = = = = = =

// context menu
RWin::Send {AppsKey}
return

// Esc closer to home row (and closes frequently-used apps)
// CapsLock is remapped to Backspace in Sharpkeys
F13 & Backspace::
  WinGet, active_proc, ProcessName, A
  if (active_proc = "explorer.exe"
      || active_proc = "cloudapp.exe"
      || active_proc = "jpegview64.exe")
    Send !{F4}
  else if !CloseBeeftext()
    Send {Esc}
return
```

More keyboard shortcuts shortly, but first let's switch over to the mouse.

## AutoHotkey: mouse shortcuts

A lot of power users scorn the mouse. Yes, it is far from ideal for many tasks. If I'm typing an email and I want to check on something in another tab, it's quicker to hop over with keyboard shortcuts—Vimium makes it even easier. But I'm going to side with the masses and say that the mouse was a wonderful invention. It's indispensable for browsing the web, photo editing, and many other tasks.

Maybe the reason I love my mouse is that it's so much more convenient now that I've given it some AutoHotkey love. The key is to cram useful navigation functions into the mouse buttons. I use [a very basic mouse](https://www.amazon.com/Logitech-Wireless-Computer-Mouse-Side/dp/B003NR57BY), but now its 7 buttons can do wonders. In particular, I *constantly* use the side buttons (`XButton1` and `XButton2` below) to switch windows and close tabs.

There's a lot going on in the snippet below, so here's a visual summary of my mouse shortcuts:

![mouse shortcuts made with AutoHotkey](/images/mouse.png)

```cpp
// = = = = = = = MOUSE SHORTCUTS = = = = = = =

// mouse buttons to switch windows and tabs
XButton1::  // back button
  // left or right button modifier: browser back
  if (GetKeyState("LButton", "P")) {
    Send !{Left}
  } else if (GetKeyState("RButton", "P")) {
    blockContextMenu := true
    Send !{Left}
  } else {  // no mouse modifier: switch window
    Send {LAlt Down}{Tab}
  }
return
// allows back button to be pressed for Alt+Tab window menu to stay up
XButton1 Up::
  if !(GetKeyState("LButton", "P") || GetKeyState("RButton", "P")) {
    Send {LAlt Up}
  }
return
XButton2::  // forward button
  // left or right button modifier: refresh
  if (GetKeyState("LButton", "P")) {
    Send {F5}
  } else if (GetKeyState("RButton", "P")) {
    blockContextMenu := true
    Send {F5}
  // no mouse modifier: close tab or window
  } else {
    WinGet, active_proc, ProcessName, A
    if (active_proc = "chrome.exe"
        || active_proc = "firefox.exe"
        || active_proc = "Code.exe")
      Send ^{F4}
    else if !CloseBeeftext()
      Send !{F4}
  }
return

MButton::
  if !(WinActive("ahk_class CabinetWClass"))
  {
    // left or right button modifier: browser forward
    if (GetKeyState("LButton", "P")) {
      Send !{Right}
    } else if (GetKeyState("RButton", "P")) {
      blockContextMenu := true
      Send !{Right}
    } else  // no mouse modifier
      Send {MButton}
  // delete in Explorer (best combined with Explorer's single-click mode)
  } else {
    Send {MButton}
    Sleep 50
    Send {Delete}
    Sleep 50
    Send {Space}
  }
return

WheelLeft::
  if !(WinActive("ahk_class CabinetWClass"))
    Send ^+{Tab}  // switch tabs left
  else
    Send !{Up}  // up one level in Explorer
return
WheelRight::
  if !(WinActive("ahk_class CabinetWClass"))
    Send ^{Tab}  // switch tabs right
  else
    // back in Explorer (i.e. down one level if went up one level)
    Send !{Left}
return

// right click as wheel modifier: mega scroll
// the simpler method RButton & WheelUp causes problems with click state
WheelUp::
  if (GetKeyState("RButton", "P")) {
    blockContextMenu := true
    Send {WheelUp 15}
  } else
    Send {WheelUp}
return
WheelDown::
  if (GetKeyState("RButton", "P")) {
    blockContextMenu := true
    Send {WheelDown 15}
  } else
    Send {WheelDown}
return

// do not show context menu if mega scrolled
RButton Up::
  if (blockContextMenu)
    blockContextMenu := false
  else
    Send {RButton}
return
```

## AutoHotkey: home row arrow keys

The more you use the keyboard instead of the mouse, the more you'll be annoyed with another common switch: from the home row down to the arrow keys. There is [the traditional way](https://vi.stackexchange.com/a/9315) of doing this with <kbd>hjkl</kbd>, but I've opted for my own setup: <kbd>ijkl</kbd> for arrow keys, plus <kbd>h</kbd> and <kbd>;</kbd> for Home and End, plus <kbd>u</kbd> and <kbd>o</kbd> for Page Up and Page Down. All of these are activated with our faux Windows key pressed down. See the next section for an explanation of the modifier functions `Shift()`, `Alt()`, etc.

Here's a summary of all my keyboard shortcuts and remappings, with a friendly wizard denoting our transformed Windows key. The icons on letter keys are for when the Windows key is pressed.

![keyboard shortcuts made with AutoHotkey](/images/keyboard.png)

```cpp
// = = = = = = = HOME ROW ARROW KEYS + home/end, page up/down = = = = = = =

F13 & j::
  if Shift()
    Send +{Left}
  else if Alt()
    Send !{Left}
  else if Ctrl()
    Send ^{Left}
  else if CtrlShift()
    Send ^+{Left}
  else if AltShift()
    Send !+{Left}
  else if CtrlAlt()
    Send ^!{Left}
  else if CtrlAltShift()
    Send ^!+{Left}
  else Send {Left}
return
F13 & l::
  if Shift()
    Send +{Right}
  else if Alt()
    Send !{Right}
  else if Ctrl()
    Send ^{Right}
  else if CtrlShift()
    Send ^+{Right}
  else if AltShift()
    Send !+{Right}
  else if CtrlAlt()
    Send ^!{Right}
  else if CtrlAltShift()
    Send ^!+{Right}
  else Send {Right}
return
F13 & i::
  if Shift()
    Send +{Up}
  else if Alt()
    Send !{Up}
  else if Ctrl()
    Send ^{Up}
  else if CtrlShift()
    Send ^+{Up}
  else if AltShift()
    Send !+{Up}
  else if CtrlAlt()
    Send ^!{Up}
  else if CtrlAltShift()
    Send ^!+{Up}
  else Send {Up}
return
F13 & k::
  if Shift()
    Send +{Down}
  else if Alt()
    Send !{Down}
  else if Ctrl()
    Send ^{Down}
  else if CtrlShift()
    Send ^+{Down}
  else if AltShift()
    Send !+{Down}
  else if CtrlAlt()
    Send ^!{Down}
  else if CtrlAltShift()
    Send ^!+{Down}
  else Send {Down}
return
F13 & h::
  if Shift()
    Send +{Home}
  else Send {Home}
return
F13 & `;::
  if Shift()
    Send +{End}
  else Send {End}
return
F13 & u::
  if Shift()
    Send +{PgUp}
  else Send {PgUp}
return
F13 & o::
  if Shift()
    Send +{PgDn}
  else Send {PgDn}
return
```

## AutoHotkey: modifier functions

We've been using AutoHotkey's custom combinations feature to make our remapped Windows key act like a modifier, so that `F13 & j` is analogous to `#j` (where `#` is the regular Windows key). The limitation of this feature is that it doesn't accept any additional modifiers: `F13 & ^j` doesn't work, nor does `F13 & Ctrl & j`. So I've made functions that check for each modifier.

```cpp
// = = = = = MODIFIERS FOR F13 (LWIN REMAPPED) = = = = =

Ctrl() {
  if (GetKeyState("LAlt") || GetKeyState("LShift"))
    return 0
  else return GetKeyState("LCtrl")
}
Alt() {
  if (GetKeyState("LCtrl") || GetKeyState("LShift"))
    return 0
  else return GetKeyState("LAlt")
}
Shift() {
  if (GetKeyState("LCtrl") || GetKeyState("LAlt"))
    return 0
  else return GetKeyState("LShift")
}
CtrlAlt() {
  if (GetKeyState("LShift"))
    return 0
  else return (GetKeyState("LCtrl") && GetKeyState("LAlt"))
}
CtrlShift() {
  if (GetKeyState("LAlt"))
    return 0
  else return (GetKeyState("LCtrl") && GetKeyState("LShift"))
}
AltShift() {
  if (GetKeyState("LCtrl"))
    return 0
  else return (GetKeyState("LAlt") && GetKeyState("LShift"))
}
CtrlAltShift() {
  return (GetKeyState("LCtrl") && GetKeyState("LAlt") && GetKeyState("LShift"))
}
```

## The upshot

Is this yet another case of [spending more time than I save](https://xkcd.com/1205/)? Or [getting sidetracked by automation](https://xkcd.com/1319/)? I don't think so. Actually the time spent writing these scripts is trivial compared to how long it takes to train myself to *use* the dang shortcuts. But once you do, navigating windows, tabs, text, and the web is entirely different. Your fingers are like lightning—nay, "tempestuous as the sea, and stronger than the foundations of the earth!"—to borrow the words of a similarly empowered person.

![Galadriel saying "All shall love me!"](/images/memes/galadriel.gif)

Well… just don't let it get to your head, that's all.

***UPDATE:** For more keyboard adventures, see my more recent posts [Learning Colemak](/posts/2021/learn-colemak-keyboard.html) and [The Keyboardio Atreus](/posts/2021/keyboardio-atreus).*
