---
title: Dot notation for Ruby hashes
subtitle: a tale of two syntaxes, or there and back again
---

- [The contenders](#the-contenders)
- [The numbers](#the-numbers)
- [Usability concerns](#usability-concerns)
- [Moral of the story](#moral-of-the-story)
- [Appendix: the benchmark code](#appendix-the-benchmark-code)

Recently I heard about this convenient feature of [Elixir maps](https://hexdocs.pm/elixir/Map.html):

> To access atom keys, one may also use the `map.key` notation. Note that `map.key` will raise a `KeyError` if the `map` doesn't contain the key `:key`, compared to `map[:key]`, that would return `nil`.

Nice! This is something I've been wishing for in Ruby. In a current project I have a configuration hash that is passed around and used in a variety of objects. The hash is quite large and several levels deep, so my code abounds with chains of `Hash#fetch` such as `config.fetch(:item).fetch(:template).fetch(:variants)`.

(The reason I do this instead of `config[:item][:template][:variants]` is that the `KeyError` raised by `fetch` in case of a missing key is more helpful than the `nil` that results from the regular square bracket syntax of `Hash#[]`. In fact, that `nil` could cause a major debugging headache if it results in an error somewhere else far from where the `nil` originated.)

In place of those `fetch`es, what if I could instead write `config.item.template.variants`, with an error being raised for any missing keys? Then I would have the same safety net but with a more concise syntax.

There are a number of ways to add this dot notation to a Ruby hash—this is Ruby after all, where anything is possible. The question is, can this be done without a significant performance penalty? Let's find out!

## The contenders

In my benchmarks, I tested the speed of accessing a hash (or hash-like object) in the following ways:

1. Default notation as a baseline, e.g. `hash[:address][:category][:desc]`.
2. Faux dot notation by flattening a hash and giving it composite keys, as in `config[:"item.template.variants"]`. I copied this approach [from here](https://snippets.aktagon.com/snippets/738-dot-notation-for-ruby-configuration-hash), with the main difference that I use symbols as keys because they are more performant than strings. Note that in this approach, `Hash#[]` is overridden to use `fetch`.
3. Chained `fetch`, e.g. `hash.fetch(:address).fetch(:category).fetch(:desc)`.
4. Dot notation through an OpenStruct, which is sometimes suggested in these sorts of conversations. Its fatal flaw, for my purposes, is that it does not raise an error for a nonexistent attribute (like the `KeyError` from `fetch`) but instead returns `nil`. Still, I was curious about OpenStruct's performance.
5. Dot notation by augmenting a single hash with methods corresponding to its keys.
6. Dot notation through [ActiveSupport::OrderedOptions](https://api.rubyonrails.org/classes/ActiveSupport/OrderedOptions.html).
7. Dot notation through the [hash_dot](https://github.com/adsteel/hash_dot) gem. Also, my benchmark code is based on [the benchmarks in hash_dot's README](https://github.com/adsteel/hash_dot#benchmarks).
8. Dot notation through the [Hashie](https://github.com/hashie/hashie#methodaccess) gem.
9. A shorter `fetch` alias: `hash.f(:address).f(:category).f(:desc)`. Because why not.

## The numbers

Here are the benchmark results. The benchmark code is at the end of this post.

```
                           user     system      total        real
1. default notation   :  0.003332   0.000000   0.003332 (  0.003332)
2. flat composite keys:  0.003715   0.000000   0.003715 (  0.003715)
3. fetch              :  0.005093   0.000000   0.005093 (  0.005094)
4. fetch alias        :  0.005150   0.000000   0.005150 (  0.005152)
5. OpenStruct         :  0.009731   0.000000   0.009731 (  0.009772)
6. per-hash dot access:  0.015300   0.000000   0.015300 (  0.015304)
7. AS::OrderedOptions :  0.070637   0.000000   0.070637 (  0.070640)
8. hash_dot           :  0.163008   0.000000   0.163008 (  0.163076)
9. hashie             :  0.163450   0.000000   0.163450 (  0.163451)
```

Notes:
- Keep in mind that I measured only access (reading) performance, not initialization or writing.
- Flattened composite keys (#2) are slightly faster than chained `fetch` because each access involves only one `fetch`.
- Chained calls to `fetch` (#3) are slower than the default notation here in the benchmarks, but my project's test suite does not run any faster when I replace all calls to `fetch` with square brackets. Benchmarks don't always reflect real-life performance.
- Even though the `fetch` alias (#4) is just as fast as `fetch` itself in the benchmarks, my project's test suite took 20% longer to run when I replaced all calls to `fetch` with an alias. Again, benchmarks don't tell the whole story.
- Per-hash dot access (#6) is the fastest true dot notation for a hash, but when applied in my project, it still made my test suite run for 70% longer. My project involves a lot of data processing, and config hashes are accessed many times.

If your response to that last point is to wonder why the config hash is accessed so often, my answer is that I *could* cache config values and access the config hash less often, but so far I haven't seen the need to do this because, as I mentioned, my current approach of chaining `fetch` is in real life just as fast as regular hash notation. Besides, my entire test suite takes well under one second to run, so it would be a bad tradeoff to introduce noticeable complexity for an unnoticeable bit of extra performance.

*Wow, this whole time we've been talking about real-life performance penalties of only milliseconds? Then why does any of this matter at all?*

That's a fair point. But even when the performance cost is small, I want to be aware of it. Also, dot notation has some usability downsides for me which, when combined with the small performance penalty, made me reconsider whether I wanted it in my project.

## Usability concerns

- Some approaches to dot notation involve more annoying setup than others, and/or significant limitations. For example, the flattened hash with composite keys is super fast, but it's far from the vanilla nested hash that I began with. This makes certain hash operations more complicated, such as iterating over hash keys. For my purposes it's not worth the headache.
- Per-hash dot access was for me the least annoying approach, and still quite fast. Note that it only works for a hash that does not get any new keys once it's set up, which is just fine for my config hash.
- But then something unexpected happened as soon as I replaced my project's calls to `fetch` with dot notation. My code looked *more messy* even though it was now *more concise*. The reason, I think, is that there was no longer a slew of (syntax-highlighted) symbols at the points where I access the config hash, and so it was a bit harder to spot where config values were being accessed. Instead of brightly-colored symbols evenly spaced by `fetch`, my eyes now saw only a mush of method calls, until my brain processed the words and told me whether that's a place where the config hash is accessed. Hmm. Now I was wondering if there was a way to keep the symbols involved, but in a more concise way than chaining `fetch`.
- That's when I thought of making a shorter alias for `fetch`. I knew it was probably not worth it to save just four characters on each call, because there would be a slight performance penalty and (more importantly) anyone else who looks at my code will be confused about what `config.f` means—not that anyone else is likely to read my code in this personal project, but my future forgetful self is equally in danger here. Still, I was curious about the performance hit and that's why I included it in the benchmarks.
- With a `fetch` alias off the table, the next logical step was… `fetch`.

## Moral of the story

So I've circled back to `fetch`, exactly where I started. It's not only as performant as can be, but it's also easy to read in a way that I didn't appreciate before. Plus, any other syntax would have risked making my code more cryptic to my future self. When I see `config.fetch(:item)` I know I'm dealing with a hash. But when I see `config.item` I can't be completely sure what `config` is, unless it's fresh in my memory.

Sometimes the best way to appreciate home is to travel for a while. Still, I'm glad I went on this little expedition, if only to put to rest the syntax envy that would have bugged me for ages.

## Appendix: the benchmark code

```ruby
require 'benchmark'
require 'ostruct'
require 'hash_dot'
require 'active_support/ordered_options'
require 'hashie'
require 'active_support/core_ext/object/blank'

#### SETUP

# 1. regular hash
vanilla = { address: { category: { desc: "Urban" } } }

# 7. hash_dot gem
hash_dot = vanilla.to_dot

# 4. fetch alias
class Hash
  alias_method :f, :fetch
end

# 5. OpenStruct
ostruct = OpenStruct.new(
  address: OpenStruct.new(
    category: OpenStruct.new(
      desc: "Urban"
    )
  )
)

# 7. ActiveSupport::OrderedOptions
asoo = ActiveSupport::OrderedOptions.new
asoo.address = ActiveSupport::OrderedOptions.new
asoo.address.category = ActiveSupport::OrderedOptions.new
asoo.address.category.desc = "Urban"

# 6. per-hash dot access
def allow_dot_access(vanilla_hash)
  vanilla_hash.each do |key, value|
    vanilla_hash.define_singleton_method(key) { fetch(key) }
    if value.is_a?(Hash) then allow_dot_access(value); end
  end
end

my_dot = allow_dot_access({ address: { category: { desc: "Urban" } } }).freeze

# 2. a flattened hash with composite keys
# from https://snippets.aktagon.com/snippets/738-dot-notation-for-ruby-configuration-hash
def to_namespace_hash(object, prefix = nil)
  if object.is_a? Hash
    object.map do |key, value|
      if prefix
        to_namespace_hash value, :"#{prefix}.#{key}"
      else
        to_namespace_hash value, :"#{key}"
      end
    end.reduce(&:merge)
  else
    { prefix => object }
  end
end

flat = { address: { category: { desc: "Urban" } } }
flat = to_namespace_hash(flat)

def flat.[](key)
  fetch(key)
rescue KeyError => e
  possible_keys = keys.map { |x| x if x.match /.*?#{key}.*?/i }.delete_if(&:blank?).join("\n")
  raise KeyError, "Key '#{key}' not found. Did you mean one of:\n#{possible_keys}"
end

flat.freeze

#### BENCHMARKS

iterations = 50000

Benchmark.bm(8) do |bm|
  bm.report("1. default notation   :") do
    iterations.times do
      vanilla[:address][:category][:desc]
    end
  end

  bm.report("2. flat composite keys:") do
    iterations.times do
      flat[:"address.category.desc"]
    end
  end

  bm.report("3. fetch              :") do
    iterations.times do
      vanilla.fetch(:address).fetch(:category).fetch(:desc)
    end
  end

  bm.report("4. fetch alias        :") do
    iterations.times do
      vanilla.f(:address).f(:category).f(:desc)
    end
  end

  bm.report("5. OpenStruct         :") do
    iterations.times do
      ostruct.address.category.desc
    end
  end

  bm.report("6. per-hash dot access:") do
    iterations.times do
      my_dot.address.category.desc
    end
  end

  bm.report("7. AS::OrderedOptions :") do
    iterations.times do
      asoo.address.category.desc
    end
  end

  bm.report("8. hash_dot           :") do
    iterations.times do
      hash_dot.address.category.desc
    end
  end

  class Hash
    include Hashie::Extensions::MethodAccess
  end

  bm.report("9. hashie             :") do
    iterations.times do
      vanilla.address.category.desc
    end
  end
end
```