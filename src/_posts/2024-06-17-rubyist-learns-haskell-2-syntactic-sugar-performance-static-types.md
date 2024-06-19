---
title: A Rubyist learns Haskell, part 2
subtitle: expressiveness and correctness
description: Adventures in Haskell's expressiveness, performance, and static typing philosophy, along with thoughts on Ruby's dynamic typing.
---

- [Expressing things in different ways](#expressing-things-in-different-ways)
  - [Example 1: reordering functions](#example-1-reordering-functions)
  - [Example 2: reordering functions again](#example-2-reordering-functions-again)
  - [Example 3: `maxBy` and performance](#example-3-maxby-and-performance)
- [Haskell's dream of total static typing](#haskells-dream-of-total-static-typing)
  - [Matz on static typing and Ruby](#matz-on-static-typing-and-ruby)

Last year [I started learning Haskell](/posts/2023/rubyist-learns-haskell-1-getting-started) and then shelved it not long after. I hear that's a popular thing to do. But I had a great excuse in [the toughest job search of my life so far](/posts/2024/early-career-developer-job-search-after-layoffs), and now I'm jumping back into Haskell.

## Expressing things in different ways

Haskell isn't always fun for a newcomer. Often it feels like I'm learning programming all over again. It's tiring and I sometimes feel stupid.

Whenever I feel like quitting, what keeps me going is how interesting it is to write code for the same operation in different and often succinct ways. I guess that's what people mean by *expressiveness* (expressivity?). Here are a few examples.

### Example 1: reordering functions

Here's a solution to an exercise in the [Haskell MOOC](https://haskell.mooc.fi). (By the way, you can see other learning resources that I have lined up in [my new "Learn Functional Programming" repo](https://github.com/fpsvogel/learn-functional-programming).)

```haskell
-- Ex 3.5: Implement a function capitalize that takes in a string
-- and capitalizes the first letter of each word in it.
--
-- Example:
--   capitalize "goodbye cruel world" ==> "Goodbye Cruel World"

capitalize :: String -> String
capitalize string = unwords (map capitalizeWord (words string))
  where capitalizeWord (first:rest) = toUpper first : rest
```

Any Haskell beginner will tell you that all those parentheses are atrocious (no offense to you fans of Lisp), so here's that first line rewritten using the `$` operator (function application) to make the parentheses unnecessary:

```haskell
capitalize string = unwords $ map capitalizeWord $ words string
```

As I was writing this solution, the linter told me that because this is just a bunch of functions applied to the parameter `string`, I could omit the parameter and instead use `.` (function composition):

```haskell
capitalize = unwords . map capitalizeWord . words
```

I don't love these solutions so far because they seem backwards to me, putting what I consider to be the "subject" of the function at the end. Maybe this is because I'm used to thinking in Ruby, where the equivalent operation would look like this:

```ruby
string.split.map(&:capitalize).join(" ")
```

So next, I used `&` (reverse function application), which is like a pipe operator:

```haskell
capitalize string = string & words & map capitalizeWord & unwords
```

As before, I could shorten my solution by leaving out `string`, this time using `>>>` (reverse function composition):

```haskell
capitalize = words >>> map capitalizeWord >>> unwords
```

And if you think `>>>` looks unwieldy, you can easily define your own version of it as the reverse of function composition:

```haskell
(.>) = flip (.)

capitalize :: String -> String
capitalize = words .> map capitalizeWord .> unwords
  where capitalizeWord (first:rest) = toUpper first : rest
```

Or, you can use the [more sensible operators from the Flow package](https://github.com/tfausak/flow#cheat-sheet):

```haskell
-- <| instead of $ (function application)
capitalize string = unwords <| map capitalizeWord <| words string
-- <. instead of . (function composition)
capitalize = unwords <. map capitalizeWord <. words
-- |> instead of & (reverse function application)
capitalize string = string |> words |> map capitalizeWord |> unwords
-- .> instead of >>> (reverse function composition)
capitalize = words .> map capitalizeWord .> unwords
```

On a side note, this flexibility of expression is fun for me as a learner and solo tinkerer, but I can see how it could be *too much freedom* in the context of a team or organization. Agreeing on and enforcing a code style would help keep the code readable for everyone.

### Example 2: reordering functions again

Here's another example using `&` (reverse function application) to reorder the contents of a function. This example also uses [sections](https://wiki.haskell.org/Section_of_an_infix_operator), one of my favorite bits of syntactic sugar:

```haskell
-- Ex 3.6: powers k max should return all the powers of k that are less
-- than or equal to max. For example:
--
-- powers 2 5 ==> [1,2,4]
-- powers 3 30 ==> [1,3,9,27]
-- powers 2 2 ==> [1,2]
--
-- You can assume that k is at least 2.

powers :: Int -> Int -> [Int]
powers k max = map (k ^) [0..] & takeWhile (<= max)
```

Again, this matches the order of my thoughts more closely than the (more conventional Haskell?) `takeWhile (<= max) $ map (k ^) [0..]`. In Ruby it would be:

```ruby
def powers(k, max)
  (0..).lazy.map { k ** _1 }.take_while  { _1 <= max }.to_a
end
```

### Example 3: `maxBy` and performance

This final example goes beyond style to the murky waters of performance implications.

In the [Functional Programming Discord server](https://discord.com/invite/K6XHBSh) I recently asked for help implementing a `maxBy` function. On my own, the only working solutions I could come up with were based on `if`-`else` or guards:

```haskell
maxBy :: (a -> Int) -> a -> a -> a
maxBy measure a b = if measure a >= measure b then a else b
```

```haskell
maxBy :: (a -> Int) -> a -> a -> a
maxBy measure a b
      | measure a < measure b  =  b
      | otherwise  = a
```

These implementations are fine. But as a challenge to myself, next I wanted to write a similar function that, instead of taking two arguments to be compared (`a` and `b`), takes a list of any number of values. I had Ruby's `Enumerable#max_by` in mind, as in `[*any_number_of_elements].max_by(&:length)`.

After getting a few tips from Discord Haskellers, I was able to write a more flexible version that takes a list argument:

```haskell
import Data.Ord (comparing)

flexibleMaxBy :: (a -> Int) -> [a] -> a
flexibleMaxBy measure list = maximumBy (comparing measure) list
```

The linter then told me that I could omit the `list` argument, so I did that and adjusted the type annotation:

```haskell
flexibleMaxBy :: (a -> Int) -> ([a] -> a)
flexibleMaxBy measure = maximumBy (comparing measure)
```

This more flexible function could be used by the original `maxBy` like this:

```haskell
maxBy :: (a -> Int) -> a -> a -> a
maxBy measure a b = flexibleMaxBy measure [a, b]
```

Based on other tips that I got, I also learned two more ways of writing the original function:

```haskell
import Data.Semigroup

fromArg (Arg a b) = b

maxBy :: (a -> Int) -> a -> a -> a
maxBy measure a b = fromArg $ max (Arg (measure a) a) (Arg (measure b) b)
```

```haskell
import Data.Ord (comparing)

maxBy :: (a -> Int) -> a -> a -> a
maxBy measure a b = case comparing measure a b of
  LT -> b
  _  -> a
```

And a recursion-based way to extend these `a`-and-`b` implementations (including my original solutions using `if`-`else` or guards) to operate on a list:

```haskell
flexibleMaxBy :: (a -> Int) -> [a] -> a
flexibleMaxBy _ [] = error "Can't take max of nothing"
flexibleMaxBy _ [x] = x
flexibleMaxBy f (x:xs) = maxBy f x (flexibleMaxBy f xs)
```

Or, better (avoiding the side effect of raising an error):

```haskell
flexibleMaxBy :: (a -> Int) -> [a] -> Maybe a
flexibleMaxBy _ [] = Nothing
flexibleMaxBy f list = Just (go list)
  where
    go [x] = x
    go (x:xs) = maxBy' f x (go xs)
```

Along the way, I learned that **Haskellers can be very conscious of performance**. I was encouraged to think carefully about which `maxBy` implementation to use, and not to pick the one with `maximumBy` just because it looks neater in its concise flexibility. Constructing a list is more expensive than simply taking two arguments, after all, and we can't know for certain that the compiler will optimize out constructing the list.

… but if we *do* want to know whether the compiler will perform that optimization, **we totally can!** The [Haskell Playground](https://play.haskell.org/saved/w9UU3xLx) has handy "Core" and "Asm" buttons that show the code in those two particular intermediate stages of compilation. I learned [from someone in the Discord](https://discord.com/channels/280033776820813825/505367988166197268/1247975740696170586) that there are even more intermediate forms:

> - **Core:** Haskell with all the sugar replaced. All types are explicit (no inference), but still very much the same semantics as Haskell.
> - **STG:** Core code translated into a simple language that is no longer lazy, so all laziness (or rather: all places lazy thunks are forced) is now explicit.
> - **Cmm:** STG code translated into an simplified subset of C. Imperative, so making order of execution explicit.
> - **Asm:** What the Cmm code compiles to. Platform (OS + hardware)-specific. What your CPU can actually execute.

Longer explanations are in [this StackOverflow answer](https://stackoverflow.com/a/59338472) and [the doc on debugging the compiler](https://downloads.haskell.org/ghc/latest/docs/users_guide/debugging.html#dumping-out-compiler-intermediate-structures). Also relevant is [the doc on code optimization](https://downloads.haskell.org/ghc/latest/docs/users_guide/using-optimisation.html) and [godbolt](https://godbolt.org/), the online Haskell compiler explorer, which has more advanced features along these lines than the Haskell Playground.

**All this attention paid to performance (for a little `maxBy` function!) was new to me as a Ruby developer.** I knew that learning Haskell would help me think in new ways, but becoming more conscious about performance was not something I'd expected.

(On the other hand, critics point out that Haskellers *need* to be aware of compilation details in order to write code "just so" in ways that the compiler ends up optimizing it. Even if this is the case, it might still be a good exercise for me to become more conscious of the performance implications of code as I write it.)

## Haskell's dream of total static typing

Besides expressive flexibility, another intriguing aspect of Haskell is how increasingly extensive its static typing system is.

*"Total static typing"* is a term that I made up just now to refer to the goal that I sense in Haskell's evolution. Its type system has become more complex over time, and within a few years Haskell might get a dependent type system, which is best explained (along with an alternative path) in the article [Why Liquid Haskell Matters](https://www.tweag.io/blog/2022-01-19-why-liquid-haskell/).

In a nutshell, these efforts aim to extend Haskell so that the compiler (or a compiler-integrated tool) can check not only for valid *types*, but also for valid *values*. I may be wrong about this, but it seems to me that the ultimate goal is **to verify at compile time everything that I'm used to verifying separately (and often incompletely) in unit tests.** In a sense, the types (or in the case of Liquid Haskell, the predicate annotations) ideally *are* (or, will be) the unit tests, except better integrated into the compiler and so offering more real guarantees.

Of course, fancy type systems won't obviate the need for integration tests in any program that interacts with external systems such as a database, a client, third-party services, etc. So if types can't replace anything higher-level than unit tests, are complex type systems are even worth the trouble? And can nontrivial unit tests be replaced at all? I'm not the only wondering, because I've seen an ongoing debate over that question.

Doubts aside, the idea of a type system completely replacing unit tests is intriguing to me as a newcomer hailing from the very dynamic world of Ruby.

### Matz on static typing and Ruby

Speaking of Ruby. An extended quote from Matz, Ruby's creator, might seem like an odd way to conclude a post about Haskell. But I'm including it here because I wanted to mention that **I'm not learning Haskell because I'm tired of Ruby's dynamic typing.**

I enjoy Ruby a lot, actually. And that's precisely *why* I feel I should make an effort to venture out to learn a different paradigm: because **it would be very easy for me to stay comfortably in the realm of Ruby.** I'm hoping that learning Haskell will make me a better programmer, including a better *Ruby programmer*.

In this day and age when types are all the rage, I feel like I'm crazy for liking Ruby *because* it doesn't have types. (Actually, that was one of my motivations for learning some Haskell, to see whether I'm crazy or not 😅) So, recently I felt reassured when I read Matz's thoughts on static types in Chapter 17 of [Coderspeak](https://www.uclpress.co.uk/products/230881). That entire chapter is great *(and the book is free to download as a PDF, so what are you waiting for?)* but I'll quote just the bit about static typing:

> "But what about the recent changes about types? I know you don't like types, you've said it publicly before. You didn't create Ruby to be statically typed. How does that make you feel?"
>
> "Oh difficult, you know." Matz embarked on what would be a long explanation, with three separate points, on how he's not very happy about the whole thing. Types were not his type. "I love seeing creative things for Ruby, but at the same time I must look at programming for the long time future. I'm a long time user of static typing."
>
> I was startled. "What do you mean?"
>
> "Well, I've been writing C my whole life. I understand the benefits of static typing. For me, it's OK to talk about static typing in Ruby. I understand the desire to get the benefit from static typing for Ruby. But at the same time, adding type declarations like other languages, PHP and Python, could change the feel of the language, you know, the feeling of programming, so I refuse to add type declarations."
>
> "The first reason is that it would change the feeling of programming in Ruby. The second reason is more about the community. In other programming languages, we see the 'typing police'. We would start to see the typing police in the community: 'OK, your gem does not have type declarations. You have to have type declarations as a gem.' And that's kind of forceful, you know. It's kind of bad for the community, I think."
>
> "The third reason is that, in the history of programming, programming evolves in decades. Maybe 10, 15 years ago, dynamic programming, such as PHP, Python, Ruby and Perl, was very popular. And then 20 years before that, the most popular programming was C, C++ and Pascal, you know, static type programming. Then even more years ago, Smalltalk was popular and had no static typing."
>
> Matz took a sip of coffee and went on. "The dynamic and static, it goes like this, like a pendulum. Thinking about the future, maybe in 10 or 20 years, we might have the languages without type declaration. The compilers are very smart and they guess the intention of the programmers and they have code completion; maybe they even have error detection without type declaration. If this kind of future comes, we would not be able to go into that camp because we already have type declarations," he explained. "We want to keep Ruby for that distant future, not for the, you know, the present time benefit. It's like a longer-term view based on what's happened in the past. And how it kind of fluctuates. Maybe 20 years later we will have better compilers without type declaration because the pendulum goes the opposite way. And I want to keep Ruby for that distant future."

I don't know whether Matz is right in his predictions, or whether this quote will age poorly. I don't know whether Haskell's dream of total static typing is a fool's errand, or the way of the future. But in order to become a programmer *now*, I feel that I should learn different ways of approaching problems than I'm used to, and Haskell conveniently—often intriguingly, sometimes painfully—forces me to do that.

See you next time in my Haskell adventure!
