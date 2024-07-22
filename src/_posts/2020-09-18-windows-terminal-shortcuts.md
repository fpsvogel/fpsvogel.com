---
title: Set up Windows Terminal shortcuts
subtitle: and make Windows a bit more usable
description: How to make Windows Terminal easier to reach via shortcuts.
---

- [Add a Windows Terminal submenu to the Explorer context menu](#add-a-windows-terminal-submenu-to-the-explorer-context-menu)
- [Create a global hotkey for Windows Terminal](#create-a-global-hotkey-for-windows-terminal)

***UPDATE, February 2023:** I've now switched to Linux on my PC, and [wrote a post about it](/posts/2023/switch-to-linux-from-windows). I wish I had made the switch sooner!*

***UPDATE, April 2021:** Disregard my rueful comments below, because development on Windows is a breeze now that I've started using WSL (Windows Subsystem for Linux). It's [so easy to set up](https://twitter.com/fpsvogel/status/1383017405551673349) that I regret not doing so as soon as I learned about it last year. Dilapidated Windows builds of development tools are now a thing of the past for me. Hallelujah!*

Today's productivity how-to: set up context menu shortcuts and a global hotkey for the new Windows Terminal.

But first, the obvious confession: I use Windows. I don't love Windows; it's just that the effort of switching has never seemed justified, when I'd only be trading my Windows annoyances for a new set of problems that inevitably comes with any OS.

So I've stuck with Windows—despite the mockery of Apple devotees, despite the scornful grimaces of Linux hackers, and despite the occasional pain of setting up development tools, when the installation instructions consist of a single sentence on how to install the latest version in Linux or MacOS, followed by that familiar line: *"Windows users, **click here** for a Windows build that some bozo put together for your crappy OS. Oh, and it's from five years ago."*

There are some hopeful signs, though. Windows is finally getting [a native package manager](https://devblogs.microsoft.com/commandline/windows-package-manager-preview/), and the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about) has been out for a while now.

Another welcome relief is [Windows Terminal](https://devblogs.microsoft.com/commandline/windows-terminal-1-0/). No more juggling five windows of three different consoles: Windows Terminal has tabs and panes. It's faster than the third-party terminals I've tried. It's also quick to open, with context menu shortcuts and a global hotkey to open up a terminal in the current directory.

… Wait, say again? Windows Terminal *doesn't* have context menu shortcuts? No hotkey, either? Sigh… Here's how you can supply those missing pieces.

## Add a Windows Terminal submenu to the Explorer context menu

Fortunately, some kind souls have done most of the work already with [a PowerShell script to install context menu items for Windows Terminal](https://github.com/lextm/windowsterminal-shell). However, it didn't quite work for me, so here's what I changed.

**Tweak the registry location.** If you follow the instructions with no results, try this: in "install.ps1" replace `HKEY_CURRENT_USER\SOFTWARE\Classes\Directory` with `HKEY_CLASSES_ROOT\Directory`.

**Replace admin mode commands.** If the "as administrator" menu items don't work, try this: in the registry editor, go to "HKEY_CLASSES_ROOT\Directory\ContextMenus\MenuTerminalAdmin\shell" and replace the value in each "command" key with these:

- for cmd: `PowerShell -windowstyle hidden -Command "Start-Process cmd -ArgumentList '/s,/k,pushd,%V' -Verb RunAs"`
- for PowerShell 7: `C:\Program Files\PowerShell\7\pwsh.exe -NoExit -RemoveWorkingDirectoryTrailingCharacter -WorkingDirectory "%V!" -Command "$host.UI.RawUI.WindowTitle = 'PowerShell 7 (x64)'"`

Unfortunately, these commands open Command Prompt and Powershell rather than Windows Terminal… but for me it doesn't matter because I typically use `gsudo` in a regular Windows Terminal anyway (more on that below).

**Add profiles for other command lines that you use.** For example, [add a WSL profile](https://stackoverflow.com/questions/56765067/how-do-i-get-windows-10-terminal-to-launch-wsl).

## Create a global hotkey for Windows Terminal

If you're a keyboard junkie, surely you don't want to muck around with a context *submenu*—how plebeian! So here's an [AutoHotkey](https://www.autohotkey.com) script that opens the terminal with a default starting directory, or with the current directory if an Explorer window is in focus.

```cpp
#CommentFlag //
#NoEnv  // Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  // Recommended for new scripts due to its superior speed and reliability.
profile = Felipe  // replace with your user profile name

F13 & r::  // i.e. #r (LWin+R) thanks to SharpKeys
// if an Explorer window is not active
If !(WinActive("ahk_class CabinetWClass"))
  // or write in your own default directory after -d
  Run "C:\Users\%profile%\AppData\Local\Microsoft\WindowsApps\wt.exe" -d "C:\"
Else {  // open to the current directory in Explorer
  WinGetTitle, Title, A
  if (Title = "Downloads") {
    Title = "C:\Users\%profile%\Downloads"
  }
  Run "C:\Users\%profile%\AppData\Local\Microsoft\WindowsApps\wt.exe" -d "%Title%"
}
Return
```

(You may be raising an eyebrow at my odd hotkey <kbd>F13</kbd> + <kbd>R</kbd>. Actually it's <kbd>Windows</kbd> + <kbd>R</kbd>, after remapping the Windows key to <kbd>F13</kbd> with [SharpKeys](https://github.com/randyrants/sharpkeys). If you've ever wondered how to get rid of those pesky Windows shortcuts and turn the Windows key into an extra modifier key, there you have it. For more on that, see my next post on AutoHotkey.)

For executing commands with elevated privileges, I like using [gsudo](https://github.com/gerardog/gsudo) from within a regular (non-admin) terminal. If you really want a separate hotkey to open the terminal as administrator, you'll need to [choose from a few workarounds](https://stackoverflow.com/a/62542633/4158773).

And with that, you have a respectable terminal even in Windows. Coming up next: supercharge your keyboard (and your mouse!) with AutoHotkey.
