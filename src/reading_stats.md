---
layout: page
title: Reading Stats
permalink: /reading-stats/
---

These statistics refer to *all* of my reading, not just my favorites as on the "Reading List" page. This page too is updated automatically with the help of my [Reading](https://github.com/fpsvogel/reading) gem.

**Contents:**

- [Favorite genres](#favorite-genres)
- [Most-read genres](#most-read-genres)
- [What I feel about each genre](#what-i-feel-about-each-genre)
- [Rating distribution](#rating-distribution)
- [Most re-reads](#most-re-reads)
- [Longest items](#longest-items)
- [Fastest reads](#fastest-reads)
- [Most annotated items](#most-annotated-items)

***Note:** The length of audio/visual items is converted to page counts according to my average reading speed of 35 pages per hour.*

<% stats = @site.data.reading_stats %>

## Favorite genres

Total pages read of 4- and 5-star items, by genre.

<%= pie_chart(stats[:amount_by_genre_favorites], height: "480px") %>

## Most-read genres

Total pages read of each year's top 4 genres.

<%= column_chart(stats[:top_genres_by_year], stacked: true, library: { plugins: { tooltip: { filter: ->() {} } } }) %>

## What I feel about each genre

Average rating by genre.

<%= bar_chart(stats[:average_rating_by_genre], height: "700px", min: 1.0, max: 5.0) %>

## Rating distribution

Item count by rating.

<%= pie_chart(stats[:rating_counts]) %>

## Most re-reads

Highest numbers of completed readings/listenings/watches, including the first one.

<%= bar_chart(stats[:top_experiences], library: { scales: { x: { ticks: { precision: 0 } } } }) %>

## Longest items

Page counts of *amounts*, meaning that a re-read adds to the total.

<%= bar_chart(stats[:top_amounts]) %>

## Fastest reads

Pages per day.

<%= bar_chart(stats[:top_speeds]) %>

## Most annotated items

Word counts of notes.

<%= bar_chart(stats[:top_annotated]) %>
