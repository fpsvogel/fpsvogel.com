---
layout: home
---

I'm Felipe Vogel, full-stack developer, Rubyist, compulsive learner.

## Recent posts

<small>[👉 See all](/posts)</small>

<ul class="posts-ul">
  <% collections.posts.resources.take(3).each do |post| %>
    <li>
      <a href="<%= post.relative_url %>">
        <fancy-li-title><%= post.data.title %></fancy-li-title>:
        <div>
          <fancy-li-subtitle><%= post.data.subtitle %></fancy-li-subtitle>
          <fancy-li-date><small><%= post.date.strftime("%Y-%m-%d") %></small></fancy-li-date>
        </div>
      </a>
    </li>
  <% end %>
</ul>

## I seem to like making lists

<% lists = [
  ["Learn Ruby", "https://github.com/fpsvogel/learn-ruby", "and other stuff like SQL, Rails, CSS, and JS"],
  ["Books that I've enjoyed", "/reading"],
  ["MacOS/Linux/Windows apps and customizations that I use", "/posts/2025/favorite-apps-on-macos-linux-windows-ios-android"],
  ["Learn Computer Science and Low-Level Programming", "https://github.com/fpsvogel/learn-cs"],
  ["Learn Latin and Greek", "https://github.com/fpsvogel/learn-latin-and-greek"],
  ["Solo TTRPGs", "https://github.com/fpsvogel/solo-ttrpgs", "Table-Top Role-Playing Games"],
] %>

<%# these are private/archived repos, but maybe later I'll refine them and include them above:
- https://github.com/fpsvogel/learn-csharp
- https://github.com/fpsvogel/learn-java
- https://github.com/fpsvogel/learn-roc
- https://github.com/fpsvogel/words
%>

<ul class="posts-ul">
  <% lists.each do |title, url, description| %>
    <li>
      <a href="<%= url %>">
        <fancy-li-title><%= title %></fancy-li-title>
        <% if description %>
          <div>
            (<fancy-li-subtitle><%= description %></fancy-li-subtitle>)
          </div>
        <% end %>
      </a>
    </li>
  <% end %>
</ul>

## Fun facts about me

- **I used to be a humanities teacher** in a former career that took me all the way to West Africa.
- **I grew up in Brazil** in southern Amazonia, at times living with the Jarawara indigenous people, whose village you can see [on Google Maps](https://www.google.com/maps/place/7%C2%B018'20.0%22S+65%C2%B015'36.9%22W/@-7.3056605,-65.2618449,743m/data=!3m1!1e3!4m4!3m3!8m2!3d-7.3055556!4d-65.26025?entry=ttu).
- **I'm a big Latin nerd.** In grad school, I took most of my classes in Latin and lived in the *domus Latina* (Latin house), where we spoke only Latin except when we had guests… which, as you might guess, was rare 😂
