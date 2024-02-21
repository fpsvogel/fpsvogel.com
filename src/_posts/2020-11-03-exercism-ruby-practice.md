---
title: Ruby practice with Exercism
subtitle: what I learned
description: Exercism is a great hands-on way to learn a new programming language. Here are the lessons I learned from doing their Ruby track.
---

- [1. Learn from the work of others, then refactor](#1-learn-from-the-work-of-others-then-refactor)
- [2. Think before you code](#2-think-before-you-code)
- [3. More concise isn't always better](#3-more-concise-isnt-always-better)
- [4. More optimized isn't always better](#4-more-optimized-isnt-always-better)
- [5. Ruby's collections and blocks!!](#5-rubys-collections-and-blocks)
- [Even more is coming in Exercism v3](#even-more-is-coming-in-exercism-v3)

I've just reached the end of 36 days of Ruby coding exercises with [Exercism](https://exercism.io/tracks/ruby). Here's some of what I learned.

## 1. Learn from the work of others, then refactor

The great thing about Exercism is that once you've solved an exercise, you can see other people's solutions (ranked by popularity), then rework and resubmit your own.

For example, an exercise I solved in 26 lines of code was solved by someone else in just 9 lines, thanks to their powerful and elegant use of regular expressions. (I'm not a fan compressing a whole program into a monstrous freaky regex, but this isn't like that.)

```ruby
module RunLengthEncoding
  def self.encode(str)
    str.gsub(/(.)\1+/) { |s| "#{s.length}#{s[0]}" }
  end

  def self.decode(str)
    str.gsub(/\d+./) { |s| s[-1] * s.to_i }
  end
end
```

Whenever I found a better solution than my own, I copied it and resubmitted it as my new solution, for easier future reference. This was the outcome more often than not, casting away my little creation into the cold and dark as soon as I discovered a less blemished specimen to take its place.

However, I console myself by noting a small victory for my original solutions. I kept a list of exercises where someone else's solution was not just better but *considerably* better than mine, and I kept another list of exercises where my solution was (in my opinion) considerably better than anyone else's. This "mine's better" list has 15 exercises, versus 14 in the other list.

![success kid meme](/images/memes/success.jpg)

## 2. Think before you code

So it was great fun to see other people's solutions and compare them to mine, with feelings ranging from "mind blown" to facepalming at an easy approach that I'd overlooked. Over time it dawned on me that with more careful thought, I could prevent the latter.

Case in point: for generating Pascal's triangle, I painstakingly built an intricate tree-like recursive triangle data structure in 84 lines, only to realize (too late) that it could be done in 8 lines with simple line-by-line iteration. 🤦‍♂️ Lesson: don't bury yourself in a complex solution until you've spent some time thinking and exploring other possibilities.

## 3. More concise isn't always better

The cleverest and shortest Exercism solutions are generally the most popular, but I found that they are not always the best. For example, this was the top-ranked solution in one exercise:

```ruby
module Grep
  def self.grep(pattern, flags, files)
    [].tap do |results|
      files.each do |file|
        File.read(file).lines.each_with_index do |line, index|
          matcher = Regexp.new(
            flags.include?("-x") ? "^#{pattern}$" : pattern,
            (Regexp::IGNORECASE if flags.include?("-i")))
          next unless line.match?(matcher) ^ flags.include?("-v")
          break results << file if flags.include?("-l")
          results << [
            ("#{file}:" unless files.one?),
            ("#{index.succ}:" if flags.include?("-n")),
            line.rstrip].join
        end
      end
    end.join("\n")
  end
end
```

The module and method name give a general idea of what it's for, but to know anything beyond that requires wading into a quagmire of code. This solution is three times shorter than the runners-up; it is undoubtedly concise. But it is not elegant, nor is it maintanable or extensible. [Here](https://exercism.io/tracks/ruby/exercises/grep/solutions/9a28202cc3414e1faa8a36a6b2f1028e) is the solution that I picked as the best.

## 4. More optimized isn't always better

The same holds true for optimized code. Below is another top-ranked solution. It calculates coin change, finding the fewest coins that total a given amount of money (`target`), using a given list of coin values (`coins`). (The runner-up solutions are not so concise, but this time they're equally difficult to understand since their algorithms are only more sprawling.)

```ruby
def self.generate(coins, target)
  best = Array.new(target + 1)
  best[0] = []

  # Doing larger coins first results in fewer array writes,
  # compared to doing smaller coins first.
  # Both ways give the same answer, though.
  coins.sort.reverse.each { |coin|
    (coin..target).each { |subtarget|
      next unless (best_without = best[subtarget - coin])
      # Lol &.<=
      # But it's necessary to avoid constructing [coin] + best_without when unnecessary.
      next if best[subtarget]&.size &.<= best_without.size + 1
      best[subtarget] = [coin] + best_without
    }
  }

  best[target]&.sort or raise ImpossibleCombinationError.new(target)
end
```

Even with the comments, that's not easy to follow. We can take a simpler approach using Ruby's built-in array operations. Here's my solution:

```ruby
def self.generate(coins, target)
  largest_to_smallest = coins.reverse
  (1..Float::INFINITY).each do |count|
    raise ImpossibleCombinationError if count > target / coins.min
    largest_to_smallest.repeated_combination(count) do |combo|
      return combo.sort if combo.sum == target
    end
  end
end
```

My algorithm is not quite as efficient, but there is no perceptible speed difference with the necessarily small input. (There will never be more than a few possible coin values, and the target amount will never be many times more than the largest coin.) So in this case, simplicity wins over efficiency.

## 5. Ruby's collections and blocks!!

The last snippet above is also a good example of the elegant solutions that arise out of Ruby's rich collections library and its powerful block-based iterators. Before this month of hands-on practice, I didn't understand what was so special about Ruby, and I was frankly annoyed at how Ruby provides so many different ways of doing the same thing. But now, after being impressed over and over by super-elegant Ruby code, I've fallen in love. ❤️

## Even more is coming in Exercism v3

Definitely give Exercism a try if you're learning Ruby or [any of these 51 other languages](https://exercism.io/my/tracks). And stay tuned, because the good folks who run Exercism are hard at work on [a new version](https://www.youtube.com/watch?v=XiV_vYn1Ea8) that will have even more material and a better mentoring system. (That's another amazing thing about Exercism that I haven't mentioned: you can get personalized feedback from mentors, for free! Faith in humanity, restored.)
