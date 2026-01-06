#lang forge 

/*
  Model of a mutual-exclusion protocol

  What do we _want_ from the protocol?
    - mutual exclusion: at most one thread is in the 
      critical-section at any time
    - no deadlocks: always SOME thread can go at any given
      time
    - non-starvation: if i'm interested, i get to go eventually
    - first come, first served

  ** See the notes for additional tests etc. **
*/

// Note: I'm blurring the process/thread distinction
abstract sig Process {}
one sig ProcessA, ProcessB extends Process {}

// Location in the program
abstract sig Location {}
one sig Disinterested, Waiting, InCS extends Location {}

sig State {
    loc: func Process -> Location,
    flags: set Process
}

pred init[s: State] {
    all p: Process | s.loc[p] = Disinterested
    no s.flags
}

// Disinterested -> Waiting
pred raise[pre: State, p: Process, post: State] {
    pre.loc[p] = Disinterested
    post.loc[p] = Waiting
    post.flags = pre.flags + p
    all p2: Process - p | post.loc[p2] = pre.loc[p2]
}

// Waiting -> InCS
pred enter[pre: State, p: Process, post: State] {
    pre.flags in p -- only p has flag raised (p is singleton set)
    pre.loc[p] = Waiting
    post.loc[p] = InCS
    post.flags = pre.flags
    all p2: Process - p | post.loc[p2] = pre.loc[p2]
}

// InCS -> Disinterested
pred leave[pre: State, p: Process, post: State] {    
    pre.loc[p] = InCS
    post.loc[p] = Disinterested
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

test expect {
    canEnter: {
        some p: Process | some pre, post: State | 
          enter[pre, p, post]
    } is sat
    -- fill in for other transitions, init
}

----------------
-- Mutual exclusion

pred good[s: State] {
    -- Original
    #{p: Process | s.loc[p] = InCS} <= 1
    -- Enrichment
    all p: Process | {
        s.loc[p] = InCS implies p in s.flags
        s.loc[p] = Waiting implies p in s.flags
    }
}

test expect {
    baseCase: {
        some s: State | init[s] and not good[s]
    } for exactly 1 State is unsat
    inductiveCase: {
        some pre, post: State | {
            delta[pre, post]
            good[pre]
            not good[post]
        }
    } for exactly 2 State is unsat
}