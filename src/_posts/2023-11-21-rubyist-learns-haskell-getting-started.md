---
title: A Rubyist learns Haskell, part 1
subtitle: not so different after all?
description: First impressions of Haskell, including surprising similarities with Ruby and, of course, the mind-blowing differences of OOP vs. functional programming.
---

- [How?](#how)
- [But *why*?](#but-why)
- [Not so different from Ruby after all?](#not-so-different-from-ruby-after-all)
  - [Consistency of language design](#consistency-of-language-design)
  - [Elegant syntax](#elegant-syntax)
- [Yeah no, Haskell is really different](#yeah-no-haskell-is-really-different)
  - [Rigors of a type system](#rigors-of-a-type-system)
  - [A new kind of elegance](#a-new-kind-of-elegance)
  - [An entirely different paradigm](#an-entirely-different-paradigm)
- [Coming next](#coming-next)

Lately a question has been on my mind, a classic for programmers:

*"What language should I learn next?"*

More specifically: *"A language that **has jobs**, or one that I would **actually enjoy**?"*

I struck a good balance a few years ago when I taught myself Ruby along with front-end basics, which I enjoy a lot *and* got me hired as an entry-level engineer. In fact, I'd be happy spending the next ten years writing Ruby for fun and profit.

So this time I threw employability out the window *completely* and chose **Haskell**.

## How?

I'm starting with [the Haskell Wikibook](https://en.m.wikibooks.org/wiki/Haskell), supplemented (of course) by…

… StackOverflow answers that *I mostly don't understand*…

… found via *my mostly-incoherent Google searches*…

… on Haskell topics where *I don't even have the vocabulary to express my lack of understanding*.

Yep, this is going to be great.

Despite the embarrassment that I'll probably feel later when I look back on this amateur and uninformed post, I feel it's important to write down my first impressions as I begin my Haskell adventure.

## But *why*?

Because Haskell is *different*. Ruby is quintessentially object-oriented, whereas Haskell is quintessentially functional.

(*I know*, that's an oversimplification: Ruby's diverse influences include functional languages of yore, and apparently [OOP is discussed without disdain](https://well-typed.com/blog/2018/03/oop-in-haskell/) in some corners of the Haskell world.)

Why learn something so different? It's **not to forget about Ruby and OOP**, but to *write better Ruby* by using a functional approach wherever it makes sense, and to use functional-friendly tools like [dry-rb](https://dry-rb.org/) and [Hanami](https://hanamirb.org/) more effectively.

It won't always be easy to bridge the conceptual gap between these two paradigms, so I braced myself for the initial shock of diving into Haskell.

But I've been pleasantly surprised in these early days at how often something in Haskell felt **familiar** to me, coming from Ruby.

## Not so different from Ruby after all?

### Consistency of language design

The snobbishness of its devotees is not Haskell's only similarity with Ruby. In fact, I've sensed **an odd kinship** between these languages that are in many ways on opposite ends of the spectrum. Maybe it's because they take their opposite approaches with **a similar purity or single-mindedness**. Here's an example.

In Ruby, everything is an object. So `2 == 2` is the syntactic sugar for `2.==(2)`. The number `2`, as any Rubyist knows, is an object that has the method `==`.

In Haskell, functions are everywhere. So `2 == 2` is syntactic sugar for `(==) 2 2`. Here, `==` is just a function.

In both cases, `==` is not a language keyword but a natural outgrowth of the language's foundational principle, be it objects or functions.

As Victor Shepelev noted in [a recent article](https://zverok.substack.com/i/138314697/irks-and-quirks),

> A lot of things that in other languages are represented by separate grammar elements, in Ruby, are just methods calls on objects.

I'm wondering if something similar could be said of Haskell and functions.

### Elegant syntax

Of course, just as in Ruby, some of Haskell's syntactic sugar really *is* syntax rather than functions disguised as operators. But its effect is to make Haskell **surprisingly elegant**, not at all what I feared, which was something like Lisp's infamous parentheses, memorialized in [xkcd](https://xkcd.com/297/) and [elsewhere](https://toggl.com/blog/save-princess-8-programming-languages).

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

You can even write it on one line, if you want to:

```haskell
mySignum x | x < 0 = -1 | x > 0 = 1 | otherwise = 0
```

<br>
So Haskell is really, deep down, similar to Ruby. Right?

## Yeah no, Haskell is really different

### Rigors of a type system

Haskell, being statically typed, is less flexible than Ruby, at least in the *"Sure, go ahead and juggle five knives if you want to"* sort of way. For example, let's take the last example above, and try replacing one of the function's return values with a string:

```haskell
mySignum x | x < 0 = -1 | x > 0 = 1 | otherwise = "zero"
```

An error comes up if you try to define this function, because the compiler wants all the possible return values to be of the same type.

The solution (as far as I understand it) would involve defining an explicit type signature. I say "explicit" because all the above examples of the `mySignum` function have an *inferred* type signature. If you open up the Haskell REPL and enter one of the valid definitions of `mySingum` from the previous section, you can then enter `:t mySignum` and the inferred type is displayed:

```haskell
mySignum :: (Ord a1, Num a1, Num a2) => a1 -> a2
```

So I pasted that inferred type signature above my function to make it explicit, and then I tried tweaking it to include a `String` return type, but I wasn't successful with my limited knowledge. The closest I got was more errors while trying to use [ad-hoc polymorphism](https://stackoverflow.com/a/39628350) or [Either](https://stackoverflow.com/questions/4770910/how-to-get-a-function-to-return-different-types).

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

### A new kind of elegance

Another difference is that Haskell's elegance can look quite different from Ruby's. A basic example is function composition:

```haskell
(unwords . reverse . words) "Mary had a little lamb"
```

This produces `"lamb little a had Mary"`.

In Ruby, it would be:

```ruby
"Mary had a little lamb".split.reverse.join(' ')
```

Ruby *does* have function composition, or rather *proc* composition, but you'll be lucky to see it actually used anywhere. Here's the previous example, now with composed procs:

```ruby
unwords = :split.to_proc
reverse = :reverse.to_proc
words = -> { _1.join(' ') }

(unwords >> reverse >> words).call "Mary had a little lamb"
```

### An entirely different paradigm

And then there are the *"Whaaat?? No way!"* 🤯 kind of moments. Here's an example, from the ["Variables and Functions"](https://en.m.wikibooks.org/wiki/Haskell/Variables_and_functions) page of the Haskell Wikibook:

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

I find it funny, looking over the Wikibook contents, that the chapter "Welcome to Haskell" is found at the beginning of the *Advanced Track*, halfway through the book 😂 It covers topics such as *monoids*, *applicative functors*, and *comonads*. Thanks to the pleasant first impressions I've had so far, I'm not dreading that chapter nearly as much as before!

<br>
<small>… but I'm still dreading it.</small>
