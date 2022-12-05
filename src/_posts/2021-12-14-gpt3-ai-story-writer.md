---
title: An AI story writer
subtitle: "lightning Rails app #1"
---

- [New things I did in this app](#new-things-i-did-in-this-app)
- [GPT-3](#gpt-3)
- [The verdict: will I continue work on this app?](#the-verdict-will-i-continue-work-on-this-app)
- [Appendix: example stories](#appendix-example-stories)

> It was the year 2121. It was a post-apocalyptic world. Zombies crowded around my house. One started pounding at my front door. I huddled in the corner of my living room, too terrified to move.

This is the default story starter in [Story Droid](https://github.com/fpsvogel/storydroid), a little app I built as I started reading Jason Swett's [Complete Guide to Rails Testing](https://www.codewithjason.com/complete-guide-to-rails-testing/). I needed a throwaway app where I could apply my new testing skills, and this was my first idea.

I have a couple other ideas, though, so I'm making this a three-part series on "lightning apps", so named because I built this first one in the spare hours of a single day, with minor improvements and fixes in the few days following. I'll try to do the same with the next two. In the end, I'll have built three little apps, and I'll pick one or two to expand with more features and more tests. As I build each one, I'll post on what new things I've done in each app.

## New things I did in this app

- Wrote tests in RSpec. So far I had only used Minitest.
- Set up Capybara for system tests, using [this guide](https://www.zagaja.com/2019/02/rspec-headless-chrome-capybara/).
- Used the delightful [PaperCSS](https://www.getpapercss.com/).
- Set up reCAPTCHA using the gem [new_google_recaptcha](https://github.com/igorkasyanchuk/new_google_recaptcha).
- Used OpenAI's GPT-3 API for text generation.

## GPT-3

More on that last point: recently I've been fascinated by the latest AI-powered storytelling tools. They are powered by OpenAI's GPT-3, which has written some impressive stuff:

- [Short stories](https://aiwrotethis.substack.com/)
- [Poems in the style of Shel Silverstein](http://dean.dog/shel-silverstein-gpt3/)
- [Beowulf as translated by P. G. Wodehouse](https://www.gwern.net/GPT-3#beowulf-wodehouse)
- [Entries for "A Devil's Dictionary of Science"](https://www.gwern.net/GPT-3#devils-dictionary-of-science)
- [A conversation with the AI](https://pastebin.com/ZiQJT061) where it is eerily human-like

The stories that the AI writes in my app are pretty silly compared with these, but I was pleased with the results considering the simplicity of my app. Below I include a couple of example stories from my app, but first…

## The verdict: will I continue work on this app?

No, I don't think so. OpenAI's API is free only for a limited time, and I'm not sure my use case justifies the cost, either to me or the environment (these AIs use a lot of power). Plus, there are already other apps that do the same thing but with more options, such as [Sassbook AI Writer](https://sassbook.com/ai-writer) and [AI Dungeon](https://play.aidungeon.io/main/home).

## Appendix: example stories

Here are two stories that GPT-3 wrote in my app, both using the same starting text (in bold here).

> **It was the year 2121. It was a post-apocalyptic world. Zombies crowded around my house. One started pounding at my front door. I huddled in the corner of my living room, too terrified to move.** I didn't know what to do. I was sure that I was going to die. Then, a beam of light shot down from the sky. It was an angel! The angel was wearing a white robe, and a halo was floating above his head. He was glowing like a lightbulb. He said to me, "You are the Chosen One. You are the only one who can save the world from the zombie apocalypse. You must travel to the center of the Earth and destroy the zombies' source of power. Only then will they be defeated. You must hurry, for time is running out." I was really surprised. I was just an ordinary guy, and I didn't know anything about fighting zombies. But then I remembered that I had a magic sword in my basement. I had bought it at a garage sale for just one dollar. The magic sword was the most powerful sword in the world. I was sure that it would be able to destroy the zombies' source of power. I was ready to go. I grabbed my magic sword, and I set off for the center of the Earth. It was a long journey. I didn't have a car, so I had to walk. It took me three days to get to the center of the Earth. Along the way, I had to fight zombies. It was very difficult. I had to use my magic sword to fight them. But I was able to defeat them all. Finally, I made it to the center of the Earth. There was a volcano there. I knew that it was the zombie's source of power. I climbed up the side of the volcano. I was surrounded by zombies. I was going to fight them all by myself. I was scared, but I knew that I had to do it. I climbed up to the top of the volcano. I was surrounded by zombies. I knew that I was going to die. I had to do something. I had to fight. I swung my magic sword and cut off the head of the zombie king.

My second story went a little bit off track…

> **It was the year 2121. It was a post-apocalyptic world. Zombies crowded around my house. One started pounding at my front door. I huddled in the corner of my living room, too terrified to move.** Suddenly, a loud boom echoed, and the zombie crumpled to the ground. I looked up, and saw a man standing in my doorway. He was in his 20s, and he wore a black cowboy hat and a long, iced-out chain necklace. He had a revolver in his hand. "You're safe now," he said. "I'm here to rescue you." He walked over to me, and pulled me to my feet. "What's your name?" he asked. "My name is Jill," I said. "Well, Jill, we'd better get a move on. There are more zombies out there." He took me by the hand and led me out the door. I followed him through the zombie infested neighborhood. He shot any zombie that got in our way. Finally, we reached his car. It was a shiny, black Lamborghini. "Hop in," he said. We got in the car, and he turned the key in the ignition. The engine roared. He put it into gear, and we sped off down the street. The zombies chased us, but we were too fast for them. We drove for hours and hours, until we finally reached an enormous mansion. The man got out of the car, and opened the door for me. "Welcome to my home," he said. "You'll be safe here." He took me by the hand and led me inside. Suddenly I realized who he was. "You're Batman!" I exclaimed. "That's right," he said. "I'm Batman." He took off his cowboy hat, and revealed a full head of hair. "You're Bruce Wayne, billionaire!" I said. "That's right," he said. "I'm Bruce Wayne, billionaire." He took off his necklace, and revealed that it was just a normal chain. "I don't understand," I said. "How did you get here?" "I invented a time machine and traveled forward in time to save you," he replied. "That's amazing!"
