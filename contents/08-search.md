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

