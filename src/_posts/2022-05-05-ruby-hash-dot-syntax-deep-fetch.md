---
title: Dot syntax and deep_fetch for Ruby hashes
subtitle: benchmarks and usability considerations
---

- [Baselines](#baselines)
- [Dot syntax](#dot-syntax)
- [Dig with errors](#dig-with-errors)
- [Moral of the story](#moral-of-the-story)
- [Appendix A: `dig` on a hash with error-raising defaults](#appendix-a-dig-on-a-hash-with-error-raising-defaults)
- [Appendix B: `Hash#to_struct`](#appendix-b-hashto_struct)
- [Appendix C: the benchmark code](#appendix-c-the-benchmark-code)

Recently I heard about this convenient feature of [Elixir maps](https://hexdocs.pm/elixir/Map.html):

> To access atom keys, one may also use the `map.key` notation. Note that `map.key` will raise a `KeyError` if the `map` doesn't contain the key `:key`, compared to `map[:key]`, that would return `nil`.

Nice! This is something I've been wishing for in Ruby. In a current project I have a configuration hash that is passed around and used in a variety of objects. The hash is quite large and several levels deep, so my code abounds with chains of `Hash#fetch` such as `config.fetch(:item).fetch(:template).fetch(:variants)`. Which, as you can imagine, makes some lines very long and not particularly readable 😒

Two notes on why I've been doing it this way:

- The reason I use `fetch` instead of `config[:item][:template][:variants]` or `config.dig(:item, :template, :variants)` is that the `KeyError` raised by `fetch`, in case of a missing key, is more helpful than the default `nil` value from brackets or `dig`. In fact, that `nil` could cause a major debugging headache if it results in an error somewhere else far from where the `nil` originated.
- If you're wondering why I'm using a raw hash instead of a custom `Config` class with syntactic sugar such as `config[:item, :template, :variants]`: that could be a great idea in some projects! But in this project, some objects use only a part of the config and I don't want to pass the entire config into those objects. Also, some objects perform hash operations using parts of the config. So if I'm creating separate `Config` objects just to wrap inner hashes from the main `Config`, and if I'm converting these `Config` objects into a hash at various points, then it seems I should simply use a hash to begin with. In this project it's simpler to deal with hashes all the time, so that I don't have to ask myself, *"Let's see, is this a `Config` object here, or has it turned into a hash?"*

So, if we stick with a raw hash, can we hack our way to a more concise alternative to those repeated `fetch`es, but with the same safety net of a `KeyError`? Of course! This is Ruby, after all, where anything is possible. But whether it's *advisable*… that's the real question. In this post, we'll look at two possible syntaxes along with their performance and usability implications:

- Dot syntax: `config.item.template.variants`
- Deep fetch: `config.deep_fetch(:item, :template, :variants)`

Originally I set out to find a performant approach to dot syntax, but by the end I had changed my mind, for reasons that I'll explain.

## Baselines

First, here are benchmarks on standard syntax (mostly). For the benchmark code, see [the end of this post](#appendix-c-the-benchmark-code).

1. Bracket notation: `hash[:a][:b]`
2. Dig: `hash.dig(:a, :b)`
3. Chained `fetch`: `hash.fetch(:a).fetch(:b)`
4. A shorter `fetch` alias: `hash > :a > :b`. Because why not.

```
                           user     system      total        real
1. brackets           :  0.003332   0.000000   0.003332 (  0.003332)
2. dig                :  0.002877   0.000823   0.003700 (  0.003704)
3. fetch              :  0.005040   0.000000   0.005040 (  0.005044)
4. fetch alias        :  0.005012   0.000000   0.005012 (  0.005012)
```

**Notes:**

- These are all very performant. But remember, brackets and `dig` return `nil` where I want a `KeyError`, and chained `fetch` is what I'm trying to get away from.
- In some runs, `dig` (#2) was faster than brackets (#1), but more often brackets win by a hair.
- Chained `fetch` (#3) is consistently slower than brackets here in the benchmarks, but my project's test suite does not run any faster when I replace all calls to `fetch` with brackets. It's a good reminder that benchmarks don't always reflect real-life performance.
- Even though the `fetch` alias (#4) is just as fast as `fetch` itself in the benchmarks, my project's test suite took 20% longer to run when I replaced all calls to `fetch` with an alias. 20% slower is not much, especially since all of my tests run in well under one second. But there's also the fact that while `config > … > …` looks really cool, it is a bit cryptic (likely to confuse my future forgetful self), and I have to surround it with parentheses every time I want to call a method on the return value. Still, I was curious about the performance hit and that's why I included the `fetch` alias here.

## Dot syntax

Here are a few approaches to dot notation for hashes or hash-like structures, benchmarked. Keep in mind that I measured only access (reading) performance, not initialization or writing.

1. A Struct. *(Update: I also tried the new [Data](https://dev.to/baweaver/new-in-ruby-32-datadefine-2819) class in Ruby 3.2, but it provides the same speed of access as Struct, so I decided not to add it to the benchmarks.)*
2. Faux dot notation by flattening a hash and giving it composite keys, as in `config[:"item.template.variants"]`. I copied this approach [from here](https://snippets.aktagon.com/snippets/738-dot-notation-for-ruby-configuration-hash), with the main difference that I use symbols as keys because they're more performant than strings. Note that `:"string"` is similar to `"string".to_sym` but faster because a string is not created every time. Also, this approach uses brackets, but only because that hash's bracket accessor (`Hash#[]`) is overridden to use `fetch`.
3. An OpenStruct.
4. Augmenting a single hash with methods corresponding to its keys.
5. [ActiveSupport::OrderedOptions](https://api.rubyonrails.org/classes/ActiveSupport/OrderedOptions.html).
6. [hash_dot](https://github.com/adsteel/hash_dot) gem. Also, my benchmark code is based on [the benchmarks in hash_dot's README](https://github.com/adsteel/hash_dot#benchmarks).
7. [Hashie](https://github.com/hashie/hashie#methodaccess) gem.

```
                           user     system      total        real
1. Struct             :  0.002540   0.000000   0.002540 (  0.002541)
2. flat composite keys:  0.008301   0.000000   0.008301 (  0.008314)
3. OpenStruct         :  0.009731   0.000000   0.009731 (  0.009772)
4. per-hash dot access:  0.015300   0.000000   0.015300 (  0.015304)
5. AS::OrderedOptions :  0.070637   0.000000   0.070637 (  0.070640)
6. hash_dot           :  0.163008   0.000000   0.163008 (  0.163076)
7. hashie             :  0.163450   0.000000   0.163450 (  0.163451)
```

**Notes:**

- The Struct is 🔥fast🔥 the OpenStruct is not bad either. These weren't an option for my config hash because it needs hash functionality, but elsewhere I found a use for Structs built from hashes, and along the way I wrote a `Hash#to_struct` method. I've pasted it [in an appendix below](#appendix-b-hashto_struct). Structs are a great option for dot access wherever your data doesn't need to remain in hash form.
- The flattened hash with composite keys (#2) is also fast, but it too wouldn't work for my present purposes because it's too far from the vanilla nested hash that I began with.
- Per-hash dot access (#4) is the fastest dot notation for a plain hash. (Note that it only works for a hash that doesn't get any new keys once it's set up, which is just fine for my config hash.) However, when applied in my project, it still made my tests run for 70% longer. Again, that's not as bad as it sounds for my sub-1-second test suite.
- But then something unexpected happened as soon as I replaced my project's calls to `fetch` with dot notation. My code looked *more messy* even though it was now *more concise*. The reason, I think, is that there was no longer a slew of (syntax-highlighted) symbols at the points where I access the config hash, and so it was a bit harder to see at a glance where config values were being used. Instead of brightly-colored symbols evenly spaced by `fetch`, my eyes now saw only a mush of method calls until my brain processed the words and told me whether that's a place where the config hash is accessed. Hmm. Now I was wondering if there was a way to keep the symbols involved, but in a more concise way than chaining `fetch` 🤔

## Dig with errors

`Hash#dig` looks nice: `hash.dig(:item, :template, :variants)`. But again, the problem is that it defaults to `nil` for nonexistent keys. What if we could make a similar method that raises a `KeyError` instead?

This has actually been proposed as an addition to Ruby several times ([1](https://bugs.ruby-lang.org/issues/15563), [2](https://bugs.ruby-lang.org/issues/14602), [3](https://bugs.ruby-lang.org/issues/12282)) with various names including `deep_fetch`, `dig!`, and `dig_fetch`. But the method seems unlikely to be added in the near future. So… let's do it ourselves!

Here are a few different implementations, with benchmarks. There are also a couple of gems for it, [dig_bang](https://github.com/dogweather/digbang) and [deep_fetch](https://github.com/pewniak747/deep_fetch), but I didn't include them here because `dig_bang` uses `reduce` (#4 below) and `deep_fetch` uses recursion, which performs the same.

1. `dig` on a hash that has had its defaults set such that it raises an error for nonexistent keys.
2. `Hash#case_deep_fetch`, which raises a `KeyError` for nonexistent keys. It's called `case_deep_fetch` because it's implemented with a simple case statement.
3. `Hash#while_deep_fetch`, similar but implemented with a `while` loop.
4. `Hash#reduce_deep_fetch`. This is the "most Ruby" implementation.

```
                           user     system      total        real
1. dig, error defaults:  0.003750   0.000000   0.003750 (  0.003750)
2. case_deep_fetch    :  0.007850   0.000000   0.007850 (  0.007856)
3. while_deep_fetch   :  0.014849   0.000000   0.014849 (  0.014852)
4. reduce_deep_fetch  :  0.027889   0.000056   0.027945 (  0.027950)
```

**Notes:**

- `reduce_deep_fetch` (#4) is the most idiomatic and flexible implementation, so it's probably what you should use.
- `while_deep_fetch` (#3) is for you if you want to ~~sell your soul~~ trade idiomatic Ruby for a bit of extra speed.
- `case_deep_fetch` (#2) throws aesthetics and flexibility *completely* out the window because it's implemented with a case statement, and it can only dig as deep as the case statement is tall. But in my project I don't foresee ever needing to dig more than four levels into a hash, so for me it's perfect 🌟 Best of all, my tests don't run any slower now than they used to. But please don't copy me. That case statement is truly ugly.

## Moral of the story

In the middle of all this, I seriously considered giving up and just going back to `fetch`, because it's the most performant and any other syntax risks making my code more cryptic to my future self. When I see `config.fetch(:item)` I know I'm dealing with a hash, unlike when I see `config.item`. But in the end I decided that `config.deep_fetch(:item, :template)` is pretty self-explanatory, and the better readability that it allows is worth the small pause that my future self might take at seeing non-standard Ruby. But it's surprising that clarity (and not performance) is what made the decision a difficult one.

Which leads into the other surprising takeaway: in this case it wasn't hard to custom-build a very performant solution for my project. So maybe I should try a DIY mindset more often, rather than immediately reaching for a gem (or ten).

In the end, maybe the real cost of my solution was in the absurd amount of time that I spent on all this benchmarking, hairsplitting, yak shaving, and bikeshedding. Enough! But I hope you've enjoyed my little adventure as much as I'm enjoying seeing it finished.

## Appendix A: `dig` on a hash with error-raising defaults

So why is this a bad idea? It comes with no performance penalty because it's just `dig` on a regular hash. What could go wrong?

The problem is that I have to modify my config hash in the beginning to give it defaults that raise a `KeyError`. Recall that I also had to modify the hash when I tried per-hash dot access (#3 in the benchmarks on dot syntax above). But this time I'm less comfortable with the modification, because this one can "slip out" in less noticeable ways.

For example, if at some point in my code the config hash is operated on in a way that creates a derived hash (e.g. by calling `map` on it and using the result), that derived hash would be a fresh new hash without the `KeyError` defaults.

That new hash might get passed around, with me thinking it's the original that has the special defaults. I might use `dig` on the hash, and `dig` would work as in any hash (without my trusty `KeyError`) without me ever knowing that anything was missing 💀

So this approach is too fragile for my liking. Plus, my future self might wonder *"Why did I use `dig` and not fetch?"* until future self re-discovers my hack.

## Appendix B: `Hash#to_struct`

This is a Refinement, which you can use by adding `using ToStruct` at the top of a class or file where you want to use it.

```ruby
# Converts a Hash to a Struct.
module ToStruct
  refine Hash do
    MEMOIZED_STRUCTS = {}

    def to_struct
      MEMOIZED_STRUCTS[keys] ||= Struct.new(*keys)
      struct_class = MEMOIZED_STRUCTS[keys]

      struct_values = transform_values { |v|
        if v.is_a?(Hash)
          v.to_struct
        elsif v.is_a?(Array) && v.all? { |el| el.is_a?(Hash) }
          v.map(&:to_struct)
        else
          v
        end
      }.values

      struct_class.new(*struct_values)
    end
  end
end
```

## Appendix C: the benchmark code

```ruby
require 'benchmark'
require 'ostruct'
require 'active_support/ordered_options'
require 'hash_dot'
require 'hashie'
require 'active_support/core_ext/object/blank'

#### SETUP

## FOR BASELINE BENCHMARKS

# regular hash
vanilla = { address: { category: { desc: "Urban" } } }

# fetch alias
class Hash
  alias_method :>, :fetch
end

## FOR DOT BENCHMARKS

# Struct
s_top = Struct.new(:address)
s_inner = Struct.new(:category)
s_innest = Struct.new(:desc)

struct = s_top.new(
  s_inner.new(
    s_innest.new(
      "Urban"
    )
  )
)

# a flattened hash with composite keys
# from https://snippets.aktagon.com/snippets/738-dot-notation-for-ruby-configuration-hash
def to_namespace_hash(object, prefix = nil)
  if object.is_a? Hash
    object.map { |key, value|
      if prefix
        to_namespace_hash value, "#{prefix}.#{key}".to_sym
      else
        to_namespace_hash value, "#{key}".to_sym
      end
    }.reduce(&:merge)
  else
    { prefix => object }
  end
end

flat = { address: { category: { desc: "Urban" } } }
flat = to_namespace_hash(flat)

def flat.[](key)
  fetch(key)
rescue KeyError
  possible_keys = keys
    .map { |x| x if x.match(/.*?#{key}.*?/i) }
    .delete_if(&:blank?).join("\n")

  raise KeyError, "Key '#{key}' not found. Did you mean one of:\n#{possible_keys}"
end

flat.freeze

# OpenStruct
ostruct = OpenStruct.new(
  address: OpenStruct.new(
    category: OpenStruct.new(
      desc: "Urban"
    )
  )
)

# per-hash dot access
def allow_dot_access(vanilla_hash)
  vanilla_hash.each do |key, value|
    vanilla_hash.define_singleton_method(key) do
      fetch(key)
    end

    allow_dot_access(value) if value.is_a?(Hash)
  end
end

my_dot = allow_dot_access({ address: { category: { desc: "Urban" } } }).freeze

# ActiveSupport::OrderedOptions
asoo = ActiveSupport::OrderedOptions.new
asoo.address = ActiveSupport::OrderedOptions.new
asoo.address.category = ActiveSupport::OrderedOptions.new
asoo.address.category.desc = "Urban"

# hash_dot gem
hash_dot = vanilla.to_dot

## FOR DEEP_FETCH BENCHMARKS

# with error defaults
def add_key_error_defaults(vanilla_hash)
  vanilla_hash.default_proc = -> (_hash, key) { raise KeyError, "key not found: :#{key}" }
  vanilla_hash.values.each do |value|
    if value.is_a? Hash
      add_key_error_defaults(value)
    end
  end
  vanilla_hash
end

errorful = add_key_error_defaults({ address: { category: { desc: "Urban" } } })

# deep_fetch implementations
class Hash
  # ewwwwwwwwwwwww
  def case_deep_fetch(key1, key2 = nil, key3 = nil, key4 = nil)
    if key4
      fetch(key1).fetch(key2).fetch(key3).fetch(key4)
    elsif key3
      fetch(key1).fetch(key2).fetch(key3)
    elsif key2
      fetch(key1).fetch(key2)
    else
      fetch(key1)
    end
  end

  def while_deep_fetch(*keys)
    hash = self
    while key = keys.shift
      hash = hash.fetch(key)
    end
    hash
  end

  def reduce_deep_fetch(*keys)
    keys.reduce(self) { |memo, key| memo.fetch(key) }
  end
end

#### BENCHMARKS

iterations = 50000

Benchmark.bm(8) do |bm|
  puts "BASELINES:"

  bm.report("1. brackets           :") do
    iterations.times do
      vanilla[:address][:category][:desc]
    end
  end

  bm.report("2. dig                :") do
    iterations.times do
      vanilla[:address][:category][:desc]
    end
  end

  bm.report("3. fetch              :") do
    iterations.times do
      vanilla.fetch(:address).fetch(:category).fetch(:desc)
    end
  end

  bm.report("4. fetch alias        :") do
    iterations.times do
      vanilla > :address > :category > :desc
    end
  end

  puts "DOT:"

  bm.report("1. Struct             :") do
    iterations.times do
      struct.address.category.desc
    end
  end

  bm.report("2. flat composite keys:") do
    iterations.times do
      flat["address.category.desc".to_sym]
    end
  end

  bm.report("3. OpenStruct         :") do
    iterations.times do
      ostruct.address.category.desc
    end
  end

  bm.report("4. per-hash dot access:") do
    iterations.times do
      my_dot.address.category.desc
    end
  end

  bm.report("5. AS::OrderedOptions :") do
    iterations.times do
      asoo.address.category.desc
    end
  end

  bm.report("6. hash_dot           :") do
    iterations.times do
      hash_dot.address.category.desc
    end
  end

  class Hash
    include Hashie::Extensions::MethodAccess
  end

  bm.report("7. hashie             :") do
    iterations.times do
      vanilla.address.category.desc
    end
  end

  puts "DEEP_FETCH:"

  bm.report("1. dig, error defaults:") do
    iterations.times do
      errorful.dig(:address, :category, :desc)
    end
  end

  bm.report("2. case_deep_fetch    :") do
    iterations.times do
      vanilla.case_deep_fetch(:address, :category, :desc)
    end
  end

  bm.report("3. while_deep_fetch   :") do
    iterations.times do
      vanilla.while_deep_fetch(:address, :category, :desc)
    end
  end

  bm.report("4. reduce_deep_fetch  :") do
    iterations.times do
      vanilla.reduce_deep_fetch(:address, :category, :desc)
    end
  end
end
```