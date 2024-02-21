---
layout: home
---

I'm Felipe, teacher-turned-developer.

This site is where I reflect on what I'm learning and how. Usually I write about Ruby programming. You may also be interested in my ["Learn Ruby"](https://github.com/fpsvogel/learn-ruby) resource list.

## My favorite posts

<% favorites_ruby = %w[
  2021/build-a-blog-with-ruby-bridgetown
  2020/exercism-ruby-practice
  2021/how-to-contribute-to-open-source-ruby-rails
] %>

<% favorites_other = %w[
  2023/solo-rpg-creative-writing-practice
  2023/why-make-a-text-based-game
  2024/job-search-networking-for-engineers
  2022/how-to-find-ruby-rails-job
] %>

### About Ruby

<ul>
  <% favorites_ruby.each do |post_year_and_slug| %>
    <% post = collections.posts.resources.find { |post| post.relative_url == "/posts/#{post_year_and_slug}" } %>
    <li>
      <a href="<%= post.relative_url %>"><%= post.data.title %></a>:
      <%= post.data.subtitle %>
      <em>(<%= post.data.date.year %>)</em>
    </li>
  <% end %>
</ul>

### About everything else

<ul>
  <% favorites_other.each do |post_year_and_slug| %>
    <% post = collections.posts.resources.find { |post| post.relative_url == "/posts/#{post_year_and_slug}" } %>
    <li>
      <a href="<%= post.relative_url %>"><%= post.data.title %></a>:
      <%= post.data.subtitle %>
      <em>(<%= post.data.date.year %>)</em>
    </li>
  <% end %>
</ul>
