---
title: Building a text-based game
subtitle: exploring an old genre for new purposes
description: Could this classic (but still kicking!) genre embody interactive fiction set in an open-world sandbox RPG? A deep dive into the kinds of text-based games.
updated: 2024-05-01
---

- [What *are* text-based games?](#what-are-text-based-games)
- [Trying out the sub-genres](#trying-out-the-sub-genres)
- [So what game *do* I want to make?](#so-what-game-do-i-want-to-make)
- [Appendix A: writing text-based games in Ruby](#appendix-a-writing-text-based-games-in-ruby)
- [Appendix B: Answering my inner critic](#appendix-b-answering-my-inner-critic)

*UPDATE: To see the beginnings of the actual project that I envision here, see my follow-up post [Building a text-based game in Ruby, part 1](/posts/2023/ruby-text-based-game-real-time-input)*.

I've been mulling over ideas for my next hobby project, now that I'm almost done making my [CSV reading log parser](https://github.com/fpsvogel/reading).

I've decided on *(drumroll…)* **a text-based game!**

*What, **seriously?** Isn't that the quintessential **newbie project** for first-time coders?*

That's what the critical voice in my head keeps saying. So in this post I'll dive into the rich and intriguing world of text-based games to convince myself that making one is not, in fact, a dumb idea. In [an appendix below](#appendix-b-answering-my-inner-critic) I've more directly answered my inner critic and its suggestions of more "serious" projects.

## What *are* text-based games?

For the sake of simplicity, under this one heading of "text-based games" I'm lumping together various overlapping sub-genres, including these:

- **Interactive fiction** (hereafter "IF") is the most popular type of text-based game today, with a lively community centered around annual competitions (e.g. [IFComp](https://ifcomp.org/), [XYZZY Awards](https://xyzzyawards.org/)), the [IF Community Forum](https://intfiction.org/), and [IFDB](https://ifdb.org/), just to name a few places. IF is an amalgamation of different forms, such as:
  - **Parser-based** IF, in which the player types commands like `north` or `examine sign`.
  - **Hypertext** IF, which is a branching narrative navigated via links interspersed within the text. Hypertext IF often feels less like playing a game, and more like reading a short story or poem.
  - **Choice-based** IF is a kind of hypertext IF in which narrative branches are shown at the end of text nodes, just like in the old *Choose Your Own Adventure* books.
- **Text adventures** are an older name for parser-based IF. Puzzles were a bigger element than in contemporary parser-based IF, where story more often takes center stage.
- [**MUDs**](https://en.wikipedia.org/wiki/Multi-user_dungeon) are essentially MMORPGs but with text and a parser instead of graphics. In fact, MMORPGs are the direct successor to MUDs, and pretty much replaced them.
- **Procedural text-based games** have little or no authored story, but are more replayable. [Roguelikes](https://en.wikipedia.org/wiki/Roguelike) are a well-known example, though they're arguably graphical rather than text-based.

## Trying out the sub-genres

Until recently, I'd only ever tried a few IF titles, so now I'm making a renewed effort to explore IF and *appreciate it* as much as I can. Here are my impressions, along with some examples.

**Parser-based IF** feels more game-like on the whole, with its clear concept of spaces to be explored. It can be hard for a newcomer to learn, but that's not a problem if a good tutorial is included ([*Blue Lacuna*](https://ifdb.org/viewgame?id=ez2mcyx4zi98qlkh), [*The Dreamhold*](https://eblong.com/zarf/if.html#dreamhold), [*Counterfeit Monkey*](https://ifdb.org/viewgame?id=aearuuxv83plclpl)) or if the commands are very intuitive based on context ([*FeedVid Live*](https://varunramesh.itch.io/feedvid-live)).

**Hypertext and choice-based IF** have a simpler UI (just links) but are extremely varied thematically, covering the spectrum from popular fiction ([*A Tale of Crowns*](https://qeresi.itch.io/a-tale-of-crowns)) to avant-garde (many of [Porpentine's games](https://xrafstar.monster/games/)), from comical ([*You Will Select a Decision*](https://selectadecision.info/)) to touching [*Digital: A Love Story*](https://scoutshonour.com/digital/) to heartbreaking ([*Hana Feels*](http://hanafeels.com/)).

**MUDs** are… hard to get into. They seem to have evolved less over the decades than the other sub-genres I'm exploring. Which is great if you got into MUDs in the 1980s, but to me (*a tired 30-something new parent in the 2020s*) it's too much of a time commitment to learn how to enjoy MUDs. So I'll leave it at that.

**Procedural text-based games** are easier fun, being more like graphical games than IF is, and (classic roguelikes aside) being simpler than MUDs. Common settings include medieval fantasy (most roguelikes, [Warsim](https://store.steampowered.com/app/659540/Warsim_The_Realm_of_Aslona/)) and space exploration ([*Seedship*](https://johnayliff.itch.io/seedship), [*Voyageur*](https://brunodias.itch.io/voyageur)).

As an aside, **commercial IF** has seen an uptick in the past ten or fifteen years from studios such as [A Sharp](https://store.steampowered.com/curator/37604253-A-Sharp), [Choice of Games](https://www.choiceofgames.com), [inkle](https://www.inklestudios.com/), and [Failbetter Games](https://www.failbettergames.com/games), as well as solo creators.

For the most part, I was able to better appreciate text-based games this time around. Still, I didn't come across any that are quite like the game I want to make.

## So what game *do* I want to make?

Essentially, a game with more world simulation than what is typical in contemporary interactive fiction.

I'll start by pointing to a few inspiring games that I want mine to be like *in spirit*, even if some of these are more graphical than what I'm aiming for.

- [***Dwarf Fortress***](http://www.bay12games.com/dwarves/) because it offers nearly limitless creative possibilities in the quest for survival (as well as lots of ways to die). I'm also impressed by the procedural world generation and the insane level of detail in the world simulation, which [makes some of the game's bugs pretty entertaining to read about](https://www.theguardian.com/games/2022/nov/16/unexpected-nudity-and-vomit-covered-cats-how-dwarf-fortress-tells-some-of-gamings-most-bizarre-stories).
- [***Kenshi***](https://store.steampowered.com/app/233860/Kenshi) is graphical but it's otherwise similar to the sandbox survival aspect that I have in mind. Some other open-world games (*Elder Scrolls*, *Mount and Blade*) are closer *thematically* to what I'm aiming for, but they emphasize *combat* to the exclusion of much else, and their worlds are not as changeable or sandbox-like.
- [***Upheaval***](https://leonegaming.itch.io/upheaval) is an in-progress "text-based fantasy roleplaying adventure sandbox", basically a big world with a non-linear story presented just through text menus. It's something like the blend that I'm going for, though it's a bit more narrative-driven. (It probably belongs with the interactive fiction examples above.) Here's [a glimpse at the gameplay](https://www.youtube.com/watch?v=KFmaZTMceRU), and [a complete playthrough](https://www.youtube.com/watch?v=hXACGyWFVy8).
- [***The Hobbit***](https://en.wikipedia.org/wiki/The_Hobbit_(1982_video_game)) is a 1982 text adventure that I discovered in the book [*50 Years of Text Games*](https://aareed.itch.io/50-years-of-text-games). *The Hobbit* is an attempt at an authored story within a simulation, similar to what I'm aiming for. The results can be… surprising. Players have gone off script by killing Smaug using Gollum's corpse, or by picking up Elrond and carrying him around for a free and inexhaustible supply of Elven lunches. NPCs can also act unpredictably: Gandalf is liable to go off and get killed somewhere, and Bard the Bowman, upon the player's asking him to slay Smaug, might just say "No" before being promptly roasted by the dragon. In the words of the game's main creator, Veronika Megler: *"I was really aiming for something like life where the outcome is the result of many independent occurrences and decisions by many people, and sometimes things just don't work out. […] I actively wanted the unpredictability."* *The Hobbit* was unique, and it still is as far as I can tell. Other text-based games—heck, other games of *any sort* that have an authored narrative—just don't have this level of freedom, where the world plays out haphazardly and chaotic events might completely tank the storyline. There have been only a handful of similar attempts, all of them ill-fated:
  - Carnegie-Mellon's 1990s [Oz Project](https://www.cs.cmu.edu/afs/cs/project/oz/web/oz.html) produced only a small experiment called [*The Playground*](https://if50.substack.com/p/1994-the-playground) before being disbanded.
  - [*Façade*](https://en.wikipedia.org/wiki/Façade_(video_game)) (2005) was another experiment, whose developers (not coincidentally) included a graduate of Carnegie-Mellon who had been involved with the Oz Project. A full-length follow-up called *The Party* was planned, but it never got off the ground.
  - The [Versu](https://versu.com) engine (2014) was a "character AI for interactive stories" that was abandoned before its release.

So, to put it more directly, I want to make a text-based game that is **a detailed world simulation** in which **an authored story takes place** (more on that below). I might borrow elements from other genres, such as real-time play like in MUDs, the gritty freedom of a survival sandbox RPG, and an alternative to parser-based input [explored by Emily Short](https://emshort.blog/2010/06/07/so-do-we-need-this-parser-thing-anyway/).

But the game's essence is the setting: an open world that evolves over time, where pretty much **anything can happen.** Towns can be founded and wiped out by floods, animals can spread disease and be hunted to extinction, a drought can cause famine and malnutrition, the nobility can intermarry, discontented peasants can rise up in revolt.

What makes these world-simulating ambitions anything *close* to attainable in my (probably deluded) mind is what I've already said: **there will be no graphics** or other assets to worry about, just text. Also, certain things will be simpler because **the world will be defined in physically low resolution**, i.e. the world won't exist as a grid of small spaces like in Dwarf Fortress, but instead will be composed of various large areas or regions. (For example, a town could be one area, the region surrounding the town another area, and the mountains to the east yet another area.) This means I won't have to implement as much small-scale physics à la Dwarf Fortress. Even procedural generation will be limited, since it'll be easy enough to handcraft a world map as a setting for a story. The game can fill in the gaps like wildlife and minor locations, so that only the world's overall shape and important details need to be defined by a story's author.

Returning to the other half of the equation, **how can an authored story happen in an open-world sandbox?** Wouldn't a story grind to a halt if one of its key people or places were destroyed? Well, yes… remember, anything can happen! So stories will have to provide some minimum of contingency plans in case of mishap, so that the authored story has some level of interplay with the emergent narratives coming from the world simulation. Still, getting stuck through bad luck will always be a possibility. But maybe that's OK. The unofficial motto of Dwarf Fortress, *"losing is fun"*, reminds us that chaotic failures are not always a bad thing.

## Appendix A: writing text-based games in Ruby

If I were going to write traditional text-based games, there are [many commonly-used authoring tools I could choose from](https://emshort.blog/how-to-play/writing-if/). But I love Ruby, so I might have chosen one of these instead:

- [**Gamefic**](https://github.com/castwide/gamefic) *(active!)* for parser-based interactive fiction. It can [build games for the Web](https://github.com/castwide/gamefic-sdk#making-games-for-the-web). Here's [an example story's code](https://github.com/castwide/gamefic-sdk/blob/master/examples/cloak_of_darkness/main.rb) and [its explanation](https://github.com/castwide/gamefic-sdk/blob/master/examples/cloak_of_darkness/Cloak_of_Darkness.md).
- [**TAGF — Text Adventure Game Framework**](https://github.com/RoUS/rubygem-tagf) *(active!)* is a WIP project whose initial test case is to be able to reproduce Colossal Cave Adventure.
- [**ScottKit**](https://github.com/MikeTaylor/scottkit) for '80s-style text adventures. It has a nice DSL (see [the tutorial](https://github.com/MikeTaylor/scottkit/blob/master/docs/tutorial.md)).
- [**Tuvi**](https://github.com/jaywengrow/tuvi) is designed for kids but looks fun for adults too.
- [**Ruby Mud**](https://github.com/RickCarlino/mud) for building MUDs.
- [**AresMUSH**](https://www.aresmush.com) ([GitHub](https://github.com/AresMUSH/aresmush)) *(active!)* is also for building MUDS. Compare to [Evennia](https://www.evennia.com/) in Python.

## Appendix B: Answering my inner critic

<!-- omit in toc -->
### 🤨 "A *game*? Seriously? It's been *ten years* since you've done any gaming. Now you've just had your first baby. Isn't it time to move on?"

It's true, I used to be a gamer but then in college, life got busy with other things, and it's been that way ever since. It was a good change, and I wish it had come sooner.

And yes, I've just welcomed my first baby into the world 👶 He'll be his own person, of course, but I'll encourage him to cultivate other interests besides gaming (like I wish I'd done sooner).

Still, making a game has been **my dream since middle school.** I never did get around to it, first because of my teenage lack of discipline, and then by my choice in college to study the humanities rather than software development. Now that I've ended up as a developer after all, **why not go back to that dream?**

Don't get the wrong idea—all this about "my dream" sounds more grandiose and ambitious than it is. The reason I'm contemplating *a text-based game* is precisely *because* I've just had a baby, and whatever project I start next has to be **lightweight** and **easy to dip into** while the baby is asleep on my lap and *(tip for new parents!)* my hands are free thanks to the incredibly useful [Boppy pillow](https://www.boppy.com/search?type=product&q=original).

A text-based game sounds like the simple, restful project that I need right now.

<!-- omit in toc -->
### 💼 "You should really be making a Rails app, or a website, or some other useful thing. That would be best for your resume."

I already do Rails at my job, so a hobby Rails app would feel too much like work.

I really like [Bridgetown](https://www.bridgetownrb.com) (which I used to make this site), and [Scarpe](https://github.com/scarpe-team/scarpe) looks intriguing for desktop apps, but right now I don't have a compelling reason to make another site, or a desktop app.

<!-- omit in toc -->
### 🤖 "How about robotics? If you're set on doing something frivolous, that would be way cooler."

True, I could get a Raspberry Pi plus [this robot car kit](https://www.amazon.com/Freenove-Raspberry-Tracking-Avoidance-Ultrasonic/dp/B07YD2LT9D). Its [actions are written in Python](https://github.com/Freenove/Freenove_Robot_Dog_Kit_for_Raspberry_Pi), but I could write new actions in Ruby using the [Artoo](https://github.com/josephschito/artoo) Ruby robotics framework, or (at a lower level) [a Ruby port](https://github.com/ClockVapor/rpi_gpio) of the RPi.GPIO Python module. (I'm a big fan of Ruby, in case you haven't noticed.)

These robot shenanigans could be fun, and they might be inspiring to my kid when he's a bit older. But right now I'll pass, because **it's not a baby-friendly project.** My lack of robotics experience means it would be a big time investment, and the troubleshooting would be stressful. Plus, all the (literally) moving parts aren't conducive to being immobilized with a baby sleeping in my lap.

<!-- omit in toc -->
### 🎮 "Then at least make a game that's less lame than a text adventure! You've been wanting to try [DragonRuby Game Toolkit](https://dragonruby.itch.io/), right?"

Indeed I have, not least because DragonRuby has [a great community around it](https://discord.dragonruby.org).

**The problem** with me making a graphical game is **sprites and other assets**: making them (or even mixing-and-matching premade assets) would be **tedious**. I *could* make a game that uses geometrical shapes instead of sprites, maybe something along the lines of my childhood favorite [*Gravity Well*](https://youtu.be/GZIeLXlqefE?t=1636), or the perennially fascinating sand games (e.g. [Sandboxels](https://sandboxels.r74n.com/), [Powder Game](https://dan-ball.jp/en/javagame/dust/)), or simply a platformer that uses only rectangles ([Thomas Was Alone](https://store.steampowered.com/app/220780/Thomas_Was_Alone/) is the best-known [among many](https://itch.io/games/genre-platformer/tag-square)). But any of these may involve fairly complex geometry and physics, which are also high on my *"don't want to deal with it"* list.

In a text-based game, these headaches would be out of the picture (because *there is no picture*, heh). And later on if I choose to add graphical features and/or I want to distribute the game more widely, I can easily move it into DragonRuby. In the meantime **I'll simply output text to the terminal**, just like it was done in the early days.
