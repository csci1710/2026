#lang forge

-- CASE SENSITIVE
option solver MiniSatProver
option coregranularity 1
option logtranslation 1
-- rce = really minimal
option core_minimization rce

sig Node {
    edges: set Node
}
one sig Providence, Boston extends Node {}

run {
    no iden & edges -- anti-reflexive
    edges = ~edges  -- symmetric
    all n: Node | n not in n.^edges -- no cycles
    all disj n1, n2: Node | n1 in n2.^edges -- connected
} for 5 Node




-- CASE SENSITIVE:
// option solver MiniSatProver
// option logtranslation 1
// option coregranularity 1
// -- truly minimal. If slow, switch to "hybrid" for best effort
// option core_minimization rce
