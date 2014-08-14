# Stack

## Implement three stacks (cc)

**Description**

Describe how you could use a single array to implement three stacks?

**Analysis**

1. simple solution, each stack has the same size

2. dynamic stack (todo)

**Code**

```cpp
// simple solution: three stacks have the same size
// [0, sz)
// [sz, 2*sz)
// [2*sz, 3*sz)
class Solution
{
private:
    int sz; // per stack size
    int sn; // stack number, here it is 3
    vector<int> se; // stack element array
    vector<int> st; // per stack top

    int getTopPosition(int sid)
    {
        return st[sid] + sz * sid;
    }

public:
    Solution(int z = 10, int n = 3) : sz(z), sn(n), se(sz * sn), st(sn, -1)
    {
    }

    void push(int sid, int data)
    {
        if (st[sid] + 1 >= sz) {
            throw runtime_error("stack is full");
        }

        st[sid]++;
        se[getTopPosition(sid)] = data;
    }

    void pop(int sid)
    {
        if (st[sid] == -1) {
            throw runtime_error("stack is empty");
        }

        st[sid]--;
    }

    int top(int sid)
    {
        if (st[sid] == -1) {
            throw runtime_error("stack is empty");
        }

        return se[getTopPosition(sid)];
    }

    bool isEmpty(int sid)
    {
        return st[sid] == -1;
    }
};
```

## stack with min element (cc)

**Description**

Get stack's minimum element. push, pop, min should be O(1).

**Analysis**

Two stacks. Let one stack record a sequence of descending top. 

For example, let s1 store all elements, and s2 maintains a descending sequence.

When push a new element *ele* to s1, push *ele* to s2 as well if:

> s2.empty() or ele <= s2.top()

When pop s1, also pop s2 if s1.top() == s2.top().


**Code**

```cpp
class MinStack
{
private:
    stack<int> stk;
    stack<int> minStk;

public:
    MinStack() : stk(), minStk() {}

    void push(int t)
    {
        stk.push(t);
        if(minStk.empty() || t <= minStk.top()) minStk.push(t);
    }

    void pop()
    {
        int top = stk.top();
        stk.pop();
        if (top == minStk.top()) minStk.pop();
    }

    int minElement()
    {
        return minStk.top();
    }

    int top()
    {
        return stk.top();
    }

    bool empty()
    {
        return stk.empty();
    }

    size_t size()
    {
        return stk.size();
    }
};
```

## stack of plates (cc)

**Description**

Imagine a (literal) stack of plates. If the stack gets too high, it might topple.
Therefore, in real life, we would likely start a new stack when the previous stack
exceeds some threshold. Implement a data structure SetOf Stacks that mimics
this. SetOf Stacks should be composed of several stacks and should create a
new stack once the previous one exceeds capacity. SetOf Stacks. push() and
SetOf Stacks. pop() should behave identically to a single stack (that is, popO
should return the same values as it would if there were just a single stack).

FOLLOW UP

Implement a function popAt(int index) which performs a pop operation on
a specific sub-stack.

**Analysis**

As **popAt** needs to erase element from any places, so the best choice is to use `vector<list<int>>`.

**Code**

```cpp
class Solution
{
private:
    int threshold; // each stack's threshhold
    vector<list<int>> ss; // stacks

public:
    Solution(const int th = 5) : threshold(th) {}

    void push(int data)
    {
        if (ss.empty() || ss.back().size() == threshold) {
            ss.push_back(list<int>());
        }

        ss.back().push_back(data);
    }

    void pop()
    {
        if (ss.empty()) {
            throw runtime_error("stack is empty");
        }

        ss.back().pop_back();
        if (ss.back().size() == 0) {
            ss.pop_back();
        }
    }

    int top()
    {
        if (ss.empty()) {
            throw runtime_error("stack is empty");
        }

        return ss.back().back();
    }

    bool empty()
    {
        return ss.empty();
    }

    void popAt(int idx)
    {
        if (ss.empty()) {
            throw runtime_error("popAt error: stack is empty");
        }

        int curSize = threshold * (ss.size() - 1) + ss.back().size();

        if (idx > curSize) {
            throw runtime_error("error pop index");
        }

        int nth = idx / threshold; // idx belongs to nth stack
        int nthi = idx % threshold; // idx's subscript in nth stack

        ss[nth].erase(next(ss[nth].begin(), nthi));

        while (nth < ss.size() - 1) {
            ss[nth].push_back(ss[nth + 1].front());
            ss[nth + 1].pop_front();
            nth++;
        }

        if (ss.back().size() == 0) {
            ss.pop_back();
        }
    }
};
```

