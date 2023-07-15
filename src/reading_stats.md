---
layout: page
title: Reading Stats
permalink: /stats/
---

These statistics refer to *all* of my reading, not just my favorites as on the "Reading List" page. This page too is built automatically with the help of my [Reading](https://github.com/fpsvogel/reading) gem.

**Contents:**

- [Most-read genres](#most-read-genres)
- [Favorite genres](#favorite-genres)
- [What I feel about each genre](#what-i-feel-about-each-genre)
- [Rating distribution](#rating-distribution)
- [Longest items](#longest-items)
- [Most annotated items](#most-annotated-items)
- [Fastest reads](#fastest-reads)

***Note:** The length of audio/visual items is converted to page counts according to my average reading speed of 35 pages per hour.*

<% stats = @site.data.reading_stats %>

## Most-read genres

Page counts of each year's top 4 genres.

<%= column_chart(stats[:top_genres_by_year], stacked: true, library: { plugins: { tooltip: { filter: ->() {} } } }) %>

## Favorite genres

Page counts of 4- and 5-star items, by genre.

<%= pie_chart(stats[:amount_by_genre_favorites], height: "480px") %>

## What I feel about each genre

Average rating by genre.

<%= bar_chart(stats[:average_rating_by_genre], height: "700px", min: 1.0, max: 5.0) %>

## Rating distribution

Item count by rating.

<%= pie_chart(stats[:rating_counts]) %>

## Longest items

Page counts of *amounts*, meaning that a re-read adds to the total.

<%= bar_chart(stats[:top_amounts]) %>

## Most annotated items

Word counts of notes.

<%= bar_chart(stats[:top_annotated]) %>

## Fastest reads

Pages per day.

<%= bar_chart(stats[:top_speeds]) %>
