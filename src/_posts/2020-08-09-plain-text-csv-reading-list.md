---
title: Track your reading with read.csv
subtitle: and become a deeper reader
description: To track your reading you don't need to sell your soul to Goodreads. You can do it just as conveniently in a plain text file!
---

- [The end result](#the-end-result)
- [1. Download your Goodreads data](#1-download-your-goodreads-data)
- [2. Get the Rainbow CSV extension for VS Code](#2-get-the-rainbow-csv-extension-for-vs-code)
- [3. Make a hotkey to create new entries](#3-make-a-hotkey-to-create-new-entries)
- [Caveats and limitations](#caveats-and-limitations)
- [Other possibilities](#other-possibilities)

Ever since I started organizing my tasks and journaling with [a custom todo.txt](/posts/2020/todotxt.html), I've been looking for other cluttered parts of my life to simplify. **My reading** is one of those.

I love reading, but I've always had trouble keeping track of my reading. In particular, a single to-read list and a single place for reading notes are, I think, essential for deep and reflective reading. But I've always failed at these. Every few years I got fed up with my uselessly scattered hodgepodge of reading lists, and so I went through them all and made a sleek new list… only to see it degenerate into the same old chaos within a few months. I often took notes on what I read, somewhere, but… *dagnabbit, where did I put those notes?* I always lost them, or stopped taking notes because they weren't within easy reach.

Even the basic task of keeping track of what I read hasn't been straightforward. For a few years I've been using Goodreads, but it has a few problems. It's hard to track your reading of rare or old books with Goodreads, because you probably have to add them to the catalog yourself. Its main draw is that it's also a social network, but I can only remember *one time* that I ever interacted with a friend on there. With every passing year it looks more and more like a graveyard, and [complaints](https://onezero.medium.com/almost-everything-about-goodreads-is-broken-662e424244d5) by its [users](https://theliteraryphoenix.com/2020/02/11/goodreads-frustations/) have been [getting louder](https://bookriot.com/future-of-goodreads/). The most useful part of the site is the massive number of book reviews by users, but you don't need a Goodreads account to look at reviews. As for the other social book sites, they're not (as far as I can tell, as of 2020) any better than Goodreads.

So I've finally abandoned Goodreads, and now (as we speak!) I am basking in the glory of a unified approach to keeping track of my reading, my to-read list, *and* my reading notes. One list, hundreds of lines, zero headache. Here we go.

## The end result

We'll get into how to set it up, but here is a bit of my read.csv, where each column is distinguished by a color:

![read.csv plain text reading list](/images/readcsv-comments.png)

So now I can pull up my list quicker than going into an app, *and* I can write notes that won't get lost, *and* I can easily organize my to-read lists as well: the "currently reading" section above is followed by some short high-priority "will read" lists, followed by a long "done reading" list, followed by a bunch of low-priority "maybe will read" lists.

*Wow, that format looks cumbersome,* you might be saying with snicker. *Writing out nine columns every time you want to jot down an interesting title??* No, because I can jot them down as a comment (starting with `\` or any other character of your choosing), and then later use a custom AutoHotkey script to convert it to an entry, leaving only the "Bookshelves" column to fill in manually:

![read.csv plain text reading list shortcut](/images/readcsv-add.gif)

If it's an audiobook, I also add an audio symbol—just a few keystrokes, thanks to a [text expander](https://beeftext.org/).

That last line, like many of my to-reads, is already CSV-formatted because it was exported from my Goodreads "Want to Read" shelf. (In that case, the "Date Started" column is "Date Added" from Goodreads.)

But the best thing about my read.csv is not just that it's quick or pleasant to use. **It's actually changing the way I read for the better:** having my notes always in view motivates me to take notes. And not just on my reading. I've begun to track courses, podcasts, and documentaries in there too—any educational or reflective media consumption that I feel is worth writing down.

If you want to try it yourself, here's how.

## 1. Download your Goodreads data

If you're on Goodreads, the first thing you need to do is [export your library](https://help.goodreads.com/s/article/How-do-I-import-or-export-my-books-1553870934590). This will give you a CSV file. Open it up and delete all the columns you don't need.

If you're not on Goodreads, simply create a blank CSV file. Onward!

## 2. Get the Rainbow CSV extension for VS Code

You *could* manage your reading list in Excel or another spreadsheet app, but then you lose the advantages of working in plain text with a good text editor. For me that's [VS Code](https://code.visualstudio.com/), so I poked around and found the [Rainbow CSV extension](https://marketplace.visualstudio.com/items?itemName=mechatroner.rainbow-csv), which provides three key functions for our list:

* Highlights each column in a different color
* Multi-cursor selection and editing of columns
* Filter and sort data with SQL-like queries

For quicker sorting by a particular column (with a hotkey instead of a query), I'm using the [Stable Sort extension](https://marketplace.visualstudio.com/items?itemName=sgryjp.vscode-stable-sort).

For a hotkey to select a title (i.e. everything between the nearest semicolons) I'm using the [Select By extension](https://marketplace.visualstudio.com/items?itemName=rioj7.select-by).

I also added the following lines to VS Code's `settings.json`. (Adjust the font size to your liking.)

```json
"[csv (semicolon)]": {
    "editor.quickSuggestions": false,
    "editor.wrappingIndent": "deepIndent",
    "editor.fontSize": 16
}
```

## 3. Make a hotkey to create new entries

Typing out nine columns for every entry is a pain, so instead I made an [AutoHotkey](https://www.autohotkey.com/) script that takes the current line and turns it into an entry, with today's date as Date Started. If the line has a comment character at the beginning, it automatically disappears. If I already added the ISBN after the title (after a semicolon), then it fills the ISBN column in the new entry. Here's the script, assigned to the keyboard shortcut <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>R</kbd>:

```cpp
^+r::
    oCB := ClipboardAll
    Clipboard := ""
    Send ^x
    Sleep,50
    beforeText = curr`; `;
    afterText = `; `;`#%A_YYYY%-%A_MM%-%A_DD%`;`;1
    Clipboard := beforeText . Trim(Clipboard, "`r`n\ ") . (InStr(Clipboard, "`;") ? "" : "`; ") . afterText . "`r`n"
    Send ^v
    Sleep,50
    Clipboard := oCB
    Send {Left 3}
    Sleep,50
    Send {Ctrl Up}{Shift Up}
Return
```

For adding the Date Finished, I have another shortcut, <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd>:

```cpp
^+d::
    SendInput {#}%A_YYYY%-%A_MM%-%A_DD%
return
```

## Caveats and limitations

Some things to watch out for:

1. Every column in every row has to have a value, even if it's just a space, otherwise Rainbow CSV throws a fit when selecting that entire column. That's why all incomplete rows (like jotted-down notes) have to be commented out.
2. Quote marks surrounding a column are also a no-go. That's why I'm using semicolons as separators instead of commas, so that I don't have to quote every column containing a comma. That means that I can't use semicolons in my notes, but… eh, who needs 'em anyway.
3. Entries can't span multiple lines, and that means I have to write out my notes on a single line. But for me that's an acceptable tradeoff for being able to keep my notes always in view.
4. Multi-column editing is simplest on columns with a consistent format (in terms of number of words), so I'm using only single words in the "Bookshelves" column: `rubyrails`, `dramapoetry`, and `econpolitics`, for example.

## Other possibilities

I don't do these things with my read.csv, but you might want to:

- If you want to include your Kindle notes and highlights in your read.csv, you can [export them as plain text](https://medium.com/@michelle_z./how-to-export-kindle-highlights-notes-for-free-63181bca6df8), replace line breaks with some other separator (see caveat #3 above), and then paste them into your notes column in read.csv. But if you have a lot of notes and highlights, prepare for a lot of clutter.
- If you want to bring in an element of social sharing, you can store your read.csv on Dropbox and [use the Dropbox JavaScript API](https://www.google.com/search?q=dropbox+javascript+api+read+text+file) to display all or some lines from the file in a webpage. I store mine in Dropbox, but mainly so that I can edit it on the go with the [Simple Text](https://play.google.com/store/apps/details?id=simple.text.dropbox) app. I'm not making my read.csv publicly viewable because my reading notes are for my own reflection, not for the world to see, but at some point I'll think of a better way to share my reading journey using read.csv.
  - *UPDATE, July 2021: I'm now sharing my favorite reads on [the new "Reading" page](/reading) of my website, which is powered by a Ruby gem that parses my CSV reading list.*

I'm sure you could add on to this list. With plain text, the possibilities are endless.
