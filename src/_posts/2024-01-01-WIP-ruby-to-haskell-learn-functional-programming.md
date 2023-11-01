---
title: A Rubyist learns Haskell, part 1
subtitle: a surprising elegance
description:
---

- [Why Haskell?](#why-haskell)
- [Not so different from Ruby after all?](#not-so-different-from-ruby-after-all)
- [Elegant syntax](#elegant-syntax)
- [Rigors of a type system](#rigors-of-a-type-system)
- [A different kind of elegance](#a-different-kind-of-elegance)
- [The mind-blowing differences](#the-mind-blowing-differences)
- [Coming next](#coming-next)

Recently I *almost* decided to learn Java to widen my career prospects. That's how bleak the job market is right now for non-seniors like me.

Thankfully, I ended up reeling back in disgust and thinking, ***"You know, what the heck, I'll learn Haskell."*** No job prospects there, but… eh, who cares.

I'm starting with [the Haskell Wikibook](https://en.m.wikibooks.org/wiki/Haskell), supplemented (of course) by StackOverflow answers that I *mostly don't understand*, found via my *mostly-incoherent Google searches* on Haskell topics where
I *don't even have the vocabulary to express my lack of understanding*. Yep, this is going to be great.

Despite the embarrassment that I'll probably feel later on as I look back on this noobish post, I feel it's important to write down my first impressions as I begin my Haskell adventure.

## Why Haskell?

Because it's *different*. Ruby is quintessentially object-oriented, whereas Haskell is quintessentially functional.

But the reason I'm learning Haskell is **not to forget about Ruby and OOP**, but to *improve my Ruby code* by using a functional approach wherever it makes sense, and to use functional-friendly tools like [dry-rb](https://dry-rb.org/) and [Hanami](https://hanamirb.org/) more effectively.

It won't always be easy to bridge the conceptual gap between these two paradigms, so as to bring lessons from one into the other, but I think the effort will be a worthwhile.

## Not so different from Ruby after all?

Snobbishness is not Haskell's only similarity with Ruby. In fact, I've sensed **an odd kinship** between these languages that are in many ways on opposite ends of the spectrum. Maybe it's because they take their opposite approaches with **a similar purity or single-mindedness**. Here's an example.

In Ruby, everything is an object. So `2 == 2` is the syntactic sugar for `2.==(2)`. The number `2` (believe it or not) is an object that has the method `==`.

In Haskell, functions are everywhere. So `2 == 2` is syntactic sugar for `(==) 2 2`. Here, `==` is just a function.

In both cases, `==` is not a language keyword but a natural outgrowth of the language's foundational principle, be it objects or functions.

As Victor Shepelev (a.k.a. zverok) noted in [a recent article](https://zverok.substack.com/i/138314697/irks-and-quirks),

> A lot of things that in other languages are represented by separate grammar elements, in Ruby, are just methods calls on objects.

The analogy of [Ruby as Play-Doh rather than LEGO bricks](https://weblog.jamisbuck.org/2008/11/9/legos-play-doh-and-programming.html) also comes to mind. After learning a bit of Haskell, I get the impression that it too is like Play-Doh.

## Elegant syntax

Of course, just as in Ruby, some of Haskell's syntactic sugar really *is* syntax rather than functions disguised as operators. But its effect is to make Haskell **surprisingly elegant**, not at all what I expected, given that I feared something like Lisp's infamous parentheses, memorialized in [xkcd](https://xkcd.com/297/) and [elsewhere](https://andreyor.st/posts/2020-12-03-we-need-to-talk-about-parentheses/).

For example, we can take this function:

```haskell
mySignum x =
    if x < 0
        then -1
        else if x > 0
            then 1
            else 0
```

And rewrite it using *guards*:

```haskell
mySignum x
    | x < 0     = -1
    | x > 0     = 1
    | otherwise = 0
```

You can even write it one line, if you want to:

```haskell
mySignum x | x < 0 = -1 | x > 0 = 1 | otherwise = 0
```

## Rigors of a type system

Haskell, being statically typed, is less flexible than Ruby, at least in the *"Sure, go ahead and juggle five knives if you want to"* sort of way. For example, let's try replacing one of the above function's return values with a string:

```haskell
mySignum x | x < 0 = -1 | x > 0 = 1 | otherwise = "zero"
```

This results in an error, because Haskell wants all the possible return values to be of the same type.

The solution would involve defining an explicit type signature. Haskell makes it easy to see an *inferred* type signature: after we've entered one of the valid definitions of `mySingum` from the previous section, just enter `:t mySignum` in the REPL, and the inferred type appears:

```haskell
mySignum :: (Ord a1, Num a1, Num a2) => a1 -> a2
```

Then I tried tweaking that to include a `String` return type, but I wasn't successful with my limited knowledge. The closest I got was more errors while trying to use [ad-hoc polymorphism](https://stackoverflow.com/a/39628350) or [Either](https://stackoverflow.com/questions/4770910/how-to-get-a-function-to-return-different-types).

I know, I know, **this is a ridiculous function** that no one would write in real life. Even in a more realistic scenario **it would probably a bad idea** to write a function that returns either a number or a string.

For comparison, here's how our ridiculous function would translate to Ruby:

```ruby
def my_signum(number)
  if number.negative?
    -1
  elsif number.positive?
    1
  else
    "zero"
  end
end
```

Or if you like code golf:

```ruby
def my_signum(x) = x < 0 ? -1 : (x > 0 ? 1 : "zero")
```

## A different kind of elegance

Here's one more example of how Haskell seems to me just as elegant as Ruby, but in a different way:

```haskell
(unwords . reverse . words) "Mary had a little lamb"
```

This produces `"lamb little a had Mary"`.

In Ruby, it would be:

```ruby
"Mary had a little lamb".split(' ').reverse.join(' ')
```

## The mind-blowing differences

Besides seeing unexpected connections with Ruby, the other fun part of learning Haskell is the *"Whaaat?? No way!"* 🤯 kind of moments. Here's an example, from the ["Variables and Functions"](https://en.m.wikibooks.org/wiki/Haskell/Variables_and_functions) page of the Haskell Wikibook:

> Because their values do not change within a program, variables can be defined in any order. For example, the following fragments of code do exactly the same thing:
>
> ```ruby
> y = x * 2
> x = 3
> ```
>
> ```ruby
> x = 3
> y = x * 2
> ```

Now we're in *a completely different world* from Ruby, or any other imperative language. I still don't know what possibilities this opens up, but I get the feeling they are significant.

## Coming next

In future posts in this series, I'll cover several chapters of the Wikibook at once, so as not to bore you with too many details. I only covered the first chapter here because I didn't want to rush past my first impressions.

I find it funny, looking over the Wikibook contents, that the chapter "Welcome to Haskell" is found at the beginning of the Advanced Track, halfway through the book 😂 It covers topics such as *monoids*, *applicative functors*, and *comonads*. Thanks to the pleasant first impressions I've had so far, I'm actually not dreading that chapter!
