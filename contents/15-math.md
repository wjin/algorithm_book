# Math

## Cantor Formula

`X = a[n]*(n-1)!+a[n-1]*(n-2)!+ ... +a[i]*(i-1)!+ ... +a[2]*1!+a[1]*0!,` a[i] is integer, and 0 <= a[i] < i (1 <= i <= n), this equation maps a natural number.

For example, 3 5 7 4 1 2 9 6 8 maps 98884. Because:

`X = 2*8!+3*7!+4*6!+2*5!+0*4!+0*3!+2*2!+0*1!+0*0! = 98884`

* Considering first number 3, so there are two numbers(1, 2) less than 3,
    and permutation leading with them is 8!, so it is 2 * 8!

* Considering the second number 5, there are four numbers(1, 2 ,3 , 4) less than it, and 3 was used in the first item, so there remains 3 numbers (1, 2, 4) usable. That is 3 * 7!

* ...

**Application**

1. Find sequence's rank in set [1 ... n]

2. Find the Kth permutation sequence from set [1,2,3 ... n]

### Permutation Sequence (lc)

**Description**

The set [1,2,3 … n] contains a total of n! unique permutations.

By listing and labeling all of the permutations in order,
We get the following sequence (ie, for n = 3):

> "123"

> "132"

> "213"

> "231"

> "312"

> "321"

Given n and k, return the kth permutation sequence.
Note: Given n will be between 1 and 9 inclusive.

**Analysis**

Cantor formula.

**Code**

```cpp
// O(n), O(n)
class Solution
{
public:
    long long factorial(int n)
    {
        long long product = 1;
        for (int i = 2; i <= n; i++) {
            product *= i;
        }
        return product;
    }

    string getPermutation(int n, int k)
    {
        if (n < 1 || k < 1)
            return "";

        string orig(n, '0'), ret;
        for (int i = 1; i <= n; i++) {
            orig[i - 1] += i;
        }

        // Cantor encode, minus one to start from 0
        // because we will use %
        --k;
        int base = factorial(n - 1); // (n-1)!

        for (int i = n - 1; i > 0; k %= base, base /= i, --i) {
            // judge it belongs to which permutation
            // the sub permu, leading with orig[sub]
            int sub = k / base;
            ret += orig[sub];
            orig.erase(sub, 1);
        }
        ret += orig[0]; // i == 0, the last one

        return ret;
    }
};
```


### Find sequence's rank in permutation [1 ... n]

**Code**

```cpp
// O(n^2), O(1)
class Solution
{
public:
    long long factorial(int n)
    {
        long long product = 1;
        for (int i = 2; i <= n; i++) {
            product *= i;
        }
        return product;
    }

    int rank(vector<int> &v)
    {
        int rank = 0;
        int n = v.size();

        for (int i = 0; i < n; i++) {
            int little = 0;
            for (int j = i + 1; j < n; j++)
                if (v[j] < v[i])
                    little++;

            rank += little * factorial(n - i - 1);
        }

        return rank + 1; // cantor starts counting from 0
    }
};
```
