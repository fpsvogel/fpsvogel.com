---
title: SQL and Active Record for junior Rails developers
subtitle: demystifying the database
---

- [SQL resources](#sql-resources)
  - [SQL basics](#sql-basics)
  - [SQL exercises](#sql-exercises)
  - [Deeper into SQL](#deeper-into-sql)
- [Active Record resources](#active-record-resources)
  - [Active Record features](#active-record-features)
  - [Querying](#querying)
  - [Model design and architecture](#model-design-and-architecture)

Databases are hard. A few months ago when I started learning Ruby on Rails, I had trouble shifting from a pure Ruby mindset (where I manipulate data via Ruby's lovely Enumerable methods) to an Active Record mindset (where I manipulate data from the database as part of a query and not via Enumerable methods). I also kept putting off learning SQL because it was intimidating. Instead I doubled down on Rails basics and testing. Those were great time investments, but now the time has come to learn SQL and Active Record beyond the basics.

Knowing how to use the database wisely and efficiently is one of the most important skills to learn even if you're still a beginner at Rails. If a Rails app is suffering from performance problems, there's a good chance it's because of inefficient database queries. Even tiny hobby apps can suffer from massive (as in, 30 seconds!) page load delays due to clumsy use of Active Record, as I discovered firsthand.

But this is also one of the areas where I found the least guidance, so I've compiled my favorite resources below for the benefit of any other lost souls out there. You might also want to check out [my complete list of learning resources](https://github.com/fpsvogel/learn-ruby-and-cs) on Ruby, Rails, and computer science.

SQL resources are listed first here, but that's not meant as a recommendation to become an SQL expert before learning more about Active Record. I think it's best to learn both in tandem.

## SQL resources

### SQL basics

- [Databases course](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/databases) at The Odin Project
- [SQL Teaching](https://www.sqlteaching.com) interactive tutorial
- [SQLBolt](https://sqlbolt.com) interactive tutorial
- [SQLZoo](https://sqlzoo.net/wiki/SQL_Tutorial) interactive tutorial

### SQL exercises

- [Wikibooks](https://en.wikibooks.org/wiki/SQL_Exercises)
- [w3resource](https://www.w3resource.com/sql-exercises/)
- [HackerRank](https://www.hackerrank.com/domains/sql)

### Deeper into SQL

- [Use the Index, Luke!](https://use-the-index-luke.com/sql/preface)
- [Advanced Topics in SQL](https://www.edx.org/course/advanced-topics-in-sql) course from Stanford

## Active Record resources

### Active Record features

- [The Rails Guides](https://guides.rubyonrails.org) on Active Record
- [Some nice docs](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) from the Rails API Documentation

### Querying

- [Advanced ActiveRecord Querying](https://thoughtbot.com/upcase/advanced-activerecord-querying) on Upcase
- [An upcoming course](https://twitter.com/jmcharnes/status/1499760253440860161) on Active Record

### Model design and architecture

I'm still looking for a good book or course on this, but in the meantime here are some helpful blog posts.

- [How to design and prep a Ruby on Rails model architecture](https://www.startuprocket.com/articles/how-to-design-and-prep-a-ruby-on-rails-model-architecture)
- [Ruby on Rails Model Patterns and Anti-patterns](https://blog.appsignal.com/2020/11/18/rails-model-patterns-and-anti-patterns.html)
- Posts on [Code with Jason](https://www.codewithjason.com/articles/), such as [What is a Rails model?](https://www.codewithjason.com/what-is-a-rails-model/), [How I organize my Rails apps](https://www.codewithjason.com/organize-rails-apps/), and [What to do about bloated Active Record models](https://www.codewithjason.com/bloated-rails-active-record-models/).
  - Pro tip for building PORO models: inherit [`ActiveModel::Model`](https://api.rubyonrails.org/classes/ActiveModel/Model.html) and/or [`ActiveModel::Attributes`](https://api.rubyonrails.org/classes/ActiveModel/Attributes/ClassMethods.html) if you want the conveniences of an Active Record object without actually storing it in the database.
- Do a web search for "Rails refactor fat model" if you want more blog posts along those lines.
