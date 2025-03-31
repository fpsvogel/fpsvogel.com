---
title: Advent of Ruby
subtitle: a CLI app for doing Advent of Code in Ruby
description: A Ruby gem with conveniences for leisurely solving Advent of Code puzzles, including viewing other people's solutions from Reddit GitHub.
---

- [Building on an existing gem](#building-on-an-existing-gem)
- [Technical challenges](#technical-challenges)
- [Reconnecting with my inner Ruby learner](#reconnecting-with-my-inner-ruby-learner)

I've been working on [Advent of Ruby](https://github.com/fpsvogel/advent_of_ruby), a CLI tool for doing Advent of Code in Ruby. Besides the usual features of such tools, it can also [show other people's solutions](https://github.com/fpsvogel/advent_of_ruby#other-solutions).

I heard about [Advent of Code](https://adventofcode.com/) years ago, but I never had the guts to try it out because I knew I'd give up in the first week. December is stressful enough without 25 days of increasingly difficult code puzzles, where I would inevitably measure my self-worth by how pathetically soon I bail out. (Yeah, I should probably talk to my therapist about that.)

Then it dawned on me that I can ignore the new puzzles in December and simply work on past years' puzzles at my own leisurely pace at any time of year.

So I solved a few old puzzles and found it enjoyable. Except… there was a lot of juggling files and browser tabs: downloading each puzzle's input file, creating files for my solution and automated tests, submitting my solution, and looking up other people's solutions on GitHub and Reddit.

I thought, ["I spend a lot of time on this task. I should write a program automating it!"](https://xkcd.com/1319/)

## Building on an existing gem

There are [several Advent of Code utility gems](https://github.com/fpsvogel/advent_of_ruby#prior-art) out there already. I decided to build on [AoC-rb](https://github.com/Keirua/aoc-cli) because it's simple and already does some of what I want with its two core commands:

- `aoc bootstrap YEAR DAY` downloads the input file, using your session cookie for adventofcode.com that you've pasted into `.env`. Also creates a solution file and a spec file.
- `aoc run YEAR DAY` runs your solution and shows the resulting answer.

I added two new commands, `commit` for committing new/modified solutions to Git, and `progress` for showing overall progress across years.

But mostly I expanded the existing `bootstrap` and `run` commands:

- `bootstrap` additionally creates Markdown files with the puzzle's instructions and other people's solutions from Reddit and GitHub.
- `run` additionally runs specs and can submit your solution to adventofcode.com.
- For both commands, the year and day arguments may be omitted, and will be inferred based on Git history and untracked files.
- For `run`, the puzzle part can be inferred too, based on whether the instructions file has been re-downloaded to include Part 2 instructions after solving Part 1.

Because of how arguments are inferred like this, the workflow can be as simple as `arb bootstrap` → `arb run` repeatedly → `arb commit` → repeat for the next puzzle. See it in action in [the demo video](https://github.com/fpsvogel/advent_of_ruby#demo).

## Technical challenges

I did a few new things in this project:

- [Capturing RSpec output while also printing it](https://github.com/fpsvogel/advent_of_ruby/blob/94ee130b0b70e0b8e2b859daee6f0a5b31234295/lib/arb/cli/run.rb#L149-L175) was interesting, especially because writing specs for the `run` command (which, among other things, runs the user's specs for a puzzle) meant *running RSpec from within RSpec* 🤪
- [Pre-downloading all Advent of Code solutions in Ruby from Reddit and GitHub](https://github.com/fpsvogel/advent_of_ruby/tree/main/data/solutions) led to my largest commits ever [at over 100k lines](https://github.com/fpsvogel/advent_of_ruby/commit/d0c28cd485f3954d8c6956d5b94b4e93be8e0407).
  - Actually the huge commits were due to VCR cassettes for specs for [the secret CLI app](https://github.com/fpsvogel/advent_of_ruby/blob/94ee130b0b70e0b8e2b859daee6f0a5b31234295/bin/download_solutions) within this gem that I built to download Ruby solutions, but which could be used for any language.
- [Writing end-to-end specs](https://github.com/fpsvogel/advent_of_ruby/blob/22127828fe454a78049f352319d7f6f77ff383cc/spec/arb/bootstrap_spec.rb) for a CLI app that has a lot of side effects (creating files, printing output, etc.) was a new experience for me. My other gem [Reading](https://github.com/fpsvogel/reading) has zero side effects because all it does is parse a CSV reading log and return the data. The difference shows in the tests: Reading has **441 tests that run in 0.1 seconds**, whereas Advent of Ruby has **32 tests that run in 10 seconds**. I could have spent time rearchitecting the gem to make it more unit-testable and not write end-to-end tests for everything, but as I wrote in a [commit](https://github.com/fpsvogel/advent_of_ruby/commit/92d8591cbb0f017ef2e604f72592a93608db31b5) message, `I am just a man and I want to finish this thing before the birth of my second child`.

## Reconnecting with my inner Ruby learner

I had fun building this gem. It took me back to when I was learning Ruby by doing exercises on [Exercism](https://exercism.org). In fact, Exercism inspired this gem: I wanted to recapture the joy of using a cohesive UI to solve a programming puzzle and then scroll through other people's Ruby solutions, often having my mind blown by an elegant approach that I never would have thought of.

Also, I know that solving all past Advent of Code will take anywhere from a few years to the rest of my life, but at least now I have more motivation in the fact that I need to make the time that I spent working on this gem worthwhile—though, [according to xkcd](https://xkcd.com/1205/), the odds are not good.
