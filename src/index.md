---
layout: home
---

I'm Felipe, teacher-turned-developer.

This site is where I reflect on my learning. Usually I write about Ruby programming. You may also be interested in my ["Learn Ruby"](https://github.com/fpsvogel/learn-ruby) resource list.

## Recent posts

<small>[👉 See all](/posts)</small>

<ul>
  <% collections.posts.resources.take(3).each do |post| %>
    <li>
      <%= post.date.strftime("%B %e") %> – <a href="<%= post.relative_url %>">
      <%= post.data.title %></a>: <%= post.data.subtitle %>
    </li>
  <% end %>
</ul>

## My favorite posts

<% favorite_posts = %w[
  2024/early-career-developer-job-search-after-layoffs
  2023/solo-rpgs-creative-practice
  2023/why-make-a-text-based-game
  2021/how-to-contribute-to-open-source-ruby-rails
  2021/build-a-blog-with-ruby-bridgetown
] %>

<ul>
  <% favorite_posts.each do |post_year_and_slug| %>
    <% post = collections.posts.resources.find { |post| post.relative_url == "/posts/#{post_year_and_slug}" } %>
    <li>
      <a href="<%= post.relative_url %>"><%= post.data.title %></a>:
      <%= post.data.subtitle %>
      <em>(<%= post.data.date.year %>)</em>
    </li>
  <% end %>
</ul>
