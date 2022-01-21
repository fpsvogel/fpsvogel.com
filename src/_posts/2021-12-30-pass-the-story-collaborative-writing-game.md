---
title: "A \"Pass the Story\" collaborative writing game"
subtitle: "lightning Rails app #3"
---

- [New things I did in this app](#new-things-i-did-in-this-app)
- [Building up testing habits](#building-up-testing-habits)
- [The verdict: will I continue work on this app?](#the-verdict-will-i-continue-work-on-this-app)

This month I've been building little apps to improve my Rails testing skills. My latest is [Story Toss](https://storytoss.herokuapp.com/), a variation on the game "Pass the Story," where each player writes a bit of a story and then passes it on the next player—in this case, any other user who wants to continue the story. [Here's the GitHub repo.](https://github.com/fpsvogel/storytoss)

Surprisingly, there is no existing app implementation of the game that I could find. There is the related site [FoldingStory](http://foldingstory.com/), but there players can't see the whole story when adding on to it, only the most recent bit. This has amusing results, but I wanted to build a game where players could make more informed decisions when continuing a story.

Also, I added a twist to the game: players can write alternative continuations to a story at any point, creating a new braching storyline. Other players can then vote on which continuation they like better, while still adding further continuations to any of the competing story branches. The story branch with the most votes becomes the one shown by default. This way, players can explore different possible outcomes of a story, and trolls can't ruin a great story by derailing it.

## New things I did in this app

- Used Turbo Frames to dynamically show a "Continue the story" form on the same page, and to dynamically update a total score after the user presses a "Like" or "Dislike" button.
- Wrote a lot more tests this time around because of the more numerous models and more complex UI.
- Put testing front and center in my development process. This is different from the last point because I could have written a lot of tests, but only as an afterthought. However, this time I consciously avoided doing that. Last time I wasn't so successful in this because I had to work around [challenging APIs](/posts/2021/wikipedia-explorer-discover-articles-like-stumbleupon#the-technical-challenge) to implement one large feature, which made it hard to test that feature until near the end when I saw that my approach had a decent chance of working. In contrast, this app is made up of many different features, making it a better training ground for building up testing habits.

## Building up testing habits

I've just finished reading Jason Swett's [Complete Guide to Rails Testing](https://www.codewithjason.com/complete-guide-to-rails-testing/). As someone who was most familiar with Minitest in pure Ruby projects, I found Jason's book to be perfect for getting up to speed with Rails testing using RSpec. It was also a great book on testing more generally, which is rare because in my experience, books on testing tend to be overwhelming. Do I really need to write six different kinds of tests?? Why would I need five different kinds of test doubles? Maybe this overabundance of categories and terminology is useful in large projects, but they're counterproductive for someone just starting out.

I love Jason's book because it's the opposite: it lays out a refreshingly simple approach that makes testing enjoyable rather than painful and confusing. I also found helpful articles on Factory Bot [antipatterns](https://semaphoreci.com/blog/2014/01/14/rails-testing-antipatterns-fixtures-and-factories.html) and [performance optimizations](https://thoughtbot.com/blog/use-factory-girls-build-stubbed-for-a-faster-test).

Thanks to my previous lightning apps, I'd already ironed out the technical details of my RSpec setup (Capybara, Factory Bot, and WebMock + VCR if necessary). So now it was time to bring it all together and make testing a central part of my development process. Previously I learned to do this in my pure Ruby projects, but not yet in my more recent Rails projects, and that's why I've been building these little apps, of which Story Toss is the third and final one. It was time for the ultimate showdown.

Against lurking bugs and their accomplice my old alter ego (let's call him Codeslinger, a cowboy who shoots balls of mud), I'm happy to say I prevailed. Using a test-centric development process, I built an app quickly and smoothly, without any long debugging sessions, without time lost to manual testing, and with much more peace of mind than I would have had otherwise. These benefits will only multiply the longer I work on the app.

Here are the testing rules of thumb that I set for myself:

1. When I add a feature, write tests for it before working on anything else.
2. Don't commit before writing tests or making sure the change is covered by existing tests. I made exceptions to this rule at the beginning and end of the project, when I was working mostly in the views and it didn't make sense to write system specs (integration tests) until after several interrelated features were finished.
3. When I'm building a model, use TDD as much as possible.

By the end of the project, these rules felt less like rules and more like just plain writing code. I didn't have to remind myself as often to write tests before committing, because the habit of testing had become a more seamless part my development process. And the more I did it, the more grateful I was that I'd done so: more than once an obscure bug came up that I found within just a few minutes, thanks to my tests. I shudder to think of the hours it might otherwise have taken me to track down those bugs.

## The verdict: will I continue work on this app?

For each of these lightning apps, I've taken a moment at the end to decide whether or not it's worth continuing as a hobby project.

I'm honestly not sure about Story Toss. I doubt I'll use it regularly myself, which is my main motivator for continuing to develop a personal project. There are lots of new features I *could* add, such as a user profile page, a user scoreboard, and AI-generated continuations to bring stale unfinished stories back to life.

In any case, I'm glad I built the app because it served as an excellent capstone project for my recent dive into Rails testing and RSpec. Now I can return to [Wiki Stumble](/posts/2021/wikipedia-explorer-discover-articles-like-stumbleupon), my favorite of the lightning app trio, and expand it following the habits I've strengthened here.
