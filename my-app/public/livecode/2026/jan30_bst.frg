#lang forge/froglet 

option run_sterling "jan30_bst.cnd"

/*
  Modeling Binary Search Trees: Jan 30, 2026
*/

/** A node in a binary tree. Leaf nodes re modeled as `none`, hence
    the left and right fields being `lone` rather than `one` */
sig Node {
    key: one Int,
    left: lone Node,
    right: lone Node }

/** We'll model forests of binary trees at first. I like giving W.F. 
    predicates meaningful names when I can. */
pred wf_binary_forest {
    all n: Node | {
        // A node n's right child cannot reach n's left child
        //    by 1 or more "hops" along the left and right fields
        //not reachable[n.left, n.right, left, right]
        not reachable[n, n, left, right]
        // No node has identical child fields
        some n.left implies (n.left != n.right)
        // ...

        // Every node has at most one parent 
        all p1, p2: Node | {
            (p1 != p2 and p1 != n and p2 != n) implies {
                (n = p1.left or n = p1.right) implies {
                    n != p2.left and n != p2.right
                }
            }
        }

         } }

/** An example speaks of concrete /atoms/ in an instance, not 
    just the names defined as sigs and fields. */
example oneNode is wf_binary_forest for {
    Node = `Node0
    no left
    no right 
    `Node0.key = 0
}

example selfLoop is not wf_binary_forest for {
    Node = `Node0
    `Node0.left = `Node0
    no right 
    `Node0.key = 0
}

example dag3 is not wf_binary_forest for {
    Node = `Node0 + `Node1 + `Node2
    `Node0.left  = `Node1
    `Node0.right = `Node2
    `Node1.right = `Node2
    // We did not mention key at all!
    //   Example: Forge tries to check _consistency_ with the "is" pred. 
    // This is a "partial example". 
}

/** Every left-child... */
pred bst_invariant_1[n: Node] {
    // Note: if I use "none" as a number, it is treated as 0.
    some n.left implies { n.left.key < n.key}
    some n.right implies { n.right.key > n.key}
}

/** Every left-descendant... */
pred bst_invariant_2[n: Node] {
    all n2: Node | {
        (n2 = n.left or reachable[n2, n.left, left, right]) 
          implies {n2.key < n.key }
        (n2 = n.right or reachable[n2, n.right, left, right]) 
          implies {n2.key > n.key }
    }
}

assert { 
    wf_binary_forest
    some n: Node | { 
        bst_invariant_1[n]
        some n.left
    }
} is sat
assert { 
    wf_binary_forest
    some n: Node | {
        bst_invariant_2[n] 
        some n.left
    }
} is sat

invars_same: run {
    wf_binary_forest 
    some n: Node | {
        not (bst_invariant_1[n] iff bst_invariant_2[n])
    }
} for exactly 7 Node

// Why is this unsatisfiable? (It's not anymore!)
run {
    wf_binary_forest
} for exactly 7 Node

// TODO: 2 invariants, comparison 
