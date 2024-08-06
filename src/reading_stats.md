---
layout: page
title: Reading Stats
permalink: /reading-stats/
---

This page is updated automatically with the help of my [Reading](https://github.com/fpsvogel/reading) gem, which parses my `reading.csv` file and queries it for statistics.

**Contents:**

- [Favorite genres](#favorite-genres)
- [Genres by year](#genres-by-year)
- [What I feel about each genre](#what-i-feel-about-each-genre)
- [Rating distribution](#rating-distribution)
- [Most re-reads](#most-re-reads)
- [Longest items](#longest-items)
- [Most annotated](#most-annotated)
- [Fastest reads](#fastest-reads)

***Note:** The length of audio/visual items is converted to page counts according to my average reading speed of 35 pages per hour.*

<% stats = @site.data.reading_stats %>

## Favorite genres

Total pages read of 4- and 5-star items, of genres with over 1000 pages.

<%= pie_chart(stats[:amount_by_genre_favorites], id: "chart-favorite-genres", height: "480px") %>

## Genres by year

Total pages read of each year's top 4 and other genres.

<%= column_chart(stats[:genres_by_year].map { |genre, year_counts| { name: genre, data: year_counts, dataset: { skipNull: true } } }, id: "chart-most-read-genres", stacked: true, library: { plugins: { tooltip: { mode: "point" } } }, height: "600px") %>

## What I feel about each genre

Average rating by genre.

<%= bar_chart(stats[:average_rating_by_genre], id: "chart-rating-by-genre", height: "700px", min: 1.0, max: 5.0) %>

## Rating distribution

Item count by rating.

<%= pie_chart(stats[:rating_counts], id: "chart-rating-distribution") %>

## Most re-reads

Highest numbers of completed readings/listenings/watches, including the first one.

<%= bar_chart(stats[:top_experiences], id: "chart-most-rereads" , library: { scales: { x: { ticks: { precision: 0 } } } }) %>

## Longest items

For podcasts and other items of undefined length, I count the amount that I've consumed so far.

<%= bar_chart(stats[:top_lengths], id: "chart-longest-items" ) %>

## Most annotated

Word counts of notes.

<%= bar_chart(stats[:top_annotated], id: "chart-most-annotated" ) %>

## Fastest reads

Pages per day.

<%= bar_chart(stats[:top_speeds], id: "chart-fastest-reads" ) %>
