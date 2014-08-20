# Bit Operation

## Basic Useful Operations

**Get**

```cpp
bool getBit(int n, int i)
{
    return !!((1 << i) & n);
}
```

**Set**

```cpp
int setBit(int n, int i)
{
    return (1 << i) | n;
}
```

**Set bit i to j**

```cpp
// i < j
int setiToj(int n, int i, int j)
{
    int cnt1 = j - i + 1;
    int mask = (1 << cnt1) - 1;
    mask <<= i;
    return mask | n;
}
```

**Clear**

```cpp
bool clearBit(int n, int i)
{
    return (~(1 << i)) & n;
}
```

**Clear MSBs**

clear the most significant bit to ith bit: bit[31...i].

```cpp
int clearMSBI(int n, int i)
{
	int mask = (1 << i) - 1;
    return mask & n;
}
```

**Clear LSBs**

clear least significant bit to ith bit: bit[i...0].

```cpp
int clearLSBI(int n, int i)
{
	int mask = ~((1 << (i + 1)) - 1);
    return mask & n;
}

int clearLSBI(int n, int i)
{
	int mask = (~0) << (i + 1);
    return mask & n;
}
```

**Number with right most 1**

Given a number, return a new number that just includes the LSB 1 in it.
For example, number=10101000; ret=00001000.

This operation is useful in **binary indexed tree**.

```cpp
int lsb1(int n)
{
	return n & -n;
}
```

**Is power of 2**

Judge a number whether it is a power of 2.

```cpp
bool powOf2(int n)
{
    return (n & (n - 1)) == 0;
}
```

It can be used to calculate how many bits must be changed to transform number A to B. (countNumOf1(A ^ B))

**Swap odd and even bits**

```cpp
int swapBits(int n)
{
    return ((0x55555555 & n) << 1) | ((0xaaaaaaaa & n) >> 1)
}
```

**Swap two numbers**

```cpp
void swapTwoNumber(int &a, int &b)
{
    a = a ^ b;
    b = a ^ b;
    a = a ^ b;
}
```
**Add two numbers**

```cpp
int addTwoNumber(int a, int b)
{
    if (b == 0) return a;
    return addTwoNumber(a ^ b, (a & b) << 1);
}
```

## Classic Question

### Implement bitset (pp)

**Description**

Implement bitset or bit vector using logic opeartions: and, or, not.

**Analysis**

Int has 32 bits, so n / 32 equals n >> 5, n % 32 equals n & 0x1f.

**Code**

```cpp
class BitSet
{
private:
    vector<int> v;
    const int shift = 5;
    const int mask = 0x1f;
    int bits;

public:
    BitSet(const int n = 10000)
    {
        assert(n <= INT_MAX)
        bits = n;
        v.resize((bits >> shift) + 1, 0);
    }

    void set(int n)
    {
        assert(n < bits);
        v[n >> shift] |= (1 << (n & mask));
    }

    void clear(int n)
    {
        assert(n < bits);
        v[n >> shift] &= (~(1 << (n & mask)));
    }

    bool test(int n)
    {
        assert(n < bits);
        return v[n >> shift] & (1 << (n & mask));
    }
};
```
## pop count

Count number of 1 in a number

```cpp
// O(log m), m is the number of 1s in n
int countNumOf1(int n)
{
    int cnt = 0;
    while (n) {
        cnt++;
        n &= (n -1);
    }
}
```

**Look-up table**

**Hamming Weight**

## Insert M to N (cc)

**Description**

You are given two 32-bit numbers, N and M, and two bit positions, i and j.
Write a method to set all bits between i and j in N equal to M (e.g., M
becomes a substring of N located at i and starting at j).

EXAMPLE:

Input: N = 10000000000, M = 10101, i = 2, j = 6

Output: N = 10001010100


**Analysis**

No.

**Code**

