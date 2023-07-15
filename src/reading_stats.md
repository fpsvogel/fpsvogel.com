---
layout: page
title: Reading Stats
permalink: /stats/
---

These statistics refer to *all* of my reading, not just my favorites as on the "Reading List" page. This page too is built automatically with the help of my [Reading](https://github.com/fpsvogel/reading) gem.

**Contents:**

- [Each year's top genres](#each-years-top-genres)
- [My favorite genres](#my-favorite-genres)
- [What I feel about each genre](#what-i-feel-about-each-genre)
- [How my ratings are distributed](#how-my-ratings-are-distributed)
- [Longest items](#longest-items)
- [Most annotated items](#most-annotated-items)
- [Fastest reads](#fastest-reads)

***Note:** The length of audio/visual items is converted to page counts according to my average reading speed of 35 pages per hour.*

<% stats = @site.data.reading_stats %>

## Each year's top genres

Page counts of each year's top 4 genres.

<%= column_chart(stats[:top_genres_by_year], xtitle: "Year", ytitle: "Pages", stacked: true, library: { plugins: { tooltip: { filter: ->() {} } } }) %>

## My favorite genres

Page counts of 4- and 5-star items, by genre.

<%= pie_chart(stats[:amount_by_genre_favorites], height: "480px") %>

## What I feel about each genre

Average rating by genre.

<%= bar_chart(stats[:average_rating_by_genre], height: "800px", min: 1.0, max: 5.0, xtitle: "Rating", ytitle: "Genre") %>

## How my ratings are distributed

Item count by rating.

<%= pie_chart(stats[:rating_counts]) %>

## Longest items

<%= bar_chart(stats[:top_amounts], xtitle: "Pages") %>

## Most annotated items

<%= bar_chart(stats[:top_annotated], xtitle: "Notes word count") %>

## Fastest reads

<%= bar_chart(stats[:top_speeds], xtitle: "Pages/day") %>
