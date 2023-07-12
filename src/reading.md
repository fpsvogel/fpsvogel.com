---
layout: page
title: Reading
permalink: /reading/
pagination:
  collection: reading
---

My highest recommendations, updated automatically from my `reading.csv` file, my homegrown alternative to Goodreads book tracking. [Here's how I built this page.](/posts/2021/build-a-blog-with-bridgetown#2-ruby-component-and-plugin) You may also be interested in my [Learning Ruby](https://github.com/fpsvogel/learn-ruby-and-cs) list of resources.

<%= line_chart({"2021-01-01" => 2, "2021-01-02" => 3}) %>

<%= render ReadingList.new %>
