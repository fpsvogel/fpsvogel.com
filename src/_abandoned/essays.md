---
layout: page
title: Essays
permalink: /essays/
pagination:
  collection: essays
---

<ul class="posts-ul">
  <% paginator.resources.each do |post| %>
    <li>
      <a href="<%= post.relative_url %>">
        <posts-li-title>
          <%= post.data.title %>
        </posts-li-title>
        <posts-li-subtitle>
          <%= post.data.subtitle %>
        </posts-li-subtitle>
        <posts-li-date>
          <small><%= post.date.strftime("%Y-%m-%d") %></small>
        </posts-li-date>
      </a>
    </li>
  <% end %>
</ul>
