---
title: Being laid off in 2023-2024 as an early-career developer
subtitle: when the tech industry wants to squeeze you out
description: A second-career software developer's second job search, amid waves of layoffs and a tough job market, with tips on getting interviews via job networking.
---

- [Backstory: from teacher to developer](#backstory-from-teacher-to-developer)
- [No one is safe from being laid off, and I'm not an exception](#no-one-is-safe-from-being-laid-off-and-im-not-an-exception)
- [The 6-month job search](#the-6-month-job-search)
- [My job networking by the numbers](#my-job-networking-by-the-numbers)
- [The good news](#the-good-news)
- [What's next in my career?](#whats-next-in-my-career)

Recently I wrote [an upbeat how-to on job networking](/posts/2024/job-search-networking-for-engineers). Now comes the part where I pull back the curtain and tell how the job search *really* went.

Don't worry, it's not *all* depressing. I've waited for weeks to publish this post just so that I have some good news to share at the end.

## Backstory: from teacher to developer

For context, I used to be a schoolteacher. In 2019, after a sudden move back to the U.S. from an overseas teaching position, I found myself earning a pitifully low salary of <span class="nobr">$32k/year</span> and inundated with medical bills from my wife's chronic illness.

*I didn't even enjoy my new job.* The frequent late nights spent planning and grading, the emotional drain of managing classrooms full of teenagers all day, the nagging feeling that in spite of all the effort I wasn't actually helping these kids… it was too much.

It was time for a career change.

So I quit teaching at the end of the school year, got a customer support job in the COVID-fueled e-commerce industry, and taught myself coding in the evenings and on weekends. After a year and a half, in February 2022, I got a junior developer job, and the following year I was promoted to mid-level.

Meanwhile, my salary went up and up. Here's a chart showing my gross pay since the beginning of 2020, when I was still a teacher:

<%= area_chart({
  Date.new(2020,1,1) => 32000,
  Date.new(2020,2,1) => 32000,
  Date.new(2020,3,1) => 32000,
  Date.new(2020,4,1) => 32000,
  Date.new(2020,5,1) => 32000,
  Date.new(2020,6,1) => 36000,
  Date.new(2020,7,1) => 36000,
  Date.new(2020,8,1) => 36000,
  Date.new(2020,9,1) => 36000,
  Date.new(2020,10,1) => 36000,
  Date.new(2020,11,1) => 48000,
  Date.new(2020,12,1) => 48000,
  Date.new(2021,1,1) => 48000,
  Date.new(2021,2,1) => 48000,
  Date.new(2021,3,1) => 48000,
  Date.new(2021,4,1) => 48000,
  Date.new(2021,5,1) => 48000,
  Date.new(2021,6,1) => 60000,
  Date.new(2021,7,1) => 60000,
  Date.new(2021,8,1) => 60000,
  Date.new(2021,9,1) => 60000,
  Date.new(2021,10,1) => 60000,
  Date.new(2021,11,1) => 60000,
  Date.new(2021,12,1) => 60000,
  Date.new(2022,1,1) => 60000,
  Date.new(2022,2,1) => 105000,
  Date.new(2022,3,1) => 105000,
  Date.new(2022,4,1) => 112000,
  Date.new(2022,5,1) => 112000,
  Date.new(2022,6,1) => 112000,
  Date.new(2022,7,1) => 112000,
  Date.new(2022,8,1) => 112000,
  Date.new(2022,9,1) => 112000,
  Date.new(2022,10,1) => 112000,
  Date.new(2022,11,1) => 112000,
  Date.new(2022,12,1) => 112000,
  Date.new(2023,1,1) => 112000,
  Date.new(2023,2,1) => 112000,
  Date.new(2023,3,1) => 112000,
  Date.new(2023,4,1) => 124000,
  Date.new(2023,5,1) => 124000,
  Date.new(2023,6,1) => 124000,
  Date.new(2023,7,1) => 124000,
  Date.new(2023,8,1) => 124000,
  Date.new(2023,9,1) => 124000,
  Date.new(2023,10,1) => 124000,
  Date.new(2023,11,1) => nil,
  Date.new(2023,12,1) => nil,
  Date.new(2024,1,1) => nil,
  Date.new(2024,2,1) => 90000,
  Date.new(2024,3,1) => 90000,
  Date.new(2024,4,1) => 124000,
}, curve: false, points: false, prefix: "$", thousands: ",", height: "480px", library: { scales: { x: { ticks: { maxTicksLimit: 7 } } } }) %>

Did you notice the gap near the end? That's the story of this post.

## No one is safe from being laid off, and I'm not an exception

In early 2023, my company had a 19% RIF (reduction in force, i.e. layoffs). Of my cohort of four junior developers that had joined the previous year, I was the only one who wasn't laid off.

I was shaken, but also bolstered in my belief that *I'm special*. I felt I was a great developer, and that would keep me safe from being laid off.

Fast forward to November, and… **I was laid off**. The immensity of this second round (44% RIF) was some consolation in that I didn't feel singled out. But at the same time, I felt uneasy seeing how all of my former junior colleagues were *still* looking for a new role after so many months. Plus, I'd actually started applying for jobs two months earlier because I saw the layoffs coming, and I'd gotten *no responses* from dozens of applications.

Still, I clung to the belief that *I'm special* and I'd have an easy time finding another job now that I could make my job search public and fully focus on it. After all, my previous job search in 2021 had been pretty easy, and that was when I had zero professional experience as a developer. How hard could it be this time?

I was in for a big disappointment.

## The 6-month job search

It was rough. Here are some low points:

- 🦗 **The crickets chirping.** For the first *three months*, I applied to dozens of jobs and got **zero** responses. That's a whole month after my job search went public. Then I started job networking, following a process [that I posted about previously](/posts/2024/job-search-networking-for-engineers).
- 😐 **Insane levels of competition.** I experienced a new level of job market saturation when I was rejected near the end of an interview process because a candidate with 16 years of experience was chosen instead… *for a mid-level role* at a company that also had open senior positions.
- 🤦 **Nonsensical skill requirements.** One final interview was a surprise live coding exercise covering React. But here's the thing: *this was for a back-end role!* That caught me off guard, and I didn't do well in the exercise.
- 😵‍💫 **So many hours spent on take-home assignments.** We all know that the "2-3 hours" in a take-home assignment description means about five times that much. Once, I spent 20 hours on an exercise, between the take-home portion and live coding prep. (If you're wondering *"Huh? Live coding prep?"* it's because, unusually, they sent me the live coding exercise ahead of the interview. But it was also an unusually complex live coding exercise.)
  - Not to digress too much, but **why are take-home assignments so long?** Why doesn't a bit of (no-prep!) live coding suffice? For example, I remember an interview process in my 2021 job search that didn't have any take-home assignment, only a live coding interview. It was a simple exercise building a CLI hangman game. The requirements were minimal and I didn't even have to finish it—the interviewer just wanted to see my thinking process, and it was very conversational. After about 15 minutes he stopped me, reiterated a few things I'd done that he liked, and said he'd be in touch. *And that was it.* I really appreciated that the interviewer *knew what he was looking for* and *knew how to spot it quickly*.
- 💀 **Lowering my bar down, down… nope, lower.** In January, about five months after I'd first started searching, I accepted a job that paid significantly less than my previous salary. Not only that, but the interview process had given me all kinds of red flags, including very mixed Glassdoor reviews and the hiring manager saying that promotions and raises were on hold indefinitely. I took the job anyway because I had no idea how many more months it would take for me to get an offer from a different company, and I wanted to prevent the worst-case scenario of my savings running out. Meanwhile, I kept looking on the down-low—I had to immediately go silent on LinkedIn because my new employer made it clear to me that they didn't want me posting there anymore 🙄 Fortunately, I soon found a better job. (More on that below.)

## My job networking by the numbers

Backing up a little bit, **job networking** is what turned the tide and helped me start getting interviews. I described my process [in a previous post](/posts/2024/job-search-networking-for-engineers), and now I can share more on the results.

I applied for 18 roles that I networked for, i.e. where I didn't submit a cold application. These were mostly in December and January, months 4 and 5 in the 6-month search. The networking that I did can be divided into three broad types (which you can see represented visually further down, if you want to skip the verbiage):

- **Existing connections:** I already had a connection in the company, first- or second-degree.
  - Of 10 attempts, I got 6 recruiter screenings, and in 3 of those I got more interviews.
- **LinkedIn messaging:** I tried forming a new connection by messaging a stranger via InMail on LinkedIn.
  - Of 7 attempts, only one led to a recruiter screening and then further interviews. But surprisingly, I only twice got no response; people were surprisingly willing to talk to a random stranger like me, and twice I got a referral.
- **Third-party recruiter:** I applied for one job through Brian at [Mirror Placement](https://www.mirrorplacement.com/), and it led to a recruiter screening and a further interview. Besides that one role, Brian said he didn't have anything for an early-career developer like me. But I enjoyed working with Brian, so I'll definitely talk to him again in the future when I have more years of experience.

In total, of these 18 attempts, 8 got me a recruiter screening, and in 5 of those I went on to further interviews. Two of these led to job offers: the one I accepted early out of caution, and the one for my current role. Here's all of the above visualized in a diagram built with [SankeyMATIC](https://sankeymatic.com):

![My 2023-2024 job search visualized in a Sankey diagram](/images/2023-job-search-results.svg)

I should also mention that cold applications yielded a grand total of ***one*** recruiter screening, after which I was ghosted by the recruiter. I cold-applied to **over a hundred jobs**, so that's a pretty terrible success rate. Granted, most of those applications were low-effort and done only to satisfy my state's unemployment requirements, but there was a sizable minority into which I put genuine effort, including painstaking answers to *"Why are you applying?"*-type questions, and even a few cover letters.

Just for fun, here is the above diagram with cold applications added in:

![My 2023-2024 job search visualized in a Sankey diagram, this time including a huge segment representing cold applications](/images/2023-job-search-results-full.svg)

By the way, this contrasts starkly with my last job search in 2021. It's funny to look back at my blog post about it, where [I wrote](/posts/2022/how-to-find-ruby-rails-job#my-job-search-a-birds-eye-view):

> Over two months, I applied to seven companies, most of them startups. I got a first-step interview or recruiter screening at six of those companies, and in five of them I moved forward to next steps.

The crazy part is that those were all cold applications 😳

Unless I was an incredible candidate back then in a way that I now fail to recall (or recreate), clearly the job market has changed *a lot* since two years ago.

<%# moved here from my notes, for permanence:
- REFERRALS:
  - Justworks - screen
  - Doximity - interview
  - CoverMyMeds - offer 🎉
  - StitchFix - nope
  - Shopify - nope
  - VCS - nope
  - Booz Allen Hamilton - screen
  - Parachute Health - screen
  - Kin - offer 🎉
  - ClearWater - ghosted before screen
- RECRUITER:
  - TripleSeat - interview
- LINKEDIN MESSAGE:
  - Pathstream - convo
  - Aha! - convo
  - CommonLit - no response
  - Labguru - no response
  - Mixlab - final interview
  - ID.me - convo
  - CodeCademy - referral
- COLD APP:
  - ThreeFlow - ghosted after screen
%>

## The good news

Enough with the doom and gloom. I'm happy to announce that I got a job at [Kin Insurance](https://www.kin.com/) as a full-stack Rails developer.

Now I can finally stop job hunting, and focus on progressing my career in more productive ways.

## What's next in my career?

- **Getting into the community.** Recently I was accepted as a [Ruby Central Scholar](https://rubycentral.org/scholars_guides_program/), meaning I'll give a short talk at RailsConf 🎉 I'm also co-organizing a local Ruby meetup, [Bluegrass Ruby](https://bluegrassruby.club/).
- **Less overtime, more family time.** At my last job, I often worked long days in order to get a lot done and impress my peers. You can see that reflected in [my glowing LinkedIn recommendations](https://www.linkedin.com/in/fpsvogel/details/recommendations/) from former colleagues—which, sadly, I'm not sure even made a difference in my job search. In any case, I'll be sticking more to a 40-hour work week because the past few months have made me re-examine my priorities, especially in light of the fact that I have a 9-month-old kid.
- **More "me time" too.** I've also missed resting and investing in my own things, whether spiritual practices or just-for-fun programming projects like [updating Ruby Warrior](https://github.com/fpsvogel/ruby-warrior-2). Honestly, I'm going to have a harder time with this than anything else on this list, but I know it's important for my mental health.
- **More consistent learning.** The job search also gave me a chance to get back to [my Ruby/web development learning roadmap](https://github.com/fpsvogel/learn-ruby). I realized that at my last job, I wasn't consistently spending time improving my skills, outside of whatever I might (if I was lucky) be learning in work projects. It's just **hard** to fight against the pressure of the day-to-day work. The approach that I'll try this time around is to take a step back and focus on something I'm *really* interested in, regardless of immediate applicability, and right now that's [learning functional programming](https://github.com/fpsvogel/learn-functional-programming).
