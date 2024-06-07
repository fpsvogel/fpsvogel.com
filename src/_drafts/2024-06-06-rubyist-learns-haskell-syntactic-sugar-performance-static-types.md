---
title: A Rubyist learns Haskell, part 2
subtitle: a Lisp detour, syntactic sugar, and another hiatus
description: After trying Lisp, I appreciate Haskell's expressiveness and syntactic sugar more than ever. I list Haskell learning resources and make more Ruby comparisons.
---

Last year [I started learning Haskell](/posts/2023/rubyist-learns-haskell-getting-started) and then shelved it not long after. I hear that's a popular thing to do. But I had a great excuse in [the toughest job search of my life so far](/posts/2024/early-career-developer-job-search-after-layoffs), and now I'm jumping back into Haskell.

## My Lisp detour

Actually, amid the existential rethinking of priorities that being laid off for the first time tends to provoke, I considered ***not*** jumping back into Haskell, and going with something easier instead. Haskell often comes up in the context of *"I've been learning it for 10 years and I still don't know how to make anything with it"*, and, well, I'm just not that kind of masochist. All I'm really looking for is **a functional-first language to help me expand my mind**, as a Rubyist steeped in OOP.

I tried Racket, a descendant of Scheme, which is a Lisp. Scheme has often been used in teaching contexts, with classic texts including [The Little Schemer](http://mitpress.mit.edu/9780262560993/the-little-schemer) and [Structure and Interpretation of Computer Programs](https://sarabander.github.io/sicp). I thought I would love Racket because of how it's dynamically typed like Ruby, and unlike Haskell.

But try as I might, I just couldn't get over Racket's verbosity. Sure, it helped if I convinced myself that [the profusion of parentheses is a lost art](https://xkcd.com/297/), but I'm a sucker for syntactic-sugary conciseness, as in this artificial and totally cherry-picked Haskell snippet:

```haskell
filter (>5) $ map (+1) [10,3,5,1]
```

In Ruby terms, that would be (using `it` from the upcoming Ruby 3.4):

```ruby
[10, 3, 5, 1].map { it + 1 }.filter { it > 5 }
```

Another neat Haskell example:

```haskell
squares = map (^2) [0..]
take 5 squares
-- ==> [0,1,4,9,16]
```

Or in Ruby terms:

```ruby
squares = (0..).lazy.map { _1**2 }
squares.take(5)
# => [0, 1, 4, 9, 16]
```

## How I'm learning Haskell

I have lots of Haskell resources lined up in [my new "Learn Functional Programming" repo](https://github.com/fpsvogel/learn-functional-programming). Here's what I'm starting with.

### Books and courses

- [Haskell MOOC](https://haskell.mooc.fi) and [Haskell Wikibook](https://en.wikibooks.org/wiki/Haskell) (both free) are my meat and potatoes.
- [Soar with Haskell](https://www.packtpub.com/product/soar-with-haskell/9781805128458) and/or [Haskell Programming from First Principles](https://haskellbook.com/) if I need another alternative presentation of the basics.

### Exercises

I'm a strong believer in active learning, so I'm doing these exercises **at the same time** as the above resources.

- [Haskell MOOC](https://haskell.mooc.fi) has exercises with automated tests, and a few kind souls have shared their solutions: [1](https://github.com/tinfoil-knight/haskell-mooc), [2](https://github.com/mikkom/haskell-mooc/tree/master/exercises), [3](https://github.com/dandax123/haskell-mooc-solutions).
- [Haskell on Exercism](https://exercism.org/tracks/haskell) is handy because I've already done the Ruby track on Exercism.
- Last of all, I'll take [a CLI app that I've written in Ruby](https://github.com/fpsvogel/reading) and rewrite it in Haskell.

### Where to ask for help

Equally important as all of the above is a place to ask questions when I get stuck, and for me that's been the [Functional Programming Discord server](https://discord.com/invite/K6XHBSh). Other possibilities are listed on [the Communities page of the Haskell site](https://www.haskell.org/community/).

## A `maxBy` adventure

Speaking of community, I've found Haskellers to be friendly and welcoming. Here's an example. I recently asked for help implementing a `maxBy` function. On my own, I could get it to compile only by using `if`-`else` or guards:

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

These implementations are fine. But next I wanted to write a similar function that, instead of taking two arguments to be compared (`a` and `b`), takes a list of any number of values. I had Ruby's `Enumerable#max_by` in mind, as in `[*any_number_of_elements].max_by(&:length)`.

I asked in the `#haskell-beginners` channel of the Functional Programming Discord server, and after getting a few tips I was able to write the function to take a list argument:

```haskell
import Data.Ord (comparing)

maxBy :: (a -> Int) -> a -> a -> a
maxBy measure list = maximumBy (comparing measure) list
```

I also found two other ways of writing the function, as before, taking two arguments to be compared:

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

And a way to extend all these `a`-and-`b` implementations operate on a list:

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

Along the way, I learned that **Haskell folks can be very conscious of performance**. I was encouraged to think carefully about which implementation to use, and not to pick `maximumBy` just because it conveniently operates on a list. Constructing a list is more expensive than simply taking two arguments, after all, and we can't know for certain that the compiler will optimize out constructing the list.

… but if we *do* want to know whether the compiler will perform that optimization, **we totally can!** The [Haskell Playground](https://play.haskell.org/saved/w9UU3xLx) has handy "Core" and "Asm" buttons that show the code in those two particular intermediate stages of compilation. I learned there are even more intermediate forms:

> - **Core:** Haskell with all the sugar replaced. All types are explicit (no inference), but still very much the same semantics as Haskell.
> - **STG:** Core code translated into a simple language that is no longer lazy, so all laziness (or rather: all places lazy thunks are forced) is now explicit.
> - **Cmm:** STG code translated into an simplified subset of C. Imperative, so making order of execution explicit.
> - **Asm:** What the Cmm code compiles to. Platform (OS + hardware)-specific. What your CPU can actually execute.

Longer explanations are in [this StackOverflow answer](https://stackoverflow.com/a/59338472) and [the doc on debugging the compiler](https://downloads.haskell.org/ghc/latest/docs/users_guide/debugging.html#dumping-out-compiler-intermediate-structures). Also relevant is [the doc on code optimization](https://downloads.haskell.org/ghc/latest/docs/users_guide/using-optimisation.html) and [godbolt](https://godbolt.org/), the online Haskell compiler explorer, which has more advanced features along these lines than the Haskell Playground.

All this attention paid to performance (for a little `maxBy` function!) was new to me as a Ruby developer. I knew that learning Haskell would help me think in new ways, but becoming more conscious about performance was not something I'd expected.

## Addendum: Matz on static typing and Ruby

An extended quote from Matz, the creator of Ruby, might seem like an odd way to conclude a post about Haskell. But I'm including it here because I wanted to mention that **I'm not learning Haskell because I'm tired of Ruby's dynamic typing or its object-oriented foundations.**

I enjoy Ruby a lot, actually. And that's precisely *why* I feel I should make an effort to venture out to learn a different paradigm, a different way of thinking: because **it would be very easy for me to stay comfortably in the realm of Ruby.** But by making the effort to learn Haskell, I hope to become a better programmer, including a better *Ruby programmer*.

Sometimes I feel crazy for liking Ruby *because* it doesn't have types. (Actually, that was one of my motivations for learning some Haskell, to see whether I'm crazy or not 😅) So, recently I felt reassured when I read Matz's thoughts on static types in Chapter 17 of [Coderspeak](https://www.uclpress.co.uk/products/230881). That entire chapter is great *(and the book is free to download as a PDF, so what are you waiting for?)* but I'll quote just the bit about static typing:

> "But what about the recent changes about types? I know you don't like types, you've said it publicly before. You didn't create Ruby to be statically typed. How does that make you feel?"
>
> "Oh difficult, you know." Matz embarked on what would be a long explanation, with three separate points, on how he's not very happy about the whole thing. Types were not his type. "I love seeing creative things for Ruby, but at the same time I must look at programming for the long time future. I'm a long time user of static typing."
>
> I was startled. "What do you mean?"
>
> "Well, I've been writing C my whole life. I understand the benefits of static typing. For me, it's OK to talk about static typing in Ruby. I understand the desire to get the benefit from static typing for Ruby. But at the same time, adding type declarations like other languages, PHP and Python, could change the feel of the language, you know, the feeling of programming, so I refuse to add type declarations."
>
> "The first reason is that it would change the feeling of programming in Ruby. The second reason is more about the community. In other programming languages, we see the 'typing police'. We would start to see the typing police in the community: "OK, your gem does not have type declarations. You have to have type declarations as a gem." And that's kind of forceful, you know. It's kind of bad for the community, I think."
>
> "The third reason is that, in the history of programming, programming evolves in decades. Maybe 10, 15 years ago, dynamic programming, such as PHP, Python, Ruby and Perl, was very popular. And then 20 years before that, the most popular programming was C, C++ and Pascal, you know, static type programming. Then even more years ago, SmallTalk was popular and had no static typing."
>
> Matz took a sip of coffee and went on. "The dynamic and static, it goes like this, like a pendulum. Thinking about the future, maybe in 10 or 20 years, we might have the languages without type declaration. The compilers are very smart and they guess the intention of the programmers and they have code completion; maybe they even have error detection without type declaration. If this kind of future comes, we would not be able to go into that camp because we already have type declarations," he explained. "We want to keep Ruby for that distant future, not for the, you know, the present time benefit. It's like a longer-term view based on what's happened in the past. And how it kind of fluctuates. Maybe 20 years later we will have better compilers without type declaration because the pendulum goes the opposite way. And I want to keep Ruby for that distant future."
