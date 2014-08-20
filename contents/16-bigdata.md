# Big Data

Considering big data problem, there are many ways to deal with them.

**Time**

* bit-map
* bloom filter
* hyperloglog
* hash
* heap
* inverted index
* trie
* database index
* hadoop, map/reduce

**Space**

* partition (hash/bucket)

**Method**

 * partition(hash/bucket) + counting(map/hash/trie) + sorting(heap/merge)

## BitMap

## [Bloom Filter](http://en.wikipedia.org/wiki/Bloom_filter)

**Description**

Bloom filter is a **space-efficient** probabilistic data structure that is used to test whether an element is a member of a set.

A query returns either "possibly in set" or "definitely not in set". Elements can be added to the set, but not removed.

An empty Bloom filter is a **bit array** of **m** bits, all set to 0. There must also be **k** different hash functions defined, each of which maps or hashes some set element to one of the m array positions with a uniform random distribution.

To **add** an element, feed it to each of the k hash functions to get k array positions. Set the bits at all these positions to 1.

To **query** for an element (test whether it is in the set), feed it to each of the k hash functions to get k array positions. If any of the bits at these positions are 0, the element is definitely not in the set. If all are 1, then either the element is in the set, or the bits have by chance been set to 1 during the insertion of other elements, resulting in a false positive. 

**Extension**

**Counting filters** provide a way to implement a delete operation on a Bloom filter without recreating the filter afresh.

In a counting filter the array positions (buckets) are extended from being a single bit to being an n-bit counter. In fact, regular Bloom filters can be considered as counting filters with a bucket size of one bit.

**Application**

* [web cache sharing](http://pages.cs.wisc.edu/~jussara/papers/00ton.pdf)
