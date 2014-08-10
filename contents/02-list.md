# List
## Remove Duplicate from a list (cc)

**Description**

Write code to remove duplicates from an unsorted linked list.

FOLLOW UP

How would you solve this problem if a temporary buffer is not allowed?

**Analysis**

Hash to get time complexity O(n). Typical space exchanges for time.

**Code**

```cpp
struct ListNode {
    int val;
    ListNode *next;
    ListNode(int x) :
        val(x), next(nullptr)
    {
    }
};

// O(n), O(n)
class Solution
{
public:
    ListNode* removeDup(ListNode* l)
    {
        unordered_set<int> s;
        ListNode *head = l, *pre = nullptr;

        while (l != nullptr) {
            if (s.count(l->val)) { // delete
                pre->next = l->next;
                delete l;
                l = pre->next;
            } else {
                s.insert(l->val);
                pre = l;
                l = l->next;
            }
        }

        return head;
    }
};

// Follow up:
// O(n^2), O(1)
class Solution2
{
public:
    ListNode* removeDup(ListNode* l)
    {
        ListNode *head = l, *cur = l, *pre, *q;

        while (cur != nullptr) {
            pre = cur;
            q = cur->next;

            while (q) {
                if (q->val == cur->val) {
                    pre->next = q->next;
                    delete q;
                } else {
                    pre = pre->next;
                }
                q = pre->next;
            }
            cur = cur->next;
        }

        return head;
    }
};
```
