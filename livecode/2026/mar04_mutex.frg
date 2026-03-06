#lang forge 

// Book ex.
// Counter ex.
// Lassos picture
// Revise mutex


/*
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

pred raiseEnabled[pre: State, p: Thread] {
    pre.loc[p] = Uninterested
    p not in pre.flags 
}

/** raise flag (first line) */
pred raise[pre: State, p: Thread, post: State] {
    -- GUARD
    raiseEnabled[pre, p]
    -- ACTION (w/ FRAME)
    post.loc[p] = Waiting
    all t2: Thread | t2 != p => {
        post.loc[t2] = pre.loc[t2]
    }
    post.flags = pre.flags + p // both action + frame
}

pred enterEnabled[pre: State, p: Thread] {
    pre.loc[p] = Waiting
    pre.flags in p
}

/** finish waiting (second line) */
pred enter[pre: State, p: Thread, post: State] {
    -- GUARD
    enterEnabled[pre, p]
    -- ACTION (w/ FRAME)
    post.loc[p] = InCS
    all t2: Thread | t2 != p => {
        post.loc[t2] = pre.loc[t2]
    }
    post.flags = pre.flags

}

pred leaveEnabled[pre: State, p: Thread] {
    pre.loc[p] = InCS
}

/** leave critical section (third/fourth line) */
pred leave[pre: State, p: Thread, post: State] {
   -- GUARD
    leaveEnabled[pre, p]
    -- ACTION (w/ FRAME)
    post.loc[p] = Uninterested
    all t2: Thread | t2 != p => {
        post.loc[t2] = pre.loc[t2]
    }
    post.flags = pre.flags - p
}

/** combined transition predicate */
pred delta[pre: State, post: State] {
    some p: Thread | {
        raise[pre, p, post] or
        leave[pre, p, post] or 
        enter[pre, p, post]
    }
}


/* How should we test this transition system?
       (1) IS THE MODEL ITSELF "GOOD" 
         (i.e., are we modeling correctly)?
          *** This I put in the mutex.test.frg file. ***
       (2) IS THE SYSTEM "GOOD"?
         (i.e., trusting the model, what did we learn about the system?)
          *** This we'll put here. ***
*/

pred mutualExclusion[s: State] {
    #{t: Thread | s.loc[t] = InCS} <= 1
    // Enriched for verification -- "prove" something stronger!
    all t: Thread | {
        s.loc[t] = InCS implies t in s.flags
        s.loc[t] = Waiting implies t in s.flags
    }
}

mutexInitiation:  assert all s: State | 
    init[s] 
    is sufficient for mutualExclusion[s]
mutexConsecution: assert all pre,post: State | {
    mutualExclusion[pre] and delta[pre, post]} 
    is sufficient for mutualExclusion[post]
// Oh, no!  <--- enriched the invariant!
