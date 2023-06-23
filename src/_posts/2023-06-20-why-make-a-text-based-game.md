---
title: Building a text-based game
subtitle: convincing myself it's not a dumb idea
description: The text-based game is old. But could it have unique potential for interactive fiction set in an open-world sandbox RPG?
---

- [Answering my inner critic](#answering-my-inner-critic)
- [Text-based games, old and new](#text-based-games-old-and-new)
- [… and why they're not what I have in mind](#-and-why-theyre-not-what-i-have-in-mind)
- [So what game *do* I want to make?](#so-what-game-do-i-want-to-make)
- [My inner critic's last assault, and my "why"](#my-inner-critics-last-assault-and-my-why)
- [Conclusion: have I convinced myself?](#conclusion-have-i-convinced-myself)
- [Appendix: writing interactive fiction in Ruby](#appendix-writing-interactive-fiction-in-ruby)

I've been mulling over ideas for my next hobby project, now that I'm almost done making my [CSV reading log parser](https://github.com/fpsvogel/reading).

I've decided on *(drumroll…)* **a text-based game!**

*What, **seriously?** Isn't that the quintessential **newbie project** for first-time coders? That's **so** beneath you.*

That's what the critical voice in my head keeps saying. So in this post I'll try to convince myself that making a text-based game is not, in fact, a dumb idea.

## Answering my inner critic

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

**The problem** with me making a graphical game is **sprites and other assets**: making them or even mixing-and-matching premade assets would be **tedious**. I *could* make an arcade-like action game that avoids sprites, maybe something along the lines of my childhood favorite [*Gravity Well*](https://youtu.be/GZIeLXlqefE?t=1636). But that would involve fairly complex geometry and physics, which are also high on my *"don't want to deal with it"* list.

In a text-based game, these headaches would be out of the picture (because *there is no picture*, heh). And later on if I choose to add graphical features and/or I want to distribute the game more widely, I can easily move it into DragonRuby. In the meantime **I'll simply output text to the terminal**, just like it was done in the early days.

Speaking of which, what *are* text-based games anyway?

## Text-based games, old and new

For the sake of simplicity, under this one heading of "text-based games" I'm lumping together various terms denoting different overlapping genres:

- **Text adventures** began in the 1970s and are generally parser-based, meaning that the player types commands like `north` or `examine sign`. Text adventures commonly feature puzzles, and they may or may not have a strong story element. This type of game is still made today by enthusiasts, though now the focus is usually on *story* more than puzzles, and the term *interactive fiction* is now more common (see below).
- [**MUDs**](https://en.wikipedia.org/wiki/Multi-user_dungeon) are the multiplayer counterpart to text adventures, similar to modern MMORPGs but with text and a parser instead of graphics. MUDs are not nearly as popular as they once were, due of course to modern MMORPGs.
- **Interactive fiction** is the term most widely used today for text-based games. It's also the broadest term, including not only parser-based games but also a more recent form that uses *hypertext* instead of a parser, where the narrative is made non-linear by links interspersed within the text, or after each section of text (as in *Choose Your Own Adventure* books). This *hypertext* or *choice-based* interactive fiction often feels less like playing a game, and more like reading a short story or poem.

I'm not including [roguelikes](https://en.wikipedia.org/wiki/Roguelike) under this umbrella because they are essentially graphical, even if the graphics consist of ASCII characters.

## … and why they're not what I have in mind

I want to make something *outside these established genres*. I really like *the idea* of interactive fiction, but I wouldn't enjoy writing one. It's also not my favorite medium to play/read.

But I've only ever tried a few of them, so recently I made a renewed effort to explore interactive fiction and *appreciate it* as much as I could. Here are my impressions, along with some examples.

I like that **parser-based interactive fiction** feels more game-like on the whole, with its clear concept of spaces to be explored. It can be hard for a newcomer to learn, but that's not a problem if a good tutorial is included ([*Counterfeit Monkey*](https://ifdb.org/viewgame?id=aearuuxv83plclpl)) or if the commands are intuitive based on context ([*FeedVid Live*](https://varunramesh.itch.io/feedvid-live)).

**Hypertext interactive fiction** has a simpler UI (just links) but is also more varied, covering the entire spectrum from conventional game mechanics ([*Seedship*](https://philome.la/johnayliff/seedship/play/index.html)) to avant-garde storytelling ([*Orifice Clique*](https://xrafstar.monster/games/twine/clique/)), from hilarious ([*You Will Select a Decision*](https://selectadecision.info/)) to heartbreaking ([*Hana Feels*](http://hanafeels.com/)).

**Commercial interactive fiction** has made a comeback in the past ten years or so ([*Sorcery!*](https://www.inklestudios.com/sorcery), [*Roadwarden*](https://moralanxietystudio.com/roadwarden)). And some story-heavy RPGs are reminiscent of interactive fiction ([*Disco Elysium*](https://discoelysium.com/), [*Wildermyth*](https://wildermyth.com/)).

So I was able to better appreciate interactive fiction this time around, but I still didn't come across any interactive fiction like the game I want to make.

## So what game *do* I want to make?

I'll start by pointing to a few inspiring games that I want mine to be like *in spirit*, even if these are in other genres and more graphical than what I'm aiming for.

- [***Dwarf Fortress***](http://www.bay12games.com/dwarves/) because it offers nearly limitless creative possibilities in the quest for survival (as well as lots of ways to die). I'm also impressed by the procedural world generation and the insane level of detail in the world simulation, which [makes some of the game's bugs pretty entertaining to read about](https://www.theguardian.com/games/2022/nov/16/unexpected-nudity-and-vomit-covered-cats-how-dwarf-fortress-tells-some-of-gamings-most-bizarre-stories).
- [***Upheaval***](https://leonegaming.itch.io/upheaval) is an in-progress "text-based fantasy roleplaying adventure sandbox", basically a big world with a non-linear story presented just through text menus. It's something like the blend that I'm going for, though a bit more narrative-driven (so much that maybe it belongs with the interactive fiction examples above). Here's [a glimpse at the gameplay](https://www.youtube.com/watch?v=KFmaZTMceRU), and [a complete playthrough](https://www.youtube.com/watch?v=hXACGyWFVy8).
- [***Warsim: The Realm of Aslona***](https://www.gog.com/en/game/warsim_the_realm_of_aslona) is another charming game that gives the feeling of vastness even though it too consists entirely of text menus.
- [***Kenshi***](https://store.steampowered.com/app/233860/Kenshi) is graphical but it's otherwise similar to the sandbox survival aspect that I have in mind. Some other open-world games (*Elder Scrolls*, *Mount and Blade*) are closer *thematically* to what I'm aiming for, but they emphasize *combat* to the exclusion of much else, and their worlds are not as dynamic.

So I suppose I want to make a text-based game that **incorporates interactive fiction** (more on this below), but **is essentially a sandbox RPG** set in an open world that continues to evolve over time, a sort of world simulation where pretty much **anything can happen.** Towns can be founded and wiped out by floods, animals can spread disease and be hunted to extinction, a drought can cause famine and malnutrition, the nobility can intermarry, discontented peasants can rise up in revolt.

What makes these goals anything *close* to attainable in my (probably deluded) mind is what I've already said: **there will be no graphics** or other assets to worry about, just text. Also, certain things will be simpler because **the world will be defined in physically low resolution**, i.e. the world won't exist as a grid of small spaces like in Dwarf Fortress, but instead will be composed of various large areas or regions. (For example, a town could be one area, the region surrounding the town another area, and the mountains beyond it yet another area.) This means **I won't have to implement small-scale physics** like in Dwarf Fortress, **or procedural world generation** since it'll be easy enough to handcraft a world map as a setting for a story, as long as the game fills in smaller gaps like wildlife and minor locations, so that only the world's overall shape and important details need to be defined by a story's author.

But hold on, **how can interactive fiction fit with an open-world sandbox?** Wouldn't a story grind to a halt if one of its key people or places were destroyed? Well, yes–remember, anything can happen! So stories will have to provide some minimum of contingency plans in case of mishap, and getting stuck through bad luck will always be a possibility.

## My inner critic's last assault, and my "why"

<!-- omit in toc -->
### 😤 *Sigh.* "Let me try one last time. This game is doomed to be a boring, elaborate mess. No graphics, not even backdrops or ASCII art?? Getting stuck through sheer bad luck?! Nobody will play it. Why waste your time?"

I fully expect no one will play my game. Heck, ***I myself*** probably won't play my game much. *But that's the beauty of it!* Because the goal of this project isn't to produce a popular game with wide appeal. No, I'm doing it for the fun and challenge of embodying this whacky mashup of ideas, and tweaking those ideas to my own satisfaction. **For me the real game is in making the game.** (So *meta*, right??)

## Conclusion: have I convinced myself?

Yes! I've got to say, though, that last self-criticism hit me hard, because I often slip into being a perfectionist and demanding that everything I make be *great* and *impressive*, otherwise it's not worth doing. So it really goes against the grain for me to make something **knowing it will probably be lame in the end**, but making it anyway just to enjoy the creative process.

See? I've already learned and grown from this project, and I haven't even begun yet!

And now that I've acknowledged its fate, I feel relieved of the pressure to make it into a game that other people will love. I don't have to bow to anyone's expectations. This feels… spacious.*

## Appendix: writing interactive fiction in Ruby

If I were going to write traditional interactive fiction, there are [many commonly-used authoring tools I could choose from](https://emshort.blog/how-to-play/writing-if/). But I love Ruby, so I might have chosen one of these instead:

- [**Gamefic**](https://github.com/castwide/gamefic) for parser-based interactive fiction. It can [build games for the Web](https://github.com/castwide/gamefic-sdk#making-games-for-the-web). Here's [an example story's code](https://github.com/castwide/gamefic-sdk/blob/master/examples/cloak_of_darkness/main.rb) and [its explanation](https://github.com/castwide/gamefic-sdk/blob/master/examples/cloak_of_darkness/Cloak_of_Darkness.md).
- [**ScottKit**](https://github.com/MikeTaylor/scottkit) for '80s-style text adventures. It has a nice DSL (see [the tutorial](https://github.com/MikeTaylor/scottkit/blob/master/docs/tutorial.md)).
- [**Ruby Mud**](https://github.com/RickCarlino/mud) for building MUDs.
- [**AresMUSH**](https://www.aresmush.com) ([GitHub](https://github.com/AresMUSH/aresmush)) also for building MUDs, but in a more pre-built and opinionated way. Compare to [Evennia](https://www.evennia.com/) in Python.

<br>

\* <small>The muffled voice of the critic interjects again, questioning my sanity for wanting to spend untold hours making just another one of those GitHub repos that you stumble upon, only to scratch your head in confusion and close the tab within three seconds. However, these protestations are in vain, being henceforth banished to footnotes.</small>
