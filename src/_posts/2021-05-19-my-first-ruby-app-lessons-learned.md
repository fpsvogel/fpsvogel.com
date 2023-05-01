---
title: My first Ruby app
subtitle: lessons learned
description: Writing my first Ruby app taught me a lot about automated testing, where to put code that's likely to change, and writing clear code.
---

- [Lesson 1: Write tests](#lesson-1-write-tests)
- [Lesson 2: Remove change from the core](#lesson-2-remove-change-from-the-core)
- [Lesson 3: Write clear code](#lesson-3-write-clear-code)
- [Areas of improvement](#areas-of-improvement)

I've just released my first Ruby app: [Readstat](https://github.com/fpsvogel/readstat), a CLI app that gives statistics on a plain text (CSV) reading log. This is also my first completed app in any language, so I learned a lot along the way. Here are the highlights.

## Lesson 1: Write tests

Back when I started writing the app, I knew about TDD (Test-Driven Development) but I thought setting up tests would be a waste of time for a small project like mine. I couldn't have been more wrong.

Everything was fine while I was rapidly building the app's bare-bones functionality. But then I started filling it in, and with each new feature it became more and more difficult to find out whether I had correctly implemented it. Every time, I had to run the app, enter commands, make some calculations to verify the output… not the most efficient process.

And when something didn't work, I had to spend a good while—hours sometimes—tracking down the bug. (Later I discovered [pry](https://github.com/pry/pry) and [pry-byebug](https://github.com/deivid-rodriguez/pry-byebug), which would have sped up that debugging, but they don't solve the problem of mysterious bugs being introduced in the first place.)

Another problem came up every time I took a break from the project, even if only for a few days. On my return I had to spend some time re-orienting myself because all I had to go on was the code and scattered comments, and it was not always clear what a certain chunk of code did, or was supposed to do (which too often were not the same thing). And as the codebase grew, it became harder to keep all those "whats" and "shoulds" in my head. Often I sat staring at an old piece of code, wondering if I could delete it. But deleting it meant I would have to fire up the app again, try out several commands (because I wasn't sure what this old code affected), make calculations to verify each result… or I could skip all that and just delete the old code and pray that it wasn't important. Usually I decided on no decision at all and left the code as it was, just to be safe.

And so my app accumulated—I don't say *grew* or *developed*, because it was less like the organic growth of a tree or the planned development of a building, and more like the haphazard accumulation of sediment, each new layer obscuring the one before it, slowly but surely forming fossils out of half-forgotten and poorly-understood code. Except unlike real-life fossils, these were not interesting or valuable, and they weren't always harmless either.

Eventually I scrapped it all (it was *that* frustrating) and started over with a better design. I had just finished reading Sandi Metz's [Practical Object-Oriented Design](https://sandimetz.com/products) (POODR), and I was ready to unleash my inner OOP and make a lean, mean codebase. There was a chapter on testing in there, but I waved it aside because, well—small project, no need for tests, good design is the main thing.

… A few weeks later, I was in the same abyss of head-scratching code and obscure bugs all over again. There was no escape: I resigned myself to writing tests. By then I had read [99 Bottles of OOP](https://sandimetz.com/99bottles), the other instant classic by Sandi Metz (this one co-authored with Katrina Owen, creator of the amazing [Exercism.io](https://exercism.io/). Unlike POODR, this one is about testing from the get-go. So I knew what to do; I had no more excuses.

Looking back, I am baffled at my stubborn reluctance to write tests. By now I have seen the many benefits of having a codebase covered by tests:

- Tests make it faster and so much less stressful to implement new features. As I refactor my code and add new functionality, after every non-trivial edit I run the tests (taking only a few seconds), so that if a bug comes up I know immediately where it was introduced. Hours of debugging saved.
- They also reduce those head-scratching moments when I'me wondering what an old piece of code is for. If I'm not sure, I can simply comment out the code, run the tests, and seconds later I have my answer, or at least a hint of where to look for the answer.
- Clearly-written tests also serve as documentation, sharply defining the app's capabilities and limits, and what is acceptable and unacceptable input.
- Writing tests also pushes me to write the code itself in a way that is clearer and more bug-resistant. For example, it's now easy to handle unexpected input because once I've set up a test for expected input, I can instantly set up a similar test but with strange input, and then make sure it is handled gracefully.

In short, I learned to love tests.

## Lesson 2: Remove change from the core

I noticed a recurring theme in both OOP and functional programming styles: the further down you go into your code, the less it should use things that might change. If that sounds vague, it's because this principle manifests itself in a variety of ways. For example:

- **Clearly separate your interfaces from implementation.** This is OOP 101. *How* something is done (implementation) is more likely to change than *what* is done (interface), so classes should interact only with each others' public interfaces—and classes should also be judicious about which other classes they interact with. Basically, don't let classes get in each others' business when they don't have to. (This also forces you to more clearly define interfaces vs. implementation, which can easily get mixed together, leading to messy code.)
- **Allow configuration.** I.e. inject dependencies. If a detail might change in the future, make sure it is not buried in the core of the app's code. Pull it up to a place where it can easily be specified differently by the developer, or in some cases by the user. Examples:
  - *Specified by the developer:* I have a class `LoadLibrary` that loads the library of books when the app starts up, and at some point I noticed that it was set up to load from a file only. What if I wanted to load from a string, or a remote file? So instead of `LoadLibrary.call(path)` I now have `LoadLibrary.call(feed)`, where `feed` is any object that responds to `each_line`, such as a File or a String.
  - *Specified by the user:* A lot of formatting details are involved in the loading of the CSV library of books, such as the column separator character, emojis indicating the format of an item (e.g. 📕 for print or 🔊 for audio), and many other details. Rather than hard-coding these into the app, I pulled them up into a `config.rb` file, where they can be customized. This file even specifies data such as what the CSV columns are and what all the Item attributes are, so it would be easy to add the capability for users themselves to add colums to their reading log, which they could then use in the app—for example, someone might want a Mood column, or a Discovery column indicating where (or from whom) each item was first discovered. (This cusomizability is not currently built in; it was for my own benefit that I defined all this data in `config.rb`. Now that the data have a single point of truth from where I inject them into the app, I can change them just there rather than in several places scattered across the code.)
- **Avoid state mutation.** See [my previous post on this](/posts/2020/ruby-functional-programming#state-mutation).

## Lesson 3: Write clear code

In [that same post](/posts/2020/ruby-functional-programming) I enthused about my first gem, a DSL for piping data through functions, like this: `'C:\test.txt' >> LoadFromFile >> ProcessData >> OutputResult(STDOUT)`. I don't regret working on it, because it taught me new metaprogramming techniques and how to publish a gem. But I soon stopped using it in my own app because I realized that the nifty syntax obscured what is actually going on in the code. For example:

```ruby
'C:\read_test.csv' >>
  LoadLibrary >>
  EachInput do |input, library|
    +[input, library] >>
      Command >>
      ShowOutput
  end
```

With this syntax, it's often hard to tell what arguments (or even how many arguments) one function is passing to another, because the pipe DSL obscures the data. Here is the same code using more natural syntax:

```ruby
library = Library.load('C:\read_test.csv')
Input.each_line do |input|
  Command.parse(input)
         .result(library)
         .output
end
```

I'm still not completely satisfied: the chunk after `Command` seems opaque. (I don't *think* it violates the Law of Demeter because there *is* a `Result` class, so it can be inferred that `Command` parses `input` into a `Command` object, then we get its `Result`, which we then output. But if one must so strenuously defend their code's clarity, maybe that means it is not as clear as it could be.) Still, it is more clear than before because at least now I can see the methods and their arguments.

This is just one of many instances where I noticed that my code, though clear to me now, might be confusing to Future Me. So I have gotten into the habit of critically combing through my code to see where it could be made simpler, whether it is muddled or simply too clever. And I do this not just immediately after I have written it, but also after some time has passed and I can see the code with fresh eyes.

## Areas of improvement

Here are my weak spots where I will try to improve in my next project:

- **Git.** I need to learn how to manage different branches and do that from the very beginning as I implement new features, so that I can easily roll back changes. In this project, I only started using Git when I recently uploaded it to GitHub.
- **Documentation.** In this project, my code documentation was limited to simple comments: a sentence or two above each class, and explanatory comments wherever necessary. Next time I should try a more systematic approach, such as YARD.
- **Testing output.** I'm not sure how to create uncoupled, maintainable tests for output. As it is now, I've run the app, copied good output, and pasted it into the tests as expected output, but this is problematic because as soon as anything changes in what the output looks like, then I must also manually copy the changed output into the tests again. Also, all of the output involves ANSI color codes, which are not included when I copy the output to the clipboard, which means that if the coloring of the output is wrong but everything else is OK, my tests will not see any problem.
- **Testing errors and warnings.** Similarly, the best way to test outputted errors and warnings still eludes me.

Of course, these are in addition to the blind spots that I will only notice in my next project. Onward!
