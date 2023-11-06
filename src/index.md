---
layout: home
---

I'm Felipe, teacher-turned-developer.

This site is where I reflect on what I'm learning and how. Usually I write about Ruby programming. You may also be interested in my ["Learn Ruby"](https://github.com/fpsvogel/learn-ruby) resource list.

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
