---
layout: page
title: Categories
header: Posts by category
---
<% categories = count_categories %>

<ul class="tag_box inline">
<% categories.each do |category, num| %>
<li><a href="#<%= category %>-ref"><%= category %> <span><%= num %></span></a></li>
<% end %>
</ul>

<% categories.each do |category, num| %>
<h2 id="<%= category %>-ref"><%= category %></h2>
<ul>
<% relevantItems = items_with_category(category)
   relevantItems.each do |item| %>
<li><a href="<%= @config[:base_url] + item.identifier.chop + '.html' %>"><%= item[:title] %></a></li>
<% end %>
</ul>
<% end %>
