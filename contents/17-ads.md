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

**Introduction**

![img](img/skiplist.png)

Skip List is a data structure that allows **fast** search within an **ordered** sequence of elements.

Fast search is made possible by maintaining a **linked hierarchy** of subsequences, each skipping over fewer elements. The elements that are skipped over may be chosen **probabilistically**.

**Complexity**

You may have known about AVL tree and Red-Black tree, both get O(log n) in worst case. However, it may be hard to implement them in a short time, especially for AVL tree.

Now, you have an another choice, that is Skip List, it works well in practice. And the most important is that it is easy to implement.


Name    | Average   |  Worst case
------- | --------- | -----------:
Space   | O(n)      | O(n)
Insert  | O(log n)  | O(n)
Delete  | O(log n)  | O(n)
Find    | O(log n)  | O(n)

**Code**

```cpp
// simple skiplist implementation
// 1) do not consider duplicate data
// 2) no backward pointer in the node

class SkipList
{
private:
    struct skiplistNode {
        int data; // node's data
        vector<skiplistNode*> level; // level array

        skiplistNode(int d, int l) : data(d), level(l)
        {
        }
    };

    int m_maxlevel; // max level of skip list
    int m_curlevel; // current level of skip list
    int m_len; // number of nodes
    const double m_prob; // probability

    skiplistNode head; // dumb head

    // get random level for a node
    int RandomLevel()
    {
        int level = 1;
        // m_prob probability to reach to upper level
        while ((random() & 0xFFFF) < (m_prob * 0xFFFF))
            level += 1;

        return (level < m_maxlevel) ? level : m_maxlevel;
    }

public:

    SkipList(const int ml = 32, const double p = 0.25) :
        m_maxlevel(ml), m_prob(p), head(INT_MIN, m_maxlevel)
    {
        m_curlevel = 1; // only one level when initialization
        m_len = 0;
    }

    bool Insert(int data)
    {
        // Considering a single linked list, when inserting
        // an element, we need to get the previous pointer

        // As for skiplist, each level is a list, so we need
        // to keep a previous pointer for each level

        vector<skiplistNode*> prev(m_maxlevel);

        // traverse each level to get prev array
        skiplistNode *x = &head;
        for (int i = m_curlevel - 1; i >= 0; i--) {
            // minus i : move towards bottom
            // forward x : move towards right
            while (x->level[i] && x->level[i]->data < data) {
                x = x->level[i];
            }
            prev[i] = x; // update current level's previous pointer
        }

        // duplicate data
        if (x->level[0] && x->level[0]->data == data) return false;

        int level = RandomLevel();
        // increase skiplist's level
        if (level > m_curlevel) {
            for (int i = m_curlevel; i < level; i++) {
                prev[i] = &head; // update prev array
            }
            m_curlevel = level; // update level
        }

        // insert new node
        x = new skiplistNode(data, level);
        if (x == nullptr) return false; // no memory
        for (int i = 0; i < level; i++) {
            // insert x after pointer prev[i]
            x->level[i] = prev[i]->level[i];
            prev[i]->level[i] = x;
        }

        m_len++;
        return true;
    }

    bool Delete(int data)
    {
        // again, we need to keep previous pointer as
        // single linked list delete operation
        vector<skiplistNode*> prev(m_maxlevel);

        // traverse each level to get prev array
        skiplistNode *x = &head;
        for (int i = m_curlevel - 1; i >= 0; i--) {
            while (x->level[i] && x->level[i]->data < data) {
                x = x->level[i];
            }

            prev[i] = x; // update current level's previous pointer
        }

        x = x->level[0];
        if (x == nullptr || x->data != data) return false; // not exist

        // delete
        for (int i = 0; i < m_curlevel; i++) {
            if (prev[i]->level[i] == x) {
                prev[i]->level[i] = x->level[i]; // delete node
            }
        }
        delete x;
        x = nullptr;

        while(m_curlevel > 1 && head.level[m_curlevel - 1] == NULL)
            m_curlevel--; // delete null list on the top

        m_len--; // update length
        return true;
    }

    bool Find(int data)
    {
        skiplistNode *x = &head;
        for (int i = m_curlevel - 1; i >= 0; i--) {
            while (x->level[i] && x->level[i]->data < data) {
                x = x->level[i];
            }

            if (x->level[i] && x->level[i]->data == data) return true;
        }
        return false;
    }
};
```

**Reference**

* [http://epaperpress.com/sortsearch/download/skiplist.pdf](http://epaperpress.com/sortsearch/download/skiplist.pdf)
* [http://en.wikipedia.org/wiki/Skip_list](http://en.wikipedia.org/wiki/Skip_list)


## Segment Tree

## Trie

## Suffix Array


