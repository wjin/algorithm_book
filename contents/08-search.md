# Search

## Binary Search

**Template**

```cpp
    int search(int A[], int n, int target)
    {
        int low = 0, high = n - 1, mid = 0;
        while (low <= high) {
            mid = low + ((high - low) >> 1);

            if (A[mid] == target)
                return mid;

            if (A[mid] < target) { // elements in the second part
				low = mid + 1;
			} else { // elements in the first part
				high = mid - 1;
			}
		}
		return -1; // not exist
	}
```
### Search in Rotated Sorted Array (lc)

**Description**

 Suppose a sorted array is rotated at some pivot unknown to you beforehand.

 (i.e., 0 1 2 4 5 6 7 might become 4 5 6 7 0 1 2).

 You are given a target value to search.
 If found in the array return its index, otherwise return -1.

 You may assume no duplicate exists in the array.

**Analysis**

As there is no duplicate in the array, We can see that when a[mid] != target,
either [low, mid] or [mid, high] is in order. So we can search in **this ordered
part** to make a decision of either minus *high* or add *low* index.

**Code**

```cpp
// O(logn), O(1)
class Solution {
public:
    int search(int A[], int n, int target)
    {
        int low = 0, high = n - 1;
        int mid = 0;

        while (low <= high) {
            mid = low + ((high - low) >> 1);

            if (A[mid] == target)
                return mid;

            if (A[low] <= A[mid]) {// first part is in order
                if (A[low] <= target && target < A[mid]) { // target in first part
                    high = mid - 1;
                } else {
                    low = mid + 1;
                }
            } else { // second part is in order
                if (A[mid] < target && target <= A[high]) { // target in second part
                    low = mid + 1;
                } else {
                    high = mid - 1;
                }
            }
        }
        return -1;
    }
};
```

### Search in Rotated Sorted Array || (lc)

**Description**

 Follow up for "Search in Rotated Sorted Array":
 What if duplicates are allowed?

 Would this affect the run-time complexity? How and why?

 Write a function to determine if a given target is in the array.

**Analysis**

If there are duplicates, we can not make a decision to search in which part.
For example, [1 1 1 1 2] rotated to [ 1 2 1 1 1], A[low] = A[mid] = A[high] = 1.

The simplest way is just to advance the *low* index by 1.

**Code**

```cpp
class Solution {
// O(n), O(1)
public:
    bool search(int A[], int n, int target)
    {
        int low = 0, high = n - 1;
        int mid = 0;

        while (low <= high) {
            mid = low + ((high - low) >> 1);

            if (A[mid] == target)
                return true;

            if (A[low] < A[mid]) { // first part is in order
                if (A[low] <= target && target < A[mid]) { // target in first part
                    high = mid - 1;
                } else {
                    low = mid + 1;
                }
            } else if (A[low] > A[mid]) { // second part is in order
                if (A[mid] < target && target <= A[high]) { // target in second part
                    low = mid + 1;
                } else {
                    high = mid - 1;
                }
            } else { // A[low] == A[mid]
                low++;
            }
        }
        return false;
    }
};
```

## Hash

### Longest Consecutive Sequence

**Description**

Given an unsorted array of integers, find the length of the longest
consecutive elements sequence.

For example,
Given [100, 4, 200, 1, 3, 2],
The longest consecutive elements sequence is [1, 2, 3, 4]. Return its length: 4.

Your algorithm should run in O(n) complexity.

**Analysis**

As array elements are unsorted, we can sort it and then scan the array to get the longest
consecutive sequence, however, sorting requires O(nlogn) and it doest not meet O(n) requirement.

We can use hash to pre-process the array: adding all elements to hash table.
And then for each element in the array, search number in hash table towards two sides(less than and greater than
this element) until it is not in the hash table, meanwhile delete number from hash table during searching.

**Code**

```cpp
// O(n), O(n)
class Solution
{
public:
    int longestConsecutive(vector<int> &num)
    {
        unordered_set<int> arr;

        // construct hash table
        // O(n)
        for (auto e : num)
            arr.insert(e);

        // for each element in array, we only need to search hash table
	    // at most three times because we delete it from hash table after
		// finding it, so it is O(n)
        int maxLen = 0;
        int tmpLen = 0;
        for (auto e : num) {
            tmpLen = 1;
            arr.erase(e);

            int small = e - 1;
            while (arr.find(small) != arr.end()) { // little than e
                tmpLen++;
                arr.erase(small);
                small--;
            }

            int big = e + 1;
            while (arr.find(big) != arr.end()) { // greater than e
                tmpLen++;
                arr.erase(big);
                big++;
            }

            maxLen = max(maxLen, tmpLen);
        }

        return maxLen;
    }
};
```

Above solution needs to scan input array two times. For large input array or when dealing with
input stream that we do not know when to stop input, it is unacceptable.

We can maintain many spans in hash table. When get a new input, insert it to hash table and update
or merge spans if possible. And also calculate a max length so far, when input finishes, we get
the final max length.

```cpp
// only scan array once
// O(n), O(n)
class Solution2
{
private:
    int mergeLength(unordered_map<int, int> &m, int low, int high)
    {
        int lower = low - m[low] + 1;
        int upper = high + m[high] - 1;
        int newLen = upper - lower + 1;

        m[lower] = newLen;
        m[upper] = newLen;

        return newLen;
    }

public:
    int longestConsecutive(vector<int> &num)
    {
        if (num.empty()) return 0;

        unordered_map<int, int> m;
        int maxLen = 1;

        for (auto e : num) {
            // duplicate, already processed before
            if (m.count(e) != 0 ) continue;

            // deal with new elements
            m[e] = 1;

            // merge lower bound
            if (m.count(e - 1) != 0) {
                maxLen = max(maxLen, mergeLength(m, e - 1, e));
            }

            // merge upper bound
            if (m.count(e + 1) != 0) {
                maxLen = max(maxLen, mergeLength(m, e, e + 1));
            }
        }

        return maxLen;
    }
};
```
