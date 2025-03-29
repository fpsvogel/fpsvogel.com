---
title: "Doctor Lookup"
subtitle: "lightning Rails app #4"
description: How I built a Ruby on Rails throwaway app for learning purposes, a doctor search tool.
---

- [A test-centered approach, as usual](#a-test-centered-approach-as-usual)
- [New things I did in this app](#new-things-i-did-in-this-app)
- [Wrangling the API, part 1: getting a list of specialties](#wrangling-the-api-part-1-getting-a-list-of-specialties)
- [Wrangling the API, part 2: searching by entire specialty](#wrangling-the-api-part-2-searching-by-entire-specialty)
- [Conclusion](#conclusion)

*UPDATE: A kind reader has pointed out that searching by specialty no longer returns any results. I dug into it a bit and found that the rules of the NPI API has changed in ways that I don't understand. [A query specifying only the specialty](https://npiregistry.cms.hhs.gov/api/?taxonomy_description=Family%20Medicine&version=2.1) works, but [a query with an added parameter](https://npiregistry.cms.hhs.gov/api/?enumeration_type=NPI-1&taxonomy_description=Family%20Medicine&version=2.1) to limit results to individuals (as opposed to organizations) doesn't work anymore. [A query with specialty and other parameters](https://npiregistry.cms.hhs.gov/api/?taxonomy_description=Family%20Medicine&first_name=John&last_name=Smith&version=2.1) also doesn't work anymore. I don't see any clues about this change on [the API's help page](https://npiregistry.cms.hhs.gov/api-page). Hmm… life beckons, so I'm going to leave this as an exercise for the reader 😂*

Last month I built three little apps to improve my Rails testing skills. As part of a job application, I've now built a fourth: [Doctor Lookup](https://github.com/fpsvogel/doctorlookup), a tool for finding doctors and other healthcare providers in the U.S.

Before I get more into Doctor Lookup, here are my posts on last month's little apps:

- [A "Pass the Story" collaborative writing game](/posts/2021/pass-the-story-collaborative-writing-game)
- [A StumbleUpon-style Wikipedia explorer](/posts/2021/wiki-stumble-wikipedia-explorer)
- [An AI story writer](/posts/2021/gpt3-ai-story-writer)

## A test-centered approach, as usual

As I built Doctor Lookup, I followed the same basic process from last month's lightning apps. Here is that process, in a nutshell:

- Test my code as I write it, not as an afterthought. I used RSpec and wrote model and system specs.
- Use a minimalist CSS framework to speed up front-end development. This time I used [Pico](https://picocss.com/).
- Avoid using the database if it's not necessary, just to keep things simple. In this case I did forgo the database, because the important features of a lookup tool don't require users or other persisted models. (The search results are shown dynamically with Turbo Streams, without the need to store them between requests.)

## New things I did in this app

- Mixed `ActiveModel::Model` and `ActiveModel::Attributes` into a PORO model to give it ActiveRecord-like behavior, so that I can validate input entered into the search form and show form errors, even though I'm not creating a record in the database.
- Wrote a [Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) to DRY up some models.
- *Almost* solved a CSS problem that I occasionally run into, namely converting a hex color variable into RGB format (in order to set its opacity). The solution is [relative CSS colors](https://blog.jim-nielsen.com/2021/css-relative-colors), and it's coming soon to a browser near you.
- Used Turbo Streams to show results dynamically, as I mentioned above. I've used Stimulus and Turbo Frames in previous projects, so now I'm familiar with each major piece of Hotwire.

## Wrangling the API, part 1: getting a list of specialties

I've learned that working with APIs often means working *around* them, and this was no exception. Doctor Lookup uses the [NPI API](https://npiregistry.cms.hhs.gov/registry/help-api), which I found to be mostly convenient but troublesome in a few areas. First I noticed that the API sometimes returns duplicate addresses that need to be merged, then I had to implement a gender filter apart from the API (because it does not provide a `gender` parameter).

But the biggest, nastiest shortcomings of the API by far are related to taxonomy descriptions, a.k.a. specialties. Usually when someone is looking for a doctor, they're looking for a specific type of doctor, so I think it's important to have a "Specialty" field in the app's search form.

At first glance, this seemed straightforward to implement. The API takes a `taxonomy_description` parameter, one or more search terms that it attempts to match with the description of a taxonomy code, which signifies a particular specialty of medical practice. Since the API doesn't require an exact match, technically it would work for the user to simply type in their best guess at a specialty that the API would recognize. However, the average user would probably want some guidance on what the specialties actually are, so ideally the user could choose from and/or type into a hybrid text/select field. I found that UI element ready-made in [Selectize](https://selectize.dev/demos/2015/01/01/single-item-select/).

Side note: given a bit more time, I would improve on the UI by making multi-select possible. This would be useful because a user might want to search for doctors in any of several related specialties. I could make a multi-select field in one of two ways:

- Selectize actually has a multi-select mode, but only one option ever comes through in the form data. So I would need to find a way to hook into the form submission event, grab all the selected items from the Selectize API, and insert them into the data to be submitted.
- Build it from scratch [using Hotwire](https://thoughtbot.com/blog/hotwire-typeahead-searching) or (more suitably, perhaps) by [building a web component](https://www.fullstackruby.dev/fullstack-development/2022/01/04/how-ruby-web-components-work-together/).

*UPDATE, June 2022: There are more modern alternatives to Selectize that I missed before, which now would be my first choice: [Tom Select](https://tom-select.js.org/) (for which someone has written [a Stimulus wrapper](https://gist.github.com/tabishiqbal/dc78239aa5b81b257db0633ace75ecc0)), [Slim Select](https://slimselectjs.com/), and [Choices](https://github.com/Choices-js/Choices).*

My dreams of multi-select aside, I now had a working searchable dropdown box. That was the easy part. The hard part was populating it with a list of all the specialties, which, as it turns out, the API does not provide.

The next best thing would be to download the list manually, but there too I ran into problems. There is an up-to-date CSV file provided on [this page](https://nucc.org/index.php/code-sets-mainmenu-41/provider-taxonomy-mainmenu-40/csv-mainmenu-57), but its descriptions are not quite the same as the descriptions given by the API. For example, the API has a taxonomy code with the description "Nurse Practitioner Psych/Mental Health", but this same entry in the CSV file is described as "Nurse Practitioner" → "Psychiatric/Mental Health" (in two separate columns, and more importantly the second column does not have the "Psych" abbreviation). [The web directory of taxonomy codes](https://taxonomy.nucc.org/) has this same problem.

Onto the third best solution: find a different web directory that shows the same descriptions as in the API, and then scrape all the descriptions from there. Fortunately [there is such a site](https://opennpi.com/taxonomy/363LP0808X), and before long I'd scraped up a list of taxonomy descriptions in exactly the same form as they appear in the API.

## Wrangling the API, part 2: searching by entire specialty

I thought the worst of it was behind me, but it was then that I noticed another unfortunate limitation of the API. A taxonomy description in the API results, such as "Nurse Practitioner Psych/Mental Health," contains both the classification (Nurse Practitioner) and specialization (Psych/Mental Health), as I discovered by observing the columns in the CSV mentioned above. But the `taxonomy_description` search parameter is the classification *or* specialization, not both combined (as in the results).

In other words, if I'm looking for nurse practitioners who work in mental health, then I'm out of luck as far as the API is concerned. I can search for "Nurse Practitioner" and get results of any kind of nurse practitioner, or I can search for "Psych/Mental Health" and get results of any kind of health worker in mental health (not just nurse practitioners). But if I search for "Nurse Practitioner Psych/Mental Health," then I get no results back.

Here's the workaround I came up with. When the user searches by a specialty that is just a classification (such as "Nurse Practitioner"), then the app simply passes that along to the API. But when a classification *and* and a specialization are both specified, then the app follows this process:

1. Do a preliminary pair of API calls, one specifying the classification and the other specifying the specialization. Of these two searches, mark the one that returns the most results that we're looking for. To use our example from before, if there are more nurse practitioners working in mental health returned in a search for "Psych/Mental Health" than in a search for "Nurse Practitioner," then the app will decide that searching for "Psych/Mental Health" is more effective.
2. Using that more effective approach, the app then does a larger-than-normal search and filters out all extraneous results. In our example, all results are filtered out that do not have the specialty "Nurse Practitioner Psych/Mental Health."

Because of these extra steps, there's a slight delay in searches where the selected specialty has a specialization, but the payoff is that users will now see only results with the specialty that they asked for, something that the API alone can't do.

Of course, I *could* have just left the "Specialty" field as a text box and called it a day, using the default behavior of the API. Then I wouldn't have had to do all that extra work, and this blog post would be much shorter. But that would have been just too confusing for the user, from start to finish. If the user were to see a "Specialty" text field, they would inevitably wonder, "What exactly can I write in there?" And if the user typed in something that the API couldn't match with any actual specialties, the user would get no results back, and they would also get frustrated.

I wanted to avoid this minefield of confusion and frustration for the user, and that's why I set out to implement the text/select field for specialties. The end result is much more usable than a plain text field, so I feel that the extra work was not in vain.

## Conclusion

You may be wondering, "Why did this guy spend so many hours on a programming exercise for a job application? Ew." Yeah, I know that a lot of developers don't like it when companies ask job applicants to do a programming exercise. In a few years when I have more experience and a busier home life, I will probaby join the chorus of naysayers. But for now I'm taking each exercise as a learning opportunity. In this case I even get to put another completed project on my resume.

I don't imagine I'll continue working on Doctor Lookup—after all, there are already plenty of good ways out there to find doctors. But I'm still glad I built it. Not only did I manage to get around some gnarly API limitations, but I also learned a few new tricks that I'll take back to my more long-term projects.
