# Array

## Remove Duplicates from Sorted Array (lc)

**Description**

Given a sorted array, remove the duplicates in place such that each element appear only once and return the new length.

Do not allocate extra space for another array, you must do this in place with constant memory.

For example, Given input array A = [1,1,2],
Your function should return length = 2, and A is now [1,2].

**Analysis**

1. Two pointers advance towards the same direction.
2. STL

**Code**

```cpp
class Solution
{
public:

	// O(n), O(1)
    int removeDuplicates(int A[], int n)
    {
        if (n <= 1) // n = 0 or 1
            return n;

        int i = 0, j = 1;
        while (j < n) {
            if (A[j] == A[i])
                j++;
            else {
                A[++i] = A[j++];
            }
        }

        return i + 1;
    }

    // O(n), O(1)
    int removeDuplicates2(int A[], int n)
    {
        if (n <= 1) // n = 0 or 1
            return n;
        return distance(A, unique(A, A + n));
    }
};
```

