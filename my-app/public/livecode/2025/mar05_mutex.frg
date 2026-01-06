#lang forge/temporal 

// Default 5 
option max_tracelength 10

/*
  Let's model a (potential) mutual-exclusion algorithm! 
  Both threads run this:

  while(true) {
    // state: uninterested
    this.flag = true; 
    // state: waiting
    while(other.flag == true) {}; // busy-wait until the other thread is done
    // state: in-cs
    run_critical_section(); // does whatever, we don't care
    this.flag = false; 
  }

*/

abstract sig Location {} 
one sig Uninterested, Waiting, InCS extends Location {}

abstract sig Process {}
one sig ProcessA, ProcessB extends Process {}

one sig World {
    // where each process is in the program
    //   (should not be used by other processes!)
    var loc: func Process -> Location,
    // whether a process's flag is true or not 
    //   (should be visible/used by other processes!)
    var flags: set Process
}

// Are we in an initial state right now?
pred init {
  all p: Process | World.loc[p] = Uninterested
  no World.flags
}

// Are we taking the raise transition right now?
pred raise[p: Process] {
    -- GUARD
    World.loc[p] = Uninterested
    -- ACTION
    World.loc'[p] = Waiting
    World.flags' = World.flags + p
    -- FRAME
    all p2: Process - p | World.loc'[p2] = World.loc[p2]
}
pred enter[p: Process]  {
    -- GUARD
    World.loc[p] = Waiting
    World.flags in p -- NOTE AS DESIGN CHOICE! 
    -- ACTION
    World.loc'[p] = InCS
    World.flags' = World.flags
    -- FRAME
    all p2: Process - p | World.loc'[p2] = World.loc[p2]
}
pred leave[p: Process] {
    -- GUARD
    World.loc[p] = InCS
    -- ACTION
    World.loc'[p] = Uninterested
    World.flags' = World.flags - p
    -- FRAME
    all p2: Process - p | World.loc'[p2] = World.loc[p2]
}

// Take a transition right now 
pred delta {
    some p: Process | {
        raise[p] or 
        enter[p] or 
        leave[p] 
    }
}

showTransition: run { 
    init
    // delta 
    // next_state delta
    always { delta }
} for exactly 2 Process


///////////////////////////////////////////////////////////////////////////
//// MODEL VALIDATION: 
//// Does our *model* reflect the system the way we want? 
///////////////////////////////////////////////////////////////////////////

// // Tests of inclusion 

// sat_raise: assert {some s1, s2: State, p: Process | 
//   raise[s1,p, s2]} is sat
//   for exactly 2 Process, exactly 2 State
// sat_enter: assert {some s1, s2: State, p: Process | 
//   enter[s1,p, s2]} is sat
//   for exactly 2 Process, exactly 2 State
// sat_leave: assert {some s1, s2: State, p: Process | 
//   leave[s1,p, s2]} is sat
//   for exactly 2 Process, exactly 2 State
// sat_init: assert {some s: State | init[s]} is sat
//   for exactly 2 Process, exactly 1 State

// // Tests of exclusion

// disj_raise_enter: assert {
//   some p: Process, s1, s2: State | {
//     raise[s1, p, s2] and enter[s1, p, s2]
//   }
// } is unsat 
// for exactly 2 Process, exactly 1 State

// /////////////////////////////////////////////////////////////////////
// //// SYSTEM VALIDATION: 
// //// What properties do we want from the *system*?
// /////////////////////////////////////////////////////////////////////

// // Requirements

// // (1) Mutual exclusion
// // Never have more than one process in the critical section at once. 

// pred good_me[s: State] { 
//     #{p: Process | s.loc[p] = InCS} <= 1
//     // ENRICHMENT
//     // ... something about flags
// }

// req_me_init: assert all s: State | init[s] is sufficient for good_me[s]
//   for exactly 1 State
// req_me_consec: assert all pre, post: State | 
//   {good_me[pre] and delta[pre,post]} is sufficient for good_me[post]
//   for exactly 2 State 

// // (2) Non-starvation 
// // If a process indicates interest by flag=true, it will eventually
// //  get access. 

// pred req_non_starvation {
//     all p: Process | {
//         all s: State | {
//             // if p is interested then 
//             // some later state where p gets access
//         }
//     }
// }


// // (3) Non-deadlock of the system 
// //   Can't have _no_ progress of the system at some point.



// one sig Trace {
//     initialState: one State,
//     nextState: pfunc State -> State 
// }

// pred trace {
//     no Trace.initialState.~(Trace.nextState)
//     init[Trace.initialState]
//     all s: State | some Trace.nextState[s] => 
//         delta[s, Trace.nextState[s]]
// }
// pred lasso {
//     trace 
//     // some state can reach itself (the cycle)
//     // uniqueness
//     // ...
// }

