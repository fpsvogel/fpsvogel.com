---
title: A Rubyist learns Haskell, part 2
subtitle: a Lisp detour, and syntactic sugar
description: After trying Lisp, I appreciate Haskell's expressiveness and syntactic sugar more than ever. I list Haskell learning resources and make more Ruby comparisons.
---

Last year [I started learning Haskell](/posts/2023/rubyist-learns-haskell-getting-started) and then shelved it not long after. It seems that's a popular thing to do. But I had a great excuse in [the toughest job search of my life so far](/posts/2024/early-career-developer-job-search-after-layoffs), and now I'm jumping back into Haskell.

## My Lisp detour

Actually, amid the existential rethinking of priorities that being laid off for the first time tends to provoke, I considered not jumping back into Haskell, and going with something easier instead. Haskell often comes up in the context of *"I've been learning it for 10 years and it's so complex that I still can't write a simple program"*, and, well, I'm just not that kind of masochist. All I'm really looking for is a functional-first language to help me expand my mind, as a Rubyist steeped in OOP.

I tried Racket, a descendant of Scheme, which is a Lisp. Scheme has often been used in teaching contexts, with classic texts including [*The Little Schemer*](http://mitpress.mit.edu/9780262560993/the-little-schemer/) and [*Structure and Interpretation of Computer Programs*](https://sarabander.github.io/sicp/). Conveniently, Racket [has thorough docs](https://docs.racket-lang.org/index.html). It's also dynamically typed like Ruby, and unlike Haskell.

But try as I might, I just couldn't get over Racket's verbosity. Sure, it helped if I convinced myself that [the profusion of parentheses is a lost art](https://xkcd.com/297/), and that there's a certain beauty to nested functions like this:

```racket
(filter (lambda (n) (> n 5))
        (map (lambda (n) (+ n 1))
             '(10 3 5 1)))
```

However, I still find Haskell's compressed syntax generally more pleasing to the eye. Here's the Haskell equivalent of the above Racket code:

```haskell
filter (>5) $ map (+1) [10,3,5,1]
```

The Ruby equivalent is similarly compressed (using `it` from the upcoming Ruby 3.4):

```ruby
[10,3,5,1].map { it + 1 }.filter { it > 5 }
```

**It's not just about the parentheses, either.** Function names in Racket tend to be long, in a way that makes me feel like I'm programming in 1970:

```racket
(string-append (list-ref '("nope" "hi" "what") 1) " there")
```

Haskell, again, uses more compressed syntax:

```haskell
(["hope","hi","what"] !! 1) ++ " there"
```

Similarly in Ruby:

```ruby
%w[nope hi what][1] + " there"
```

## How I'm learning Haskell

I have lots of Haskell resources lined up in [my new "Learn Functional Programming" repo](https://github.com/fpsvogel/learn-functional-programming). Here's what I'm starting with.

### Books and courses

- [Haskell MOOC](https://haskell.mooc.fi) and [Haskell Wikibook](https://en.wikibooks.org/wiki/Haskell) (both free) are my meat and potatoes.
- [Soar with Haskell](https://www.packtpub.com/product/soar-with-haskell/9781805128458) and/or [Haskell Programming from First Principles](https://haskellbook.com/) if I need an alternative presentation of the basics.

### Exercises

I'm a strong believer in active learning, so I'm doing these exercises **at the same time** as the above resources.

- [Haskell MOOC](https://haskell.mooc.fi) has exercises with automated tests, and a few kind souls have shared their solutions: [1](https://github.com/tinfoil-knight/haskell-mooc), [2](https://github.com/mikkom/haskell-mooc/tree/master), [3](https://github.com/dandax123/haskell-mooc-solutions).
- [Haskell on Exercism](https://exercism.org/tracks/haskell) is handy because I've already done the Ruby track on Exercism.
- Finally, I'll take CLI apps that I've written in Ruby and rewrite them in Haskell.

## A syntactic-sugary conclusion

In [my last post on Haskell](https://fpsvogel.com/posts/2023/rubyist-learns-haskell-getting-started) I noted how Haskell feels strangely familiar to me as a Rubyist. After my brief foray into Lisp, I see why: **Haskell has a lot of syntactic sugar**. Here's just one example that rivals Ruby's *"It reads like English!"* kind of expressiveness:

```haskell
squares = map (^2) [0..]
take 5 squares
-- => [0,1,4,9,16]
```

Or in Ruby terms:

```ruby
squares = (0..).lazy.map { _1**2 }
squares.take(5)
# => [0, 1, 4, 9, 16]
```

Sure, this is a cherry-picked example that looks better in Haskell than in Ruby, but nevertheless, it's neat to see that Haskell is so expressive in some scenarios. This doesn't square with Haskell's reputation for being a difficult slog for anyone but the most mathematically-inclined, so I wouldn't have guessed that I'd enjoy Haskell for its syntactic sugar, of all things.

See you next time in my Haskell adventure!
