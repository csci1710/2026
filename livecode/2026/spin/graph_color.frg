#lang forge

/* 
  Graph coloring.
  To avoid higher-order universal quantification, we'll focus on _finding_ 
  colorings for complete graphs, which ought to be easy!
*/

sig Color {}
sig Vertex {
    color: one Color,
    adj:   set Vertex 
}

/** The graph is symmetric, and has no self-loops. */
pred wellFormed {
    all u, v: Vertex | v in u.adj iff u in v.adj
    all v: Vertex    | v not in v.adj
}

/** The graph is complete: every pair of different nodes has an edge. 
    This is sometimes called "K_n" for some n: the complete graph on n nodes. */
pred complete {
    all u, v: Vertex | u != v implies v in u.adj
}

/** Our goal: No 2 directly connected nodes have the same color. */
pred validColoring {
    all u, v: Vertex | v in u.adj implies u.color != v.color
}

-- K_4 with 4 colors (should be sat)
k4_4col: run {
    wellFormed
    complete
    validColoring
} for exactly 4 Vertex, exactly 4 Color


-- K_4 with 3 colors (should be unsat)
k4_3col: run {
    wellFormed
    complete
    validColoring
} for exactly 4 Vertex, exactly 3 Color

-- K_5 with 4 colors (should be unsat)
k5_4col: run {
    wellFormed
    complete
    validColoring
} for exactly 5 Vertex, exactly 4 Color

-- K_10 with 4 colors (should be unsat)
k10_4col: run {
    wellFormed
    complete
    validColoring
} for exactly 10 Vertex, exactly 4 Color

-- K_10 with 10 colors (should be sat)
k10_10col: run {
    wellFormed
    complete
    validColoring
} for exactly 10 Vertex, exactly 10 Color
