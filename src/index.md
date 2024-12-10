---
layout: home
---

I'm Felipe Vogel, full-stack developer, Rubyist, perpetual learner.

## Recent posts

<small>[👉 See all](/posts)</small>

<ul class="posts-ul">
  <% collections.posts.resources.take(3).each do |post| %>
    <li>
      <a href="<%= post.relative_url %>">
        <posts-li-title><%= post.data.title %></posts-li-title>:
        <div>
          <posts-li-subtitle><%= post.data.subtitle %></posts-li-subtitle>
          <posts-li-date><small><%= post.date.strftime("%Y-%m-%d") %></small></posts-li-date>
        </div>
      </a>
    </li>
  <% end %>
</ul>

## My favorite posts

<% favorite_posts = %w[
  2024/early-career-developer-job-search-after-layoffs
  2023/solo-rpgs-creative-practice
  2023/why-make-a-text-based-game
] %>

<ul class="posts-ul">
  <% favorite_posts.each do |post_year_and_slug| %>
    <% post = collections.posts.resources.find { |post| post.relative_url == "/posts/#{post_year_and_slug}" } %>
    <li>
      <a href="<%= post.relative_url %>">
        <posts-li-title><%= post.data.title %></posts-li-title>:
        <div>
          <posts-li-subtitle><%= post.data.subtitle %></posts-li-subtitle>
          <posts-li-date><small><%= post.date.strftime("%Y-%m-%d") %></small></posts-li-date>
        </div>
      </a>
    </li>
  <% end %>
</ul>

## I seem to like making lists

- [Learn Ruby](https://github.com/fpsvogel/learn-ruby) <small>(and other stuff like SQL, Rails, CSS, and JS)</small>
- [Learn Computer Science and Low-Level Programming](https://github.com/fpsvogel/learn-cs)
- [Learn Roc](https://github.com/fpsvogel/learn-roc) <small>(a functional programming language)</small>
- [My favorite books](/reading) and [statistics on my reading](http://localhost:4000/reading-stats)
- [Learn Latin and Greek](https://github.com/fpsvogel/learn-latin-and-greek)
- [Solo TTRPGS](https://github.com/fpsvogel/solo-ttrpgs) <small>(Table-Top Role-Playing Games)</small>

<%# these are private, but maybe refine them and add here later:
- https://github.com/fpsvogel/words
- https://github.com/fpsvogel/coding-exercises
- https://github.com/fpsvogel/faang-interview-prep
%>

## Fun facts about me

- **I used to be a humanities teacher** in a former career that took me all the way to West Africa.
- **I grew up in Brazil** in southern Amazonia, at times living with the Jarawara indigenous people, whose village you can see [on Google Maps](https://www.google.com/maps/place/7%C2%B018'20.0%22S+65%C2%B015'36.9%22W/@-7.3056605,-65.2618449,743m/data=!3m1!1e3!4m4!3m3!8m2!3d-7.3055556!4d-65.26025?entry=ttu).
- **I'm a big Latin nerd.** In grad school, I took most of my classes in Latin and lived in the *domus Latina* (Latin house), where we spoke only Latin except when we had guests… which, as you might guess, was rare 😂