```cpp
class Solution
{
public:
    int setBit(int n, int m, int i, int j)
    {
        bitset<32> bitn(n);
        bitset<32> bitm(m);

        for (int nk = i, mk = 0; nk <= j; nk++) {
            bitn[nk] = bitm[mk++];
        }

        return bitn.to_ulong();
    }
};

class Solution2
{
public:
    int setBit(int n, int m, int i, int j)
    {
        int lMask = n & (~((1 << (j + 1)) - 1));
        int rMask = n & ((1 << i) - 1);
        int mask = lMask | rMask;

        return mask | (m << i);
    }
};
```

## Convert decimal double number to binary (cc)

**Description**

Given a real number between 0 and 1 (e.g., 0.72) that is passed in as a double,
print the binary representation. If the number cannot be represented accurately
in binary with at most 32 characters, print "ERROR."


**Analysis**

Take binary decimal 0.101 for example:

> `0.101 = 1*2^-1 + 0*2^-2 + 1*2^-3`

We can multiply it by 2 each time and judge whether it is bigger than 1.

**Code**

```cpp
class Solution
{
public:
    string doubleToBinary(double d)
    {
        string ret(".");
        const int maxBit = 32;

        while (d > 0) { // compare with precision ?
            if (ret.size() >= maxBit) return "ERROR";

            d *= 2;
            if (d >= 1) { //
                ret += '1';
                d = d - 1;
            } else {
                ret += '0';
            }
        }
        return ret;
    }
};
```

## Next smallest and the previous largest (cc)

**Description**

Given a positive integer, print the next smallest and the previous largest number
that have the same number of 1 bits in their binary representation.

**Analysis**

Considering number n, its bits like: bit[31...j...i...0], swap bit[i] and bit[j] to get a new number n2:

1. n > n2 if bit[i] = 0 and bit[j] = 1

2. n < n2 if bit[i] = 1 and bit[j] = 0

So we can find the right postion to flip it and then deal with reamining 0 and 1.

For next smallest number, we need to find a non-tailing 0 (has 1 in LSBs to swap) to flip it, and then move all other 1s to the LSB.

For previous largest number, we need to find a non-tailing 1 (has 0 in LSBs to swap), and move all 1s to near to the postion of non-tailing 1.

**Code**

```cpp
class Solution
{
public:
    int nextSmallest(int num)
    {
        if (num <= 0) return -1;

        int n = num, cnt0 = 0, cnt1 = 0;

        // count number of tailing zeros
        while ((n & 0x1) == 0) {
            cnt0++;
            n >>= 1;
        }

        // number of 1 before a non-tailing 0
        while ((n & 0x1) == 1) {
            cnt1++;
            n >>= 1;
        }

        int idx = cnt0 + cnt1; // position of non-tailing 0

        // error handling, such as: 11...1100...00
        if (idx == 31) return -1;

        num |= (1 << idx); // set bit: idx
        num &= ~((1 << idx) - 1); // clear bits: [0...idx)
        num |= ((1 << (cnt1 - 1)) - 1); // set bits: [0...cnt1-1)

        return num;
    }

    int preLargest(int num)
    {
        if (num <= 0) return -1;

        int n = num, cnt0 = 0, cnt1 = 0;

        // count number of tailing ones
        while ((n & 0x1) == 1) {
            cnt1++;
            n >>= 1;
        }

        // error handling, such as: 00...0011...11
        if (n == 0) return -1;

        // number of 0 before a non-tailing 1
        while ((n & 0x1) == 0) {
            cnt0++;
            n >>= 1;
        }

        int idx = cnt0 + cnt1; // position of non-tailing 0

        // num &= ~((1 << (idx + 1)) - 1); // clear bits: [0...idx]
        num &= (~0) << (idx + 1); // clear bits: [0...idx]

        //int mask = (1 << idx) - 1;
        //mask &= ~((1 << cnt0 - 1) - 1);
        int mask = (1 << (cnt1 + 1)) - 1; // cnt1 + 1
        mask <<= (cnt0 - 1);

        num |= mask; // set bits: [cnt1-1...idx]

        return num;
    }
};
```

## Find missing number (cc)

**Description**

An array A[1...n] contains all the integers from 0 to n except for one number
which is missing. In this problem, we cannot access an entire integer in A with
a single operation. The elements of A are represented in binary, and the only
operation we can use to access them is 'fetch the jth bit of A[i]', which takes
constant time. Write code to find the missing integer. Can you do it in O(n) time?

**Analysis**

Considerint LSB:

if n % 2 == 1 then count(0s) = count(ls)

if n % 2 == 0 then count(0s) = 1 + count(ls)

Removing the number creates an imbalance of 1s and Os in the least significant bit.

1) n is odd:

remove 0: count(0s) < count(ls)

remove 1: count(0s) > count(ls)

2) n is even:

remove 0: count(0s) = count(ls)

remove 1: count(0s) > count(ls)

**Conclusion:**

count(0s) > count(ls)  --> remove 1

count(0s) <= count(ls) --> remove 0

Therefore, we can calculate the number of 0 and 1 in LSB from all numbers to find out
the missed number's LSB.

And then use the same way to find other bits recursively.

O(N) + O(N/2) + ... + O(1) = O(2N) = O(N)


*Variation:*

1) An array A[1... 2^k -1] (k >= 0)

   number of 0 == number of 1 (the same way to deal with it)

2) no access limitation:  a)xor  b)sum

**Code**

```cpp
class Solution
{
private:
    const int MAX_INT_BITS = 32;
    bool fetch(int num, int bit)
    {
        return !!(num & (1 << bit));
    }

public:
    int findMissingNum(vector<int> &v, int col)
    {
        if (col >= MAX_INT_BITS)
            return 0;

        vector<int> zero;
        vector<int> one;

        for (auto e : v) {
            if (fetch(e, col)) {
                one.push_back(e);
            } else {
                zero.push_back(e);
            }
        }

        if (zero.size() > one.size()) {
            return findMissingNum(one, ++col) << 1 | 1;
        } else {
            return findMissingNum(zero, ++col) << 1 | 0;
        }
    }
};
```

## Draw a line in screen (cc)

**Description**

A monochrome screen is stored as a single array of bytes, allowing eight consecutive
pixels to be stored in one byte. The screen has width w, where w is divisible
by 8 (that is, no byte will be split across rows). The height of the screen, of course,
can be derived from the length of the array and the width. Implement a function
drawHorizontalLine(byte[] screen, int width, int x1, int x2, int y) which draws a horizontal
line from (x1, y) to (x2, y).

**Analysis**

Set byte by byte if possible for performance.

**Code**

```cpp
class Solution
{
public:
    void drawHorizontalLine(char* screen, int width, int x1, int x2, int y)
    {
        int start_offset = x1 % 8;
        int start_byte = x1 / 8;
        if (start_offset) start_byte++;

        int end_offset = x2 % 8;
        int end_byte = x2 / 8;
        if (end_offset != 7) end_byte--; // not a whole byte

        // set bytes
        for (int i = start_byte; i <= end_byte; i++) {
            screen[y * width / 8 + i] = 0xff;
        }

        int start_mask = (0xff >> start_offset);
        int end_mask = (0xff << (8 - end_offset - 1));
        //int end_mask = ~(0xff >> (end_offset + 1));

        if ((x1 / 8) == (x2 / 8)) { // same byte
            int mask = start_mask & end_mask;
            screen[y * (width / 8) + x1 / 8] |= mask;
        } else {
            if (start_offset) {
                screen[y * (width / 8) + start_byte - 1] |= start_mask;
            }

            if (end_offset != 7) {
                screen[y * (width / 8) + end_byte + 1] |= end_mask;
            }
        }
    }
};
```