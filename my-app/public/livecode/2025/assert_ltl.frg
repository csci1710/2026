#lang forge/temporal 
option max_tracelength 16
one sig C { var count: one Int }
pred init {C.count = 0}
pred delta {C.count' = add[C.count, 1] }
pred traces {
    // start
    init
    // transition
    always delta}
///////////////////////////////////////////////////////////
// Passes (unsat because no counterexample trace)
//withoutAlways: assert {C.count >= 0} is necessary for traces

///////////////////////////////////////////////////////////
// Test of inclusion (model): make sure traces is satisfiable, 
// since "X is necessary for traces" asks whether "traces => X".
// checkVacuous: assert {traces} is sat

///////////////////////////////////////////////////////////
// Fails (sat, found counterexample trace)
withAlways:    assert {always {C.count >= 0}} is necessary for traces






// Why does this pass? Let's ask the solver to help localize a cause.

// // Change the current boolean solver from the default, Java-based solver 
// // to a native solver called Minisat -- with "core extraction" enabled.
// option solver MiniSatProver
// // Preserve info in the translation between Forge and boolean satisfiability
// option logtranslation 1
// option coregranularity 1
// // Set the algorithm used to minimize the blame info. "rce" will produce 
// // something truly minimal, but is not always performant. "hybrid" is 
// // more performant, but is not guaranteed minimal.
// option core_minimization rce
// // Turn off Sterling to avoid annoyance (not an issue in this example)
// option run_sterling off

// At the moment, we need to comment out other runs/tests...
withoutAlways: assert {C.count >= 0} is necessary for traces
/*
   not {traces => C.count >= 0}   <----- unsat
*/
// Note: some things won't be highlighted
//   * under-the-hood temporal structure constraints
//   * bounds (these apply BEFORE the solver can start finding blame)
//   * min_tracelength (same)
