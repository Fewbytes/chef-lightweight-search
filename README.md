Description
===========
LightWeight search is a wrapper library around Chef's built-in search which casts node objects to memory efficient "Lightweight Node" objects.
The LightWeightNode object contains a subset of the original node object attribute and pre-merges attributes to save RAM. This is handy when you have recipes performing searches with a big result set.

This cookbooks will only help with chef-client RAM consumption. Fixing the server side of the search will require changes to the API.

The amount of RAM saved varies wildly due to Ruby's GC. This really should be fixed on the server side.

Usage
=====
In your recipes, use `lightweight_node_search` function instead of `search`. Function signature:

<pre><code>
lightweight_node_search(query, whitelist)
</code></pre>
query - The search query
whitelist - attributes to include in the lightweight node object. This can be an array or a (nested) hash of arrays/strings/symbols
