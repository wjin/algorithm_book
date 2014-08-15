# String

## unique charater in a string (cc)

**Description**

Implement an algorithm to determine if a string has all unique characters.
What if you cannot use additional data structures?

**Analysis**

Hash.

**Code**

```cpp
class Solution
{
public:
    bool isUnique(string s)
    {
        bitset<CHAR_MAX> cs(0); // char set

        for (char c : s) {
            if (cs[c] == 1) return false;
            cs[c] = 1;
        }

        return true;
    }
};
```

## reverse string (cc)

**Description**

Implement a function void reverse(char* str) in C or C++ which reverses a null terminated string.

**Analysis**

No.

**Code**

```cpp
class Solution
{
public:
    char * reverseStr(char *s)
    {
        if (s == nullptr) return nullptr;

        char *l = s, *h = s + strlen(s) - 1;

        while (l < h) {
            swap(*l++, *h--);
        }

        return s;
    }
};
```

## is anagram (cc)

**Description**

Given two strings, write a method to decide if one is a permutation of the other.

**Analysis**

Hash.

**Code**

```cpp
class Solution
{
public:
    // sort will change the original string
    // and it is a little slow
    bool isAnagram(string &s1, string &s2)
    {
        if (s1.length() != s2.length()) return false;

        sort(s1.begin(), s1.end());
        sort(s2.begin(), s2.end());
        return s1 == s2;
    }
};

class Solution2
{
public:
    // hash
    bool isAnagram(string &s1, string &s2)
    {
        if (s1.length() != s2.length()) return false;

        vector<int> cnt(CHAR_MAX, 0);

        for (auto c : s1) {
            cnt[c]++;
        }

        for (auto c : s2) {
            if (--cnt[c] < 0) return false;
        }

        return true;
    }
};
```

## replace space with 20% (cc, jz)

**Description**

Write a method to replace all spaces in a string with'%20'. You may assume thatthe string has sufficient space at the end of the string to hold the additionalcharacters, and that you are given the "true" length of the string.
EXAMPLE
Input: "Mr John Smith
Output: "Mr%20Dohn%20Smith"

**Analysis**

Replace from end to start.

**Code**

```cpp
class Solution
{
public:
    void replace_char_inplace(string &s)
    {
        int spaceCnt = 0;
        for (size_t i = 0; i < s.size(); i++) {
            if (s[i] == ' ') {
                ++spaceCnt;
            }
        }

        if (spaceCnt == 0) return;

        int origSize = s.size();
        int newSize = origSize + spaceCnt * 2;
        s.resize(newSize);

        for (int i = origSize - 1, j = newSize - 1; i >= 0 && i < j; i--, j--) {
            if (s[i] == ' ') {
                s[j--] = '0';
                s[j--] = '2';
                s[j] = '%';
            } else {
                s[j] = s[i];
            }
        }
    }
};
```

## compress string (cc)

**Description**

Implement a method to perform basic string compression using the counts
of repeated characters. For example, the string aabcccccaaa would become
a2blc5a3. If the "compressed" string would not become smaller than the original
string, your method should return the original string.

**Analysis**

No.

**Code**

```cpp
class Solution
{
public:
    string compress(const string &s)
    {
        stringstream ss;

        int i = 0, j = 0, len = s.length();

        for (; i < len; i = j) {
            j = i + 1;
            while (j < len && s[i] == s[j]) j++;

            ss << s[i] << j - i;
        }

        string ret;
        ss >> ret;

        if (ret.length() < len) return ret;

        return s;
    }
};
```

## is substring (cc, bp)

**Description**

Assume you have a method isSubstring which checks if one word is a
substring of another. Given two strings, si and s2, write code to check if s2 is
a rotation of si using only one call to isSubstring (e.g.,"waterbottle"is a rotation of "erbottlewat").

**Analysis**

S2 is a substr of s1 + s1 if s2 is rotated from s1.

**Code**

```cpp
class Solution
{
private:
    bool isSubstring(const string &s1, const string &s2)
    {
        return s1.find(s2) != string::npos;
    }
public:
    bool isRotate(const string &s1, const string &s2)
    {
        if (s1.length() != s2.length()) return false;

        return isSubstring(s1 + s1, s2);
    }
};
```