#lang forge 
/* Does the order in which you compose ~ and ^ matter? */ 
sig Node { edges: set Node }
/* You could do this with predicates too, but I like functions in this case. */
fun transpose_then_closure: set Node->Node { ^(~edges) }
fun closure_then_transpose: set Node->Node { ~(^edges) }
/** Check for differences on graphs up to 5 nodes. The default is 4, but 
    for comparisons like this, I like to increase the bound some. */
run { transpose_then_closure != closure_then_transpose } for 5 Node 