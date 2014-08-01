# Advanced Data Structure

## Heap

```cpp
// max heap
class Heap
{
private:
    vector<int> m_data; // heap data
    size_t m_size; // heap size

    void sift_up(int i)
    {
        while (i > 1 && m_data[i] > m_data[i / 2]) {
            swap(m_data[i], m_data[i / 2]);
            i /= 2;
        }
    }

    void sift_down(int i)
    {
        int j = 2 * i; // j is the left child

        while (j <= m_size) { // loop until leaf
            // find max child
            if (j + 1 <= m_size && m_data[j + 1] > m_data[j])
                j += 1;

            // swap if possible
            if (m_data[i] < m_data[j]) {
                swap(m_data[i], m_data[j]);
                i = j;
                j *= 2;
            } else {
                break;
            }
        }
    }

    void make_heap()
    {
        for (int i = m_size / 2; i > 0; i--) {
            sift_down(i);
        }
    }

public:
    Heap(vector<int> &v)
    {
        m_size = v.size();

        // do not use m_data[0] to simplify sift_down operation
        // as when parameter i is 0, cannot find left child using 2*i
        m_data.resize(m_size + 1);
        m_data[0] = -1;

        copy(v.begin(), v.end(), m_data.begin() + 1);
        make_heap();
    }

    void push_heap(int val)
    {
        m_data.push_back(val);
        m_size++;
        sift_up (m_size);
    }

    int pop_heap()
    {
        int val = get_top();
        swap(m_data[1], m_data[m_size]);
        m_data.pop_back();
        m_size--;
        sift_down(1);
        return val;
    }

    int get_top()
    {
        return m_data[1];
    }

    int get_size()
    {
        return m_size;
    }
};
```

## Union Find Set

### People Infected Virus

**Description**

There are n (0...n-1) students, m student unions, each union has k students.
Calculate how many people are infected of virus if people zero is infected?


Input:

First line has two numbers n and m. Following m lines are each union's students.
The first number is students number k, and then following k numbers standing for students ID.

Last line 0 0 means ending input.

100 4

2 1 2

5 10 13 11 12 14

2 0 1

2 99 2

200 2

1 5

5 1 2 3 4 5

1 0

0 0

**Analysis**

We can merge those students who are in the same student union to one set when reading input data. 
And meanwhile calculate how many students in this set. The count of set with student ID 0 is the result.

This is a typical use of UFS and it just records student's number.
In other cases, we can record any info in the node specific to that question.

**Code**

```cpp
class UnionFindSet
{
private:
    struct Node {
        int parent; // parent of this node
        int rank; // rank value for merge

        // can record any data here
        int cnt; // number of people infected in this set

        Node(): parent(-1), rank(0), cnt(1) {}
    };

    vector<Node> node;

public:
    UnionFindSet(int n) : node(n + 1) {}

    int Find(int x)
    {
        if (node[x].parent == -1) return x;
        return node[x].parent = Find(node[x].parent); // compress path
    }

    void Union(int x, int y)
    {
        int u1 = Find(x);
        int u2 = Find(y);

        if (u1 == u2) return; // same set

        if (node[u1].rank < node[u2].rank) {
            node[u1].parent = u2;
            node[u2].cnt += node[u1].cnt;
        } else { // >=
            node[u2].parent = u1;
            node[u1].rank = max(node[u1].rank, node[u2].rank + 1);
            node[u1].cnt += node[u2].cnt;
        }
    }

    int GetNum(int x)
    {
        return node[Find(x)].cnt;
    }
};

int main(int argc, char *argv[])
{
#ifndef ONLINE_JUDGE
    freopen("input", "r", stdin);
    // freopen("output","w",stdout);
#endif

    int n, m, k;

    while (cin >> n >> m && n > 0) {
        UnionFindSet ufs(n);

        while (m--) {
            int x, y; // two students

            cin >> k;
            k--;
            cin >> x;

            while (k--) {
                cin >> y;
                ufs.Union(x, y);
            }
        }
        cout << ufs.GetNum(0) << endl;
    }

    return 0;
}
```

## SkipList

## Segment Tree

## Trie

## Suffix Array


