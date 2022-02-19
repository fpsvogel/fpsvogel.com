---
layout: home
---

I'm Felipe, a self-taught Rubyist from a humanities teaching background. See [my resume](/about) for details.

Recent wins: I [got my first developer job](/posts/2022/how-to-find-ruby-rails-job), I built [four little Rails apps](/posts/2022/doctor-lookup-health-provider-search-tool), I was [featured on a podcast](https://rubyrogues.com/bridgetown-rb-ft-felipe-vogel-ruby-526), and I'm making [my first contributions to open source](/about/#open-source-contributions).

### What I've been writing

<small>[👉 See all](/posts/)</small>

<ul>
  <% collections.posts.resources.take(3).each do |post| %>
    <li>
      <%= post.date.strftime("%B %e") %> – <a href="<%= post.relative_url %>">
      <%= post.data.title %>: <%= post.data.subtitle %></a>
    </li>
  <% end %>
</ul>
