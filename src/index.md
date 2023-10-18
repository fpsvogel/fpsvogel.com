---
layout: home
---

I'm Felipe, teacher-turned-developer.

This site is where reflect on what I'm learning and how. Usually I write about Ruby programming, often with beginners in mind. See also [my "Learning Ruby" list](https://github.com/fpsvogel/learn-ruby).

### Recent posts

<small>[👉 See all](/posts)</small>

<ul>
  <% collections.posts.resources.take(3).each do |post| %>
    <li>
      <%= post.date.strftime("%B %e") %> – <a href="<%= post.relative_url %>">
      <%= post.data.title %>: <%= post.data.subtitle %></a>
    </li>
  <% end %>
</ul>
