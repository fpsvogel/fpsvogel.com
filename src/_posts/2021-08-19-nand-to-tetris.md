---
title: Nand to Tetris
subtitle: computer science and lessons in optimization
description: Learning how to build a computer is not only fun, but also teaches important lessons in optimization that even software developers can take to heart.
---

- [Nand to Tetris: an intro](#nand-to-tetris-an-intro)
- [Optimizing output](#optimizing-output)
- [Optimizing runtime](#optimizing-runtime)
- [Conclusion: fun and usefulness combined](#conclusion-fun-and-usefulness-combined)

*"Should I spend time on computer science?"* The question inevitably comes up if (like me) you're learning programming on your own. I went with **yes**. To explain why, I'll talk about a course I've just finished, as an example of how computer science is fun *and* practical for the budding programmer.

## Nand to Tetris: an intro

*Nand to Tetris* is a hands-on course that teaches how to build a simple computer, including its operating system and a programming language. The course is completely free: [part 1](https://www.coursera.org/learn/build-a-computer), [part 2](https://www.coursera.org/learn/nand2tetris2). The textbook [The Elements of Computing Systems](https://mitpress.mit.edu/books/elements-computing-systems-second-edition) can come in handy as a reference, but it is not required. The course videos have all the same information and more. For some other handy links, see <a href="/reading#B084V7R8PT" data-turbo="false">my notes on the course</a>.

Although you could use *Nand to Tetris* as a primer or "CS101", I'm glad I had previously read [*Code: The Hidden Language of Computer Hardware and Software*](https://www.charlespetzold.com/code/), which introduces many of the same concepts in a more conversational way. For other CS books that I recommend, see the "Computer Science" subsection in [my study plan](https://github.com/fpsvogel/learn-ruby#expanding-my-horizons).

Why do I bother with these books and courses? After all, I'm planning on getting into web development, not systems programming. The hardware and OS are way below the layers where I'll be working.

I *could* list the usual justifications for CS in a programmer's curriculum: it's useful to know the machine, it improves your problem-solving skills, it builds character, it makes high-level programming more tolerable by comparison (just kidding… sort of). But there are two benefits of studying CS that aren't as often mentioned:

- Learning how a computer works is very satisfying.
- CS gives lots of opportunities for practicing optimization.

I can't elaborate much on the first point because your taste may differ, but let's talk more about the second point, optimization. I don't mean knowing how to use linked lists, binary trees, and so on, but the far more widely-applicable skill of finding out where your code is inefficient and then improving it.

## Optimizing output

Besides an exercise in building a simple computer, *Nand to Tetris* is a journey up a pyramid of abstractions of how to tell the computer what to do. It starts with the most concrete abstraction (logic gates) and ends with the most abstract (a high-level programming language), with several levels in between, such as assembly language and virtual machine code. In between each level of abstraction, you need to build some sort of translator to transform higher-level code into lower-level code: a compiler, a VM translator, an assembler.

As I wrote these translators, two kinds of optimization came up again and again: optimizing the *output* of a translator, and optimizing the *runtime* of the translator itself.

First, the output. It can easily become addictive to compare your output's line count to what others have achieved, trying to reach the same or even better efficiency. For example, at one point Professor Shimon Schocken shows his VM translator's output [in a course video](https://coursera.org/share/a39cdec23e6e913c04b8d2439ca59e6f) (starting at 18:07), and says that "It may well happen that your VM translator is better written than mine and therefore it may generate tighter assembly code."

Challenge accepted! By observing what assembly code shortcuts Professor Schocken used, and adding those to my own shortcuts, I reduced my outputted assembly file from 220 lines to 181 lines—that's 14 lines shorter than Professor Schocken's 🏆

Another example: if you enjoy gate logic, optimizing the ALU can be fun. [Here's a discussion with ideas on how to optimize the ALU.](https://www.coursera.org/learn/build-a-computer/discussions/weeks/2/threads/hJlyt3OcEeasOQpiYXGJHw) I did enjoy gate logic, but on that occasion I didn't spend extra time optimizing because my first attempt had a very respectable 607 NAND gates, and reducing that further would have required some arcane tricks that I didn't want to get into. But even at this low level there is plenty of room for extreme optimization, such as NAND-only implementations that reach down to [440 NANDs](http://nand2tetris-questions-and-answers-forum.52.s1.nabble.com/Why-we-like-abstraction-td1914023.html) or even [403 NANDs](http://nand2tetris-questions-and-answers-forum.52.s1.nabble.com/Low-NAND-ALU-td4031269.html) 🤯

## Optimizing runtime

You can also optimize the runtime efficiency of your translator programs. My assembler written in Ruby originally took 77 seconds to translate the Pong assembly program into machine code. It's 28,000 lines of assembly code, but still, 77 seconds is way too long.

I'd been itching to try out Crystal, so I made the few adjustments necessary to turn my Ruby code into Crystal, and… 46 seconds. That's faster, but not by an order of magnitude like I had hoped. (That doesn't mean Crystal isn't ever worthwhile, though, because in some cases [it does lead to dramatic improvements in performance](https://youtu.be/sTGfi98XXS4?t=592).)

So I went back to my Ruby code and optimized it. I discovered [ruby-prof](https://ruby-prof.github.io/) and used it to profile my code, i.e. to show me what methods were taking up the most time. Then I rewrote those parts of the script in a more efficient way, which ended up reducing the runtime down to 0.095 seconds. That's over 800 times faster. Not bad!

What changed? I used a number of optimizations, but the main problem was simple: in my original code, I was reading the whole 28,000-line file into a string, then applying a series of `String#map`s to the entire thing. Instead of doing it in one big chunk like this, it's much faster to process the file one line at a time. That way, I'm not unnecessarily looping through the file's contents over and over again. Right from the start I was pretty sure this is what the problem was, but still it was nice to have ruby-prof confirm my suspicion *before* I spent time optimizing the code. (And even back when I first wrote the code, I knew that throwing around a whole file in a string was slower, but my mistake was in assuming that it wouldn't be *that* much slower, and in believing the simpler code was worth the dip in speed.)

Lesson learned: what I *think* about my code's performance does not always match the reality, and using analysis tools like a profiler is the only way to see that reality and then make appropriate improvements.

## Conclusion: fun and usefulness combined

A lot of the fun of *Nand to Tetris* was precisely in this process of seeing where I could make my code more efficient. This is also obviously a useful skill to cultivate. It's true that there are lots of ways to practice optimization, not just in a CS course, but some CS courses offer an abundance of opportunities for sharpening these skills and (in my case) discovering tools for optimization that I will use for a long time to come.

So if you've ever looked at your computer and thought (with a tiny bit of guilt), *"Maybe I should know how this thing works,"* then try *Nand to Tetris*. You just might have a great time, and it won't be time wasted.
