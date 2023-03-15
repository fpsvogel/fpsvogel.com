---
title: The Keyboardio Atreus
subtitle: typing less painfully, part 2
---

- [Choosing an ergonomic keyboard](#choosing-an-ergonomic-keyboard)
- [Customizing the Atreus](#customizing-the-atreus)
- [Conclusion](#conclusion)
- [Appendix: my Kaleidoscope sketch](#appendix-my-kaleidoscope-sketch)

Recently [I switched to the Colemak keyboard layout](/posts/2021/learn-colemak-keyboard.html) in order to type more pleasantly and avoid wrist injury. After those miserable weeks re-learning how to type, I thought, "Heck, why stop here when I could spend a few more weeks learning an entirely new physical arrangement of keys?" I mean, why not?

And so it was that a new adventure began, one that took me far out into the wilds of keyboard nerdom, but which in the end brought me closer to home—that is, the home row.

## Choosing an ergonomic keyboard

There are a few problems with standard keyboards: their straight (and oddly staggered) rows do not fit the natural shape of the hand, their modifier keys must be reached with the weakest fingers, and many common keys are far from the home row. (Despite Mavis Beacon, I never did learn how to type the number row without looking.)

So I set out in quest of a better keyboard, and it wasn't long before I stumbled into the wonderful and awe-inspiring world of custom-built mechanical keyboards of all shapes and sizes: ortholinear, columnar-staggered, 40%, split, thumb cluster—plus dozens of key switches to choose from—oh, and have your soldering iron handy because typically these are built from kits.

…

(ノಠ益ಠ)ノ彡┻━┻

I just want a decent keyboard, for Pete's sake.

Fortunately, I found an easy way out for newbs like me who don't want to invest a significant portion of a lifetime in acquiring a keyboard: the conveniently pre-made and inexpensive [Keyboardio Atreus](https://shop.keyboard.io/products/keyboardio-atreus?variant=31382377201737). I bought mine with BOX Brown key switches, mainly because by that point I had major decision fatigue and so I took Keyboardio's recommendation of BOX Browns for newcomers. A decision saved is a decision gained, as they say.

A couple of broken-on-arrival key switches were promptly replaced with a care package sent by Keyboardio (great customer service!), and then I was ready for the next phase of the journey.

## Customizing the Atreus

The Atreus has only 46 keys, instead of the usual 78-ish (laptops) or over 100 (desktops). So for most non-alphabetic characters, the Atreus has multiple layers which are accessed with Shift-like keys, but for numbers and symbols instead of uppercase letters (or like a laptop's Fn key, but in a more reachable place). This is great because it's easier to press a shift key plus a key near the home row, than to reach across the keyboard without layers. (Just imagine if a standard keyboard didn't even have the Shift layer for uppercase letters. That would be a huge keyboard. Though maybe not [this huge](https://www.hackster.io/news/someone-made-a-massive-mechanical-keyboard-with-450-individual-key-switches-0cba1018f2f8).)

If the default configuration of layers suits you well, then you can stop reading now and return to your normal life, living happily ever after with your new Atreus.

However, I wanted to take that great idea even further. To start off, here is the default layout of the Atreus:

![Keyboardio Atreus default layout](/images/keyboardio-atreus-default-layout.png)

The outer thumb keys were hard to reach, and I didn't like the placement of some symbols and numbers. The beautiful thing about the Atreus and other DIY keyboards is that they are entirely customizable. So I customized and customized, ending up with the layout below, shown one layer at a time. (The letter keys are QWERTY because I use Colemak via an installed keyboard layout, not hardcoded into my Atreus.)

Layer 1:

![Keyboardio Atreus custom layout, layer 1](/images/keyboardio-atreus-custom-layout-layer-1.png)

Layer 2:

![Keyboardio Atreus custom layout, layer 2](/images/keyboardio-atreus-custom-layout-layer-2.png)

Layer 3:

![Keyboardio Atreus custom layout, layer 3](/images/keyboardio-atreus-custom-layout-layer-3.png)

Layer 4:

![Keyboardio Atreus custom layout, layer 4](/images/keyboardio-atreus-custom-layout-layer-4.png)

This layout maximizes the time that my hands are in or near a natural position, in a few ways:

- **It compresses the most frequent thumb keys toward the center** in Layer 1 by making them do double duty (tap for one function, press for another) so that most of the time each thumb only has to move one or two keys over. The only downsides to this setup are (1) with these keys I can no longer spam the primary (tap) keys by holding them down, and (2) I can't use a tap key in any shortcut where a necessary modifier is accessed by holding down that same key. My solution is to have duplicates of these tap keys (<kbd>Delete</kbd>, <kbd>Backspace</kbd>, <kbd>Enter</kbd>, <kbd>Tab</kbd>) in places where they can be held down and used with modifiers. If the layout looks complicated, this is why.
- ***The non-alphabetic characters that I use most frequently are in the most convenient spots.** Of course, your most frequent characters are bound to be different than mine, so this must be customized per user.
- ***The now-adjacent Shift and Control can both be pressed down with just the left thumb,** thanks to the angling of these two innermost thumb keys. This means I can press <kbd>Shift</kbd> + <kbd>Control</kbd> shortcuts without any other fingers leaving their usual position.
- **Mouse-to-keyboard switching is minimized.** When I have my right hand on the mouse, I can often leave it there because the important modifiers and utility keys are either under my left thumb, or within a manageable reach on the inner right side.

(Side note: while we're talking about finger positioning, here's a tip that [I found by chance](https://www.codesections.com/blog/atreus-review/), in case you're a new Atreus user struggling to reach Q and P with your pinkies: *"Phil Hagelberg very helpfully replied that he designed the Atreus with the idea that you'd hit the <kbd>q</kbd> and <kbd>p</kbd> keys with a diagonal motion from your ring fingers instead of with the pinky extension from the traditional typing technique. This means that, when your pinkies rest on the <kbd>a</kbd> and <kbd>;</kbd> keys, they're already fully extended – they can't comfortably extend further up, but can more comfortably fold down to hit the <kbd>z</kbd> and <kbd>.</kbd> keys."* A good decision, I think, considering the pinky finger's limited range of motion.)

Back to the layout: I configured it with [Kaleidoscope](https://kaleidoscope.readthedocs.io/en/latest/), the firmware that comes with the Atreus. There is also the GUI configuration tool [Chrysalis](https://github.com/keyboardio/Chrysalis), which is handy to start out with. But several key features of my layout are only accessible by editing the Kaleidoscope sketch directly. If you start out with Chrysalis but then switch to Kaleidoscope, be sure to clear the EEPROM in Chrysalis or remove EEPROM from the Kaleidoscope code, otherwise Chrysalis settings will override those in Kaleidoscope.

Below I've appended the code for my layout.

There is one AutoHotkey shortcut that makes this layout even more convenient, by making <kbd>Alt</kbd> + <kbd>Enter</kbd> act as <kbd>Alt</kbd> + <kbd>Tab</kbd> for switching windows. This way, window-switching mirrors tab-switching (<kbd>Ctrl</kbd> + <kbd>Tab</kbd>).

```cpp
!Enter::
  Send {LAlt Down}{Tab}
return
```

## Conclusion

I love my Atreus, and I love that I can customize it to my taste and needs. It took several evenings to learn Kaleidoscope and tweak my layout to my satisfaction, and I am still getting used to this new way of typing, but it is time well spent. Already my fingers glide like they never have before, with none of the twisting and turning that slowed me down and strained my wrists on a standard keyboard.

And with that, my keyboard journey is over for now. It has taken a real effort to learn Colemak and switch to a nonstandard keyboard, but it was 100% worth it.

Besides getting this better keyboard, I'm also taking other steps to combat the aching in my wrists. More on that in a future post.

## Appendix: my Kaleidoscope sketch

```cpp
/* -*- mode: c++ -*-
 * Atreus -- Chrysalis-enabled Sketch for the Keyboardio Atreus
 * Copyright (C) 2018, 2019  Keyboard.io, Inc
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef BUILD_INFORMATION
#define BUILD_INFORMATION "locally built"
#endif

#include "Kaleidoscope.h"
#include "Kaleidoscope-Macros.h"
#include "Kaleidoscope-OneShot.h"
#include "Kaleidoscope-Qukeys.h"
#include "Kaleidoscope-HostOS.h"
#include "Kaleidoscope-Unicode.h"

#define SHIFT(n) ShiftToLayer(n)
#define LOCK(n) LockLayer(n)

// Macros
enum {
  MACRO_QWERTY,
  MACRO_VERSION_INFO,
  EM_DASH,
  EN_DASH,
  LEFT_SINGLE_QUOTE,
  RIGHT_SINGLE_QUOTE,
  LEFT_DOUBLE_QUOTE,
  RIGHT_DOUBLE_QUOTE,
  ELLIPSIS,
  THINK,
  THUMB,
  HI_FIVE,
  SWEAT
};

#define Key_Exclamation LSHIFT(Key_1)
#define Key_At LSHIFT(Key_2)
#define Key_Hash LSHIFT(Key_3)
#define Key_Dollar LSHIFT(Key_4)
#define Key_Percent LSHIFT(Key_5)
#define Key_Caret LSHIFT(Key_6)
#define Key_And LSHIFT(Key_7)
#define Key_Star LSHIFT(Key_8)
#define Key_Plus LSHIFT(Key_Equals)
#define Key_Pipe LSHIFT(Key_Backslash)
#define Key_Question LSHIFT(Key_Slash)
#define Key_Colon LSHIFT(Key_P)  // P is ; in Colemak
#define Key_Underscore LSHIFT(Key_Minus)
#define Key_DoubleQuote LSHIFT(Key_Quote)
#define Key_RightAngleBracket LSHIFT(Key_Period)
#define Key_LeftAngleBracket LSHIFT(Key_Comma)

// Layers
enum {
  QWERTY,
  FUN,
  UPPER,
  SUPER
};

/* *INDENT-OFF* */
KEYMAPS(
  [QWERTY] = KEYMAP_STACKED
  (
       Key_Q   ,Key_W        ,Key_E      ,Key_R         ,Key_T
      ,Key_A   ,Key_S        ,Key_D      ,Key_F         ,Key_G
      ,Key_Z   ,Key_X        ,Key_C      ,Key_V         ,Key_B         ,Key_Backslash
      ,Key_Esc ,Key_CapsLock ,Key_Delete ,Key_Backspace ,Key_Backspace ,Key_Enter

                     ,Key_Y     ,Key_U  ,Key_I     ,Key_O      ,Key_Minus
                     ,Key_H     ,Key_J  ,Key_K     ,Key_L      ,Key_Semicolon
       ,Key_Backtick ,Key_N     ,Key_M  ,Key_Comma ,Key_Period ,Key_Quote
       ,Key_Tab      ,Key_Space ,Key_F4 ,Key_Tab   ,Key_Enter  ,Key_LeftGui
  ),

  [FUN] = KEYMAP_STACKED
  (
       Key_5      ,Key_6                ,Key_7                 ,Key_8         ,Key_9
      ,Key_0      ,Key_1                ,Key_2                 ,Key_3         ,Key_4
    //,Key_Delete ,M(LEFT_DOUBLE_QUOTE) ,M(RIGHT_DOUBLE_QUOTE) ,M(THUMB)      ,M(LEFT_SINGLE_QUOTE) ,M(RIGHT_SINGLE_QUOTE)
    // Unicode macros are commented out because I use Windows and Unicode.type (below) is not working on Windows right now. See https://github.com/keyboardio/Kaleidoscope/issues/1031
      ,Key_Delete ,___                  ,___                   ,___           ,___                  ,___
      ,___        ,___                  ,Key_RightControl      ,Key_Backspace ,Key_Backspace        ,Key_Enter
      // RightControl is remapped to Calculator in SharpKeys

              //,M(HI_FIVE) ,Key_PageUp        ,Key_UpArrow   ,Key_PageDown   ,Key_Minus
                ,___        ,Key_PageUp        ,Key_UpArrow   ,Key_PageDown   ,Key_Minus
                ,Key_Home   ,Key_LeftArrow     ,Key_DownArrow ,Key_RightArrow ,Key_End
    //,M(SWEAT) ,M(THINK)   ,Key_PcApplication ,Key_Comma     ,Key_Period     ,Key_LeftArrow
      ,___      ,___        ,Key_PcApplication ,Key_Comma     ,Key_Period     ,Key_LeftArrow  // corner arrow keys for skipping in video playback (easy to press w/ hand resting)
      ,Key_Tab  ,Key_Space  ,___               ,Key_Tab       ,Key_Enter      ,Key_RightArrow
   ),

  [UPPER] = KEYMAP_STACKED
  (
       M(EM_DASH)      ,M(EN_DASH)      ,Key_At            ,Key_Hash   ,Key_Percent
      ,Key_Question    ,Key_Exclamation ,Key_Colon         ,Key_Equals ,Key_Slash
      ,Key_Backspace   ,Key_Pipe        ,Key_And           ,Key_P      ,Key_Dollar    ,___  // P is ; in Colemak
      ,Key_ScrollLock  ,Key_PrintScreen ,Key_KeypadNumLock ,___        ,Key_LeftShift ,Key_LeftControl
      // ScrollLock, PrintScreen, and NumLock are remapped to Volume Up/Down and Mute in SharpKeys
      // (Key_VolumeUp, Key_VolumeDown, and Key_Mute do not work for me)

                   ,Key_Caret       ,Key_LeftCurlyBracket ,Key_RightCurlyBracket ,___                   ,Key_Underscore
                 //,Key_Star        ,Key_LeftParen        ,Key_RightParen        ,Key_Plus              ,M(ELLIPSIS)
                   ,Key_Star        ,Key_LeftParen        ,Key_RightParen        ,Key_Plus              ,___
      ,___         ,Key_LeftBracket ,Key_RightBracket     ,Key_LeftAngleBracket  ,Key_RightAngleBracket ,Key_DoubleQuote
      ,Key_LeftAlt ,Key_Space       ,Key_Enter            ,Key_Tab               ,Key_Enter             ,___
   ),

  [SUPER] = KEYMAP_STACKED
  (
       Key_F13 ,Key_F14 ,Key_F15 ,Key_F16   ,Key_F11
      ,Key_F17 ,Key_F18 ,Key_F19 ,Key_F20   ,Key_F5
      ,Key_F21 ,Key_F22 ,Key_F23 ,Key_F24   ,Key_F2        ,Key_F3
      ,Key_F12 ,___     ,___     ,___       ,Key_LeftShift ,Key_LeftControl

                   ,___ ,Key_F12   ,Key_F11 ,Key_F10 ,Key_F9
                   ,___ ,Key_F8    ,Key_F7  ,Key_F6  ,Key_F5
      ,Key_F4      ,___ ,Key_F4    ,Key_F3  ,Key_F2  ,Key_F1
      ,Key_LeftAlt ,___ ,LOCK(FUN) ,___     ,___     ,___
   )
)
/* *INDENT-ON* */

KALEIDOSCOPE_INIT_PLUGINS(
  Qukeys,
  OneShot,
  Macros,
  HostOS,
  Unicode
);

static void unicode(uint32_t character, uint8_t keyState) {
  if (keyToggledOn(keyState)) {
    Unicode.type(character);
  }
}

const macro_t *macroAction(uint8_t macroIndex, uint8_t keyState) {
  switch (macroIndex) {
  case MACRO_QWERTY:
    // This macro is currently unused, but is kept around for compatibility
    // reasons. We used to use it in place of `MoveToLayer(QWERTY)`, but no
    // longer do. We keep it so that if someone still has the old layout with
    // the macro in EEPROM, it will keep working after a firmware update.
    Layer.move(QWERTY);
    break;
  case MACRO_VERSION_INFO:
    if (keyToggledOn(keyState)) {
      Macros.type(PSTR("Keyboardio Atreus - Kaleidoscope "));
      Macros.type(PSTR(BUILD_INFORMATION));
    }
    break;
  case EM_DASH:
    unicode(0x2014, keyState);
    break;
  case EN_DASH:
    unicode(0x2013, keyState);
    break;
  case LEFT_SINGLE_QUOTE:
    unicode(0x2018, keyState);
    break;
  case RIGHT_SINGLE_QUOTE:
    unicode(0x2019, keyState);
    break;
  case LEFT_DOUBLE_QUOTE:
    unicode(0x201C, keyState);
    break;
  case RIGHT_DOUBLE_QUOTE:
    unicode(0x201D, keyState);
    break;
  case ELLIPSIS:
    unicode(0x2026, keyState);
    break;
  case THINK:
    unicode(0x1F914, keyState);
    break;
  case THUMB:
    unicode(0x1F44D, keyState);
    break;
  case HI_FIVE:
    unicode(0x1F64C, keyState);
    break;
  case SWEAT:
    unicode(0x1F605, keyState);
    break;
  }

  return MACRO_NONE;
}

void setup() {
  QUKEYS(
    kaleidoscope::plugin::Qukey(0, KeyAddr(3, 1), SHIFT(SUPER)),      // CapsLock/SUPER
    kaleidoscope::plugin::Qukey(0, KeyAddr(3, 2), SHIFT(FUN)),        // Delete/FUN
    kaleidoscope::plugin::Qukey(0, KeyAddr(3, 3), SHIFT(UPPER)),      // Backspace/UPPER
    kaleidoscope::plugin::Qukey(1, KeyAddr(3, 3), SHIFT(UPPER)),      // Backspace/UPPER in FUN
    kaleidoscope::plugin::Qukey(0, KeyAddr(3, 4), Key_LeftShift),     // Backspace/Shift
    kaleidoscope::plugin::Qukey(1, KeyAddr(3, 4), Key_LeftShift),     // Backspace/Shift in FUN
    kaleidoscope::plugin::Qukey(0, KeyAddr(3, 5), Key_LeftControl),   // Enter/Ctrl
    kaleidoscope::plugin::Qukey(1, KeyAddr(3, 5), Key_LeftControl),   // Enter/Ctrl in FUN
    kaleidoscope::plugin::Qukey(0, KeyAddr(3, 6), Key_LeftAlt),       // Tab/Alt
    kaleidoscope::plugin::Qukey(1, KeyAddr(3, 6), Key_LeftAlt),       // Tab/Alt in FUN
    kaleidoscope::plugin::Qukey(0, KeyAddr(3, 8), SHIFT(FUN)),        // F4/FUN
    kaleidoscope::plugin::Qukey(2, KeyAddr(3, 8), SHIFT(FUN)),        // Enter/FUN in UPPER
  )
  Qukeys.setHoldTimeout(250);  // a lower value than this causes modifier or primary key sometimes not to register when they should
  Qukeys.setOverlapThreshold(1);
  Qukeys.setMinimumHoldTime(1);
  Qukeys.setMinimumPriorInterval(1);
  Qukeys.activate();

  Kaleidoscope.setup();
}

void loop() {
  Kaleidoscope.loop();
}
```
