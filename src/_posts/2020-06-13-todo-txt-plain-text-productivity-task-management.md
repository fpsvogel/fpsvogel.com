---
title: Make a custom todo.txt for VS Code
subtitle: and become a productivity beast
description: How to make a VS Code extension to add syntax highlighting to a plain-text todo.txt file.
---

- [todo.txt syntax highlighting in VS Code](#todotxt-syntax-highlighting-in-vs-code)
- [Recurring tasks via a script](#recurring-tasks-via-a-script)
- [UPDATE: August 6, two months in](#update-august-6-two-months-in)

So I wake up one day, and sitting right in front of me is an existential crisis. A big, hairy, gnarly one. It says to me, *"Hey man, you gotta get your act together. You have five (or six? seven?) to-do lists, constantly out of date and misplaced!? That's not gonna cut it anymore."*

Here's how I beat that monster and organized my life with a customized `todo.txt` with VS Code syntax highlighting and a script to add daily, weekly, and monthly recurring tasks automatically. It's plain text, so it's flexible, fast, and easy to sync across my devices.

But first I tried a few popular productivity apps… and immediately gave up on them. Wading through all their features, I missed my old desktop Sticky Notes, despite how numerous and scattered they were. I realized I just needed a way to organize everything in one plain text file.

So then I discovered the venerable [`todo.txt`](http://todotxt.org/) tradition, imbued with that unmistakable musky aroma of Unix geekdom. I loved the idea, but then I found [an even more flexible approach](https://jeffhuang.com/productivity_text_file/) that incorporates appointments *and* a log/journal of notes and completed tasks, so that you don't have to juggle a calendar throughout the day or constantly lose scattered ideas and findings: it's all in your to-do/appointment/journal... thingy.

So in the end, after several other existential crises showing up and accusing me of actually being *un*productive in my quest for perfect productivity, here's what my `todo.txt` looks like. (Hover or press the image for notes.)

<%= render "hover_image", original: "todo-example.png", hover: "todo-example-annot.png" %>

Of course, you could lay out your tasks and notes differently according to your taste, but the idea is to color-code different kinds of tasks and metadata—for example, in this implementation:

<style scoped>
  .red-todo { color: #F38D8D }
  .yellow-todo { color: #F3ED72 }
  .blue-todo { color: #6CB6FF }
  .purple-todo { color: #C583FA }
  .cyan-todo { color: #00FFFF }
  .gray-todo { color: #9E9E9E }
  .brown-todo { color: #A3A352 }
  @media (prefers-color-scheme: light) {
    .red-todo { color: #d06969 }
    .yellow-todo { color: #9f9929 }
    .blue-todo { color: #5091d1 }
    .cyan-todo { color: #10afaf }
    .gray-todo { color: #848484 }
    .brown-todo { color: #8b8b45 }
  }
</style>

- <span class="red-todo">red:</span> urgent tasks (<code>*</code>) and appointments
- <span class="yellow-todo">yellow:</span> blocked/waiting tasks (<code>`</code>)
- <span class="blue-todo">blue:</span> tags (<code>@</code>)
- <span class="purple-todo">purple:</span> URLs
- <span class="cyan-todo">cyan:</span> date headings (<code>##</code>)
- <span class="gray-todo">gray:</span> notes (<code>></code>)
- <span class="brown-todo">brown:</span> quotes or other long text (<code>{...}</code>)

And since it's all just plain text, it's very portable and mobile-friendly: I just keep `todo.txt` synced to cloud storage, and I can edit on the go with a cloud-syncing text editor on my phone (currently [Simple Text](https://play.google.com/store/apps/details?id=simple.text.dropbox) on Android).

There were two tricky bits in setting this up: (1) the syntax highlighting, and (2) the script to add recurring tasks. Here are my solutions for each.

## todo.txt syntax highlighting in VS Code

Color-coding my `todo.txt` in VS Code involved a few steps:

1. Figure out a regular expression for each of the items listed above. [RegExr](https://regexr.com/) helped.
2. Write the regular expressions into a TextMate grammar (`.tmLanguage`) file.
3. [Create the VS Code extension](https://code.visualstudio.com/api/language-extensions/syntax-highlight-guide) using the grammar.
4. Set colors for syntax highlighting in VS Code's `settings.json`.

And here details on how I did #2 and #4. First the TextMate grammar, which includes a few changes and extras (see the update below).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>fileTypes</key>
  <array>
  <string>txt</string>
  </array>
  <key>keyEquivalent</key>
  <string>^~T</string>
  <key>name</key>
  <string>todo.txt</string>
  <key>patterns</key>
  <array>
  <dict>
    <key>match</key>
    <string>\B\@\w+</string>
    <key>name</key>
    <string>constant.language.tag.todotxt</string>
  </dict>
  <dict>
    <key>match</key>
    <string> #20\d\d-\d\d-\d\d</string>
    <key>name</key>
    <string>constant.language.date.todotxt</string>
  </dict>
  <dict>
    <key>match</key>
    <string>https?:\/\/.*?(?= |\)|$)</string>
    <key>name</key>
    <string>constant.language.url.todotxt</string>
  </dict>
  <dict>
    <key>match</key>
    <string>^##.*$</string>
    <key>name</key>
    <string>constant.language.datehead.todotxt</string>
  </dict>
  <dict>
    <key>match</key>
    <string>^\s*>.*$</string>
    <key>name</key>
    <string>constant.language.subentry.todotxt</string>
  </dict>
  <dict>
    <key>match</key>
    <string>^\s*`.*?(?= @| #20| §| https?:\/\/| «|$)</string>
    <key>name</key>
    <string>constant.language.waiting.todotxt</string>
  </dict>
  <dict>
    <key>match</key>
    <string>(^\s*(\^.*?|\d[\d: ]{0,5}[ap]m.*?)|†.*?)(?= @| #20| »| https?:\/\/| «|$)</string>
    <key>name</key>
    <string>constant.language.urgent.todotxt</string>
  </dict>
  <dict>
    <key>match</key>
    <string>§.*?(?= @| #20| https?:\/\/| «|$)</string>
    <key>name</key>
    <string>constant.language.annotation.todotxt</string>
  </dict>
  <dict>
    <key>begin</key>
    <string>«</string>
    <key>end</key>
    <string>»</string>
    <key>name</key>
    <string>constant.language.quote.todotxt</string>
  </dict>
  </array>
  <key>scopeName</key>
  <string>text.todotxt</string>
  <key>uuid</key>
  <string>B68B5C70-7D5A-11E0-A411-0800200C9A66</string>
</dict>
</plist>
```

And then the colors in `settings.json`:

```json
{
  "[todotxt]": {
    "editor.quickSuggestions": false
  },
  "editor.tokenColorCustomizations": {
    "textMateRules": [
      {
        "scope": "constant.language.quote.todotxt",
        "settings": {
          "foreground": "#A3A352"
        }
      },
      {
        "scope": "constant.language.annotation.todotxt",
        "settings": {
          "foreground": "#4aff40"
        }
      },
      {
        "scope": "constant.language.urgent.todotxt",
        "settings": {
          "foreground": "#F38D8D"
        }
      },
      {
        "scope": "constant.language.waiting.todotxt",
        "settings": {
          "foreground": "#F3ED72"
        }
      },
      {
        "scope": "constant.language.datehead.todotxt",
        "settings": {
          "foreground": "#00FFFF",
          "fontStyle": "bold underline"
        }
      },
      {
        "scope": "constant.language.subentry.todotxt",
        "settings": {
          "foreground": "#9E9E9E"
        }
      },
      {
        "scope": "constant.language.url.todotxt",
        "settings": {
          "foreground": "#C583FA"
        }
      },
      {
        "scope": "constant.language.date.todotxt",
        "settings": {
          "foreground": "#9E9E9E"
        }
      },
      {
        "scope": "constant.language.tag.todotxt",
        "settings": {
          "foreground": "#6CB6FF"
        }
      },
      {
        "scope": "text.todotxt",
        "settings": {
          "foreground": "#DBDBDB"
        }
      }
    ]
  }
}
```

## Recurring tasks via a script

Here's my `recur.lua` script, which I've set up in my task scheduler to run at the beginning of every day.

Whenever I need to add or change a recurring task, I simply open up the script and add a line.

```lua
-- script to add daily or weekly recurring tasks to the top of todo.txt
-- also automatically adds a header for today's date above yesterday

newTasks = ""

function add (line)
    newTasks = newTasks..line.."\n"
end

-- DAILY RECURRING TASKS
add("^ frontend course @devstudy")

-- WEEKLY RECURRING TASKS
weekday = os.date("%A")
if weekday == "Monday" then
    add("1pm meeting @work")
elseif weekday == "Sunday" then
    add("* call parents @family")
    add("7pm dnd w/ the Brocks")
end

-- MONTHLY RECURRING TASKS
day = os.date("%d")
if day == "25" then
    add("- monthly budget")
end

-- ADD TODAY'S DATE HEADER AND NEW TASKS
today = "## "..os.date("%Y-%m-%d").."\n\n"
todo = io.open("todo.txt", "r")
todoStr = todo:read("*all")
yesterdayPos = todoStr:find("##20")
todoStr = newTasks..todoStr:sub(1,yesterdayPos-1)..today..todoStr:sub(yesterdayPos)
todo = io.open("todo.txt", "w+")
todo:write(todoStr)
todo:close()
```

So there you have it. If you ever find yourself face to face with a monster crisis born of your disorganization, now you can set up your own customized `todo.txt` and give that monster (now overwhelmed by your organizing prowess) an existential crisis of its own. *Pow*, take that!

## UPDATE: August 6, two months in

By now I've tweaked my todo.txt markup characters, reflected in the XML and JSON above: `^` (not `*`) for an urgent task, `†` for an urgent note at the end of a line, `«` and `»` (not `{` and `}`) for quotes, `§` for retrospective comments in green, and `#` for a date stamp at the end of a line. (Choose other characters or strings if you'd like; I can type those weird ones with [my keyboard layout](https://medium.com/@tbeers/the-alt-latin-keyboard-layout-windows-version-701c64f8bfd8).)

Why a date stamp at the end of a line, you ask? Well, there's been a fascinating shift in how I use my todo.txt: I still use it as a to-do list just as much as I did in the beginning, but at the same time its function *as a journal* has grown tremendously. By now I'm not popping done tasks down below, as if the previous days are a "done" list; no, I've realized that that I don't care what errands I ran or who I wrote back to on such-and-such day. So, very few of my to-do tasks make it down to the record of previous days. Instead, I use the previous days as a journal, writing down memorable things that happen each day.

That may sound trivial, but think about it: more than just organizing tasks, I am now organizing and bringing order to my experiences more broadly. *Tagging* is what makes all the difference: rather than becoming an impenetrable mass of random jottings (like other journals I've kept in the past), this journal is carefully tagged so that each entry is part of an ongoing thread: `@reading`, `@devstudy`, `@hardday`, `@dnd`, and others. For each entry that I tag, I stamp today's date at the end of it (simply <kbd>Ctrl</kbd> +<kbd>Alt</kbd> + <kbd>D</kbd>, thanks to an AutoHotkey script), and then later I can use [Filter Lines](https://marketplace.visualstudio.com/items?itemName=earshinov.filter-lines) or any other grep-like extension for VS Code to show only lines with a particular tag, each one with a date attached.

So now it's easy to see all my reading notes together, or to look back at all my hard days and feel relieved that most of them are insignificant in hindsight. My wife and I are now going through a tough time where we've just lost a baby due to miscarriage. Years from now I can pull up all the `@baby` lines and read that story again, along with (hopefully!) its happier sequel in which we really do have a baby.

More than just a task manager, I feel like my todo.txt has given me superpowers for living a more self-examined life as I more purposefully weave the threads that add richness and meaning to my life.
