#lang forge 

// Note: you need to restart VSCode to update our extension. :-) 

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
}
pred enter[pre: State, p: Process, post: State] {
}
pred leave[pre: State, p: Process, post: State] {
    -- GUARD
    pre.loc[p] = InCS
    -- ACTION
    post.loc[p] = Uninterested
    post.flags = pre.flags - p
    all p2: Process - p | post.loc[p2] = pre.loc[p2]
}

pred delta[pre: State, post: State] {
    some p: Process | {
        raise[pre, p, post] or 
        enter[pre, p, post] or 
        leave[pre, p, post] 
    }
}