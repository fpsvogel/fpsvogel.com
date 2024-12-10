---
layout: page
title: Posts
permalink: /posts/
---

<ul class="posts-ul">
  <% collections.posts.resources.each do |post| %>
    <li>
      <a href="<%= post.relative_url %>">
        <span><fancy-li-title><%= post.data.title %></fancy-li-title>:</span>
        <div>
          <fancy-li-subtitle><%= post.data.subtitle %></fancy-li-subtitle>
          <fancy-li-date><small><%= post.date.strftime("%Y-%m-%d") %></small></fancy-li-date>
        </div>
      </a>
    </li>
  <% end %>
</ul>
