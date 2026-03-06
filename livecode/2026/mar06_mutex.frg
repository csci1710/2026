#lang forge/temporal 

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

one sig World {
    var loc: func Thread -> Location,
    var flags: set Thread
}

/** Initial state of the system */
pred init {
    all t: Thread | World.loc[t] = Uninterested
    no World.flags 
}

pred raiseEnabled[p: Thread] {
    World.loc[p] = Uninterested
    p not in World.flags 
}

/** raise flag (first line) */
pred raise[p: Thread] {
    -- GUARD
    raiseEnabled[p]
    -- ACTION (w/ FRAME)
    World.loc'[p] = Waiting
    all t2: Thread | t2 != p => {
        World.loc'[t2] = World.loc[t2]
    }
    World.flags' = World.flags + p // both action + frame
}

pred enterEnabled[p: Thread] {
    World.loc[p] = Waiting
    World.flags in p
}

/** finish waiting (second line) */
pred enter[p: Thread] {
    -- GUARD
    enterEnabled[p]
    -- ACTION (w/ FRAME)
    World.loc'[p] = InCS
    all t2: Thread | t2 != p => {
        World.loc'[t2] = World.loc[t2]
    }
    World.flags' = World.flags
}



pred leaveEnabled[p: Thread] {
    World.loc[p] = InCS
}

/** leave critical section (third/fourth line) */
pred leave[p: Thread] {
   -- GUARD
    leaveEnabled[p]
    -- ACTION (w/ FRAME)
    World.loc'[p] = Uninterested
    all t2: Thread | t2 != p => {
        World.loc'[t2] = World.loc[t2]
    }
    World.flags' = World.flags - p
}

option max_tracelength 10

run {
    init 
    // In relational Forge, we could say "all s: State"
    // and Forge could satisfy this with a 3-state trace
    always {
        // every state starting now must...
        some p: Thread | {
            enter[p] or raise[p] or leave[p]
        }
    }
}



// our old property... right???
pred mutualExclusion {
    always {
        #{t: Thread | World.loc[t] = InCS} <= 1
        // Enriched for verification -- "prove" something stronger!
        all t: Thread | {
            World.loc[t] = InCS implies t in World.flags
            World.loc[t] = Waiting implies t in World.flags
        }
    }
}

// mutexInitiation:  assert all s: State | 
//     init[s] 
//     is sufficient for mutualExclusion[s]
// mutexConsecution: assert all pre,post: State | {
//     mutualExclusion[pre] and delta[pre, post]} 
//     is sufficient for mutualExclusion[post]
// // Oh, no!  <--- enriched the invariant!

pred nonStarvation {
    always {
        all t: Thread | {
            eventually {
                //all t: Thread | World.loc[t] = InCS
                World.loc[t] = InCS
            }
        }
    }
}