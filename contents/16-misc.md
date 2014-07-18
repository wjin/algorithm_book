# Misc

## BitSet (pp)

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

