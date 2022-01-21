---
layout: page
title: Reading
permalink: /reading/
pagination:
  collection: reading
---

My highest recommendations, updated automatically from my `reading.csv` file, my homegrown alternative to Goodreads book tracking. [Here's how I built this page.](/posts/2021/build-a-blog-with-bridgetown#3-ruby-component-and-plugin) My other favorite reading technology is Library Extension ([Chrome](https://chrome.google.com/webstore/detail/library-extension/chkgcmmjoejpekoegkedcpifgfhpjmec), [Firefox](https://addons.mozilla.org/en-US/firefox/addon/libraryextension/)).

<%= render ReadingList.new %>