## hanoi (cc)

**Description**

In the classic problem of the Towers of Hanoi, you have 3 rods and N disks
of different sizes which can slide onto any tower. The puzzle starts with
disks sorted in ascending order of size from top to bottom
(e.g., each disk sits on top of an even larger one).

You have the following constraints:

Only one disk can be moved at a time.
A disk is slid off the top of one rod onto the next rod.
A disk can only be placed on top of a larger disk.
Write a program to move the disks from the first rod to
the last using Stacks


**Analysis**

Typical question to understand recursive trick. However, the non-recursive solution is also useful. We can learn how to convert a recursive algorithm to a non-recursive one.

Recursive function:

> void hanoi(int n, int src, int dst, int buf);

It means move n disks from *src* to *dst*, and *buf* can be used as a buffer.

If we know how to move n-1 disks from *src* to *buf* (dst as buffer), we can move nth disk from src to *dst* directly and then move n-1 disks from *buf* to *dst* (src as buffer).

The n-1 problem is a subproblem of original question, that is recursive. :(

**Code**

```cpp
// recursively
class Solution
{
private:
    void moveAction(int id, int src, int dst)
    {
        // move disk
        cout << "Move disk "<< id << " from ";
        cout << src << " to " << dst << endl;
    }

public:
    void hanoi(int n, int src, int dst, int buf)
    {
        if (n == 1) { // ending condition
            moveAction(n, src, dst);
            return;
        }

        hanoi(n - 1, src, buf, dst);
        moveAction(n, src, dst);
        hanoi(n - 1, buf, dst, src);
    }
};

// unrecursively
class Solution2
{
private:
    struct state {
        int start; // disk start
        int end; // disk end
        int src; // rod source
        int dst; // rod destination
        int buf; // rod buffer
        state(int st = -1, int e = -1, int sr = -1, int d = -1, int b = -1) :
            start(st), end(e), src(sr), dst(d), buf(b)
        {
        }
    };

    void moveAction(const state &s)
    {
        // move disk
        cout << "Move disk "<< s.start << " from ";
        cout << s.src << " to " << s.dst << endl;
    }

public:
    void hanoi(int n, int src, int dst, int buf)
    {
        stack<state> s;
        state t;

        // stack initial state
        s.push(state(1, n, src, dst, buf));

        while (!s.empty()) {
            t = s.top();
            s.pop();

            // this rod has one disk, just move
            if (t.start == t.end) {
                moveAction(t);
                continue;
            }

            // reversely push states to stack compared with recursive solution
            s.push(state(t.start, t.end - 1, t.buf, t.dst, t.src));
            s.push(state(t.end, t.end, t.src, t.dst, t.buf));
            s.push(state(t.start, t.end - 1, t.src, t.buf, t.dst));
        }
    }
};
```

## using two stacks to implement a queue (cc)

**Description**

Implement a MyQueue class which implements a queue using two stacks.

**Analysis**

No. Simple programming skills.

**Code**

```cpp
// using two stacks to implement queue
template <typename T>
class CQueue
{
private:
    stack<T> s1;
    stack<T> s2;

public:
    CQueue() {}
    ~CQueue() {}

    bool empty()
    {
        return s1.empty() && s2.empty();
    }

    int size()
    {
        return s1.size() + s2.size();
    }

    void push(const T& t)
    {
        s1.push(t);
    }

    void pop()
    {
        if (empty()) {
            throw runtime_error("bad operation");
        }

        // s2 is empty
        if (s2.empty()) {
            while (!s1.empty()) {
                s2.push(s1.top());
                s1.pop();
            }
        }

        s2.pop();
    }

    T front()
    {
        if (empty()) {
            throw runtime_error("bad operation");
        }

        // s2 is empty
        if (s2.empty()) {
            while (!s1.empty()) {
                s2.push(s1.top());
                s1.pop();
            }
        }

        T t = s2.top();
        return t;
    }

    T back()
    {
        if (empty()) {
            throw runtime_error("bad operation");
        }

        if (s1.empty()) {
            while (!s2.empty()) {
                s1.push(s2.top());
                s2.pop();
            }
        }

        T t = s1.top();
        return t;
    }
};

// using two queues to implement stack
// elements are always in q1
// q2 is just a assistant
template <typename T>
class CStack
{
private:
    queue<T> q1;
    queue<T> q2;

public:
    CStack() {}
    ~CStack() {}

    bool empty()
    {
        return q1.empty();
    }

    int size()
    {
        return q1.size();
    }

    void push(const T &t)
    {
        q1.push(t);
    }

    void pop()
    {
        if (q1.empty()) {
            throw runtime_error("bad operation");
        }

        while (q1.size() != 1) {
            q2.push(q1.front());
            q1.pop();
        }

        q1.pop();
        q1.swap(q2); // swap elements back
    }

    T top()
    {
        if (q1.empty()) {
            throw runtime_error("bad operation");
        }

        return q1.back();
    }
};
```

## sort a stack using one additional stack (cc)

**Description**

Write a program to sort a stack in ascending order (with biggest items on top).
You may use at most one additional stack to hold items, but you may not copy
the elements into any other data structure (such as an array). The stack supports
the following operations: push, pop, peek, and isEmpty.

**Analysis**

The key point is that always maintain a sorted sequence in the additional stack.

**Code**

```cpp
class Solution
{
private:
    template<typename T>
    void do_sort(stack<int> &s, const T &cmp)
    {
        stack<int> t;
        while (!s.empty()) {
            int tmp = s.top();
            s.pop();
            while (!t.empty() && cmp(tmp, t.top())) {
                s.push(t.top());
                t.pop();
            }
            t.push(tmp);
        }

        s = t;
    }

public:
    void ascending(stack<int> &s)
    {
        do_sort(s, less<int>());
    }

    void descending(stack<int> &s)
    {
        do_sort(s, greater<int>());
    }
};
```

## adopt animal (cc)

**Description**

An animal shelter holds only dogs and cats, and operates on a strictly "first in,
first out" basis. People must adopt either the "oldest" (based on arrival time) of
all animals at the shelter, or they can select whether they would prefer a dog or
a cat (and will receive the oldest animal of that type).

They cannot select which specificanimal they would like.

Create the data structures to maintain this system and implement
operations such as enqueue, dequeueAny, dequeueDog and
dequeueCat.You may use the built-in LinkedList data structure.

**Analysis**

Assign an unique id to each animal when they enter into the zoo. That can be used to identiy entering zoo time.

Also, maintain a queue for each kind of animal, we can use following containers:

`vector<queue<Animal>>` or `vector<list<Animal>>`.

**Code**

```cpp
enum AnimalKind { Dog, Cat, AnimalMax };

struct Animal {
    AnimalKind t; // animal type
    unsigned int id; // enter zoo, assign an id
    Animal(AnimalKind k, unsigned int i = -1) : t(k), id(i) {}
};

class Solution
{
private:

    unsigned int g_id; // track all animals enter this zoo
    vector<queue<Animal>> aq; // animal queues, each animal belongs to a queue

    void pop(AnimalKind t)
    {
        if (t == AnimalMax || aq[t].empty()) {
            throw runtime_error("bad operation");
        }

        Animal tmp = aq[t].front();
        aq[t].pop();

        cout << tmp.t << ' ' << tmp.id << endl;
    }

public:
    Solution() : g_id(0), aq(AnimalMax) {}

    void enque(Animal &a)
    {
        a.id = ++g_id;
        aq[a.t].push(a);
    }

    void dequeDog()
    {
        pop(Dog);
    }

    void dequeCat()
    {
        pop(Cat);
    }

    void dequeAny()
    {
        AnimalKind t = AnimalMax;
        unsigned int id = INT_MAX;

        for (int k = 0; k < AnimalMax; k++) {
            if (!aq[k].empty() && aq[k].front().id < id) {
                id = aq[k].back().id;
                t = static_cast<AnimalKind>(k);
            }
        }

        pop(t);
    }
};
```