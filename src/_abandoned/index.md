
### Recent reading

<small>[👉 See all](/reading/)</small>

<% if site.data.reading %>
  <ul>
    <% site.data.reading.take(5).each do |item| %>
      <li>
        <%= item.date_in_words %> – <%= site.config.reading.types[item.type] %> <a href="<%= item.url %>" target="_blank"><%= item.name %></a>
      </li>
    <% end %>
  </ul>
<% end %>