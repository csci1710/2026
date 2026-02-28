#lang forge 

/*
  FORGE UPDATE! Version 5.1

  

  while(true) {
      // [state: uninterested]

      this.flag = true;  // raise transition
      // [state: waiting]

      while(other.flag == true); // enter transition
      // [state: in-cs]

      DO_SOMETHING();
      this.flag = false;  // leave transition
      // loop back, return to uninterested state
  }
*/

abstract sig Thread {}
one sig ThreadA, ThreadB extends Thread {} 
abstract sig Location {}
one sig Uninterested, Waiting, InCS extends Location {}

sig State {
    loc: func Thread -> Location,
    flags: set Thread
}

/** Initial state of the system */
pred init[s: State] {
    all t: Thread | s.loc[t] = Uninterested
    // Is there another way to say this?
    // s.loc = Uninterested
    no s.flags 
}

/** raise flag (first line) */
pred raise[pre: State, p: Thread, post: State] {
    -- GUARD
    pre.loc[p] = Uninterested
    p not in pre.flags
    -- ACTION (w/ FRAME)
    post.loc[p] = Waiting
    all t2: Thread | t2 != p => {
        post.loc[t2] = pre.loc[t2]
    }
    post.flags = pre.flags + p // both action + frame
}
/** finish waiting (second line) */
pred enter[pre: State, p: Thread, post: State] {
}
/** leave critical section (third/fourth line) */
pred leave[pre: State, p: Thread, post: State] {
}

/** combined transition predicate */
pred delta[pre: State, post: State] {
}


/* How should we test this transition system?
       (1) IS THE MODEL ITSELF "GOOD" 
         (i.e., are we modeling correctly)?
       (2) IS THE SYSTEM "GOOD"?
         (i.e., trusting the model, what did we learn about the system?)
*/



