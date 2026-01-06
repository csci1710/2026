#lang forge 

/*
   Continuing to work on the mutex model! Last time we showed that mutual-exclusion is 
   provided, but that's not the only property we want. We also want things like:
     - deadlock freedom (the system as a whole can make progress from any reachable state)
     - non-starvation (whenever interested, every process will _eventually_ get access)
     - ...
*/


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

sig State {
    // where each process is in the program
    //   (should not be used by other processes!)
    loc: func Process -> Location,
    // whether a process's flag is true or not 
    //   (should be visible/used by other processes!)
    flags: set Process
}

pred init[s: State] {
  all p: Process | s.loc[p] = Uninterested
  no s.flags
}

pred raise[pre: State, p: Process, post: State] {
    -- GUARD
    pre.loc[p] = Uninterested
    -- ACTION
    post.loc[p] = Waiting
    post.flags = pre.flags + p
    -- FRAME
    all p2: Process - p | post.loc[p2] = pre.loc[p2]
}
pred enter[pre: State, p: Process, post: State] {
    -- GUARD
    pre.loc[p] = Waiting
    pre.flags in p -- NOTE AS DESIGN CHOICE! 
    -- ACTION
    post.loc[p] = InCS
    post.flags = pre.flags
    -- FRAME
    all p2: Process - p | post.loc[p2] = pre.loc[p2]
}
pred leave[pre: State, p: Process, post: State] {
    -- GUARD
    pre.loc[p] = InCS
    -- ACTION
    post.loc[p] = Uninterested
    post.flags = pre.flags - p
    -- FRAME
    all p2: Process - p | post.loc[p2] = pre.loc[p2]
}

pred delta[pre: State, post: State] {
    some p: Process | {
        raise[pre, p, post] or 
        enter[pre, p, post] or 
        leave[pre, p, post] 
    }
}

showTransition: run {
    some s1, s2: State | delta[s1,s2]
} for exactly 2 Process, exactly 2 State


///////////////////////////////////////////////////////////////////////////
//// MODEL VALIDATION: 
//// Does our *model* reflect the system the way we want? 
///////////////////////////////////////////////////////////////////////////

// Tests of inclusion 

sat_raise: assert {some s1, s2: State, p: Process | 
  raise[s1,p, s2]} is sat
  for exactly 2 Process, exactly 2 State
sat_enter: assert {some s1, s2: State, p: Process | 
  enter[s1,p, s2]} is sat
  for exactly 2 Process, exactly 2 State
sat_leave: assert {some s1, s2: State, p: Process | 
  leave[s1,p, s2]} is sat
  for exactly 2 Process, exactly 2 State
sat_init: assert {some s: State | init[s]} is sat
  for exactly 2 Process, exactly 1 State

// Tests of exclusion

disj_raise_enter: assert {
  some p: Process, s1, s2: State | {
    raise[s1, p, s2] and enter[s1, p, s2]
  }
} is unsat 
for exactly 2 Process, exactly 1 State

/////////////////////////////////////////////////////////////////////
//// SYSTEM VALIDATION: 
//// What properties do we want from the *system*?
/////////////////////////////////////////////////////////////////////

// Requirements

// (1) Mutual exclusion
// Never have more than one process in the critical section at once. 

pred good_me[s: State] { 
    #{p: Process | s.loc[p] = InCS} <= 1
    // ENRICHMENT
    // ... something about flags
}

req_me_init: assert all s: State | init[s] is sufficient for good_me[s]
  for exactly 1 State
req_me_consec: assert all pre, post: State | 
  {good_me[pre] and delta[pre,post]} is sufficient for good_me[post]
  for exactly 2 State 

// (2) Non-starvation 
// If a process indicates interest by flag=true, it will eventually
//  get access. 

pred req_non_starvation {
    all p: Process | {
        all s: State | {
            // if p is interested then 
            // some later state where p gets access
        }
    }
}


// (3) Non-deadlock of the system 
//   Can't have _no_ progress of the system at some point.



one sig Trace {
    initialState: one State,
    nextState: pfunc State -> State 
}

pred trace {
    no Trace.initialState.~(Trace.nextState)
    init[Trace.initialState]
    all s: State | some Trace.nextState[s] => 
        delta[s, Trace.nextState[s]]
}
pred lasso {
    trace 
    // some state can reach itself (the cycle)
    // uniqueness
    // ...
}

