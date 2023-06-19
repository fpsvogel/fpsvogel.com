---
layout: home
---

I'm Felipe, a self-taught Rubyist who used to be a humanities teacher.

Take a look at [my "Learning Ruby" list](https://github.com/fpsvogel/learn-ruby) if you're an aspiring developer and/or interested in Ruby. Helping other beginners is also a goal of my blog here, but it's equally a place where I reflect on what and and how I'm learning.

### Recent posts

<small>
  <a href="/posts" style="text-decoration: none">
    👉 See all
  </a>
</small>

<ul>
  <% collections.posts.resources.take(3).each do |post| %>
    <li>
      <%= post.date.strftime("%B %e") %> – <a href="<%= post.relative_url %>">
      <%= post.data.title %>: <%= post.data.subtitle %></a>
    </li>
  <% end %>
</ul>
