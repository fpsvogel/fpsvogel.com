---
layout: page
title: Posts
permalink: /posts/
---

<ul class="posts-ul">
  <% collections.posts.resources.each do |post| %>
    <li>
      <a href="<%= post.relative_url %>">
        <span><posts-li-title><%= post.data.title %></posts-li-title>:</span>
        <div>
          <posts-li-subtitle><%= post.data.subtitle %></posts-li-subtitle>
          <posts-li-date><small><%= post.date.strftime("%Y-%m-%d") %></small></posts-li-date>
        </div>
      </a>
    </li>
  <% end %>
</ul>
