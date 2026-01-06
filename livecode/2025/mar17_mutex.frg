#lang forge/temporal 

/*
  THIS WEEK (Mar 17, Mar 19, Mar 21)
 
  TODAY: Peterson Lock
  WEDNESDAY: How Forge Works (+ Peterson overflow, if needed)
  FRIDAY: *ZOOM ACCESSIBLE*: Debugging Advice, some Tricks, Q&A
*/

// Default 5 
option max_tracelength 10

/*
  Let's model a (potential) mutual-exclusion algorithm! 
  Both threads run this:

  polite = null

  while(true) {
    // state: uninterested
    this.flag = true; 
    // state: halfway
    polite = me; 
    // state: waiting
    while(other.flag == true || polite != me) {}; // busy-wait until the other thread is done
    // state: in-cs
    run_critical_section(); // does whatever, we don't care
    this.flag = false; 
  }

*/

abstract sig Location {} 
one sig Uninterested, Halfway, Waiting, InCS extends Location {}

abstract sig Process {}
one sig ProcessA, ProcessB extends Process {}

/** There are lots of ways to model this. We could put loc and flags in the
    Process sig, for one thing. But I'll group all state together for this model. */ 
one sig World {
    // where each process is in the program
    //   (should not be used by other processes!)
    var loc: func Process -> Location,
    // whether a process's flag is true or not 
    //   (should be visible/used by other processes!)
    var flags: set Process,
    // who is being polite, if anyone
    var polite: lone Process
}

/**  Are we in an initial state right now? */
pred init {
  all p: Process | World.loc[p] = Uninterested
  no World.flags
  no World.polite
}

/** Is the `raise` action possible for this process to take now? */
pred raiseEnabled[p: Process] { World.loc[p] = Uninterested }
// Are we taking the raise transition right now?
pred raise[p: Process] {
    -- GUARD
    raiseEnabled[p]
    -- ACTION
    World.loc'[p] = Halfway
    World.flags' = World.flags + p
    -- FRAME
    all p2: Process - p | World.loc'[p2] = World.loc[p2]
    World.polite' = World.polite
}

/** Is the `defer` action possible for this process to take now? */
pred deferEnabled[p: Process] { World.loc[p] = Halfway }
pred defer[p: Process] {
    -- GUARD
    deferEnabled[p]
    -- ACTION
    World.loc'[p] = Waiting
    World.polite' = p
    -- FRAME
    all p2: Process - p | World.loc'[p2] = World.loc[p2]
    World.flags' = World.flags
}

/** Is the `enter` action possible for this process to take now? */
pred enterEnabled[p: Process] { 
    World.loc[p] = Waiting
    (World.flags in p or World.polite != p)
}
pred enter[p: Process]  {
    -- GUARD
    enterEnabled[p]
    -- ACTION
    World.loc'[p] = InCS
    World.flags' = World.flags
    -- FRAME
    all p2: Process - p | World.loc'[p2] = World.loc[p2]
    World.polite' = World.polite
}

/** Is the `leave` action possible for this process to take now? */
pred leaveEnabled[p: Process] { World.loc[p] = InCS }
pred leave[p: Process] {
    -- GUARD
    leaveEnabled[p]
    -- ACTION
    World.loc'[p] = Uninterested
    World.flags' = World.flags - p
    -- FRAME
    all p2: Process - p | World.loc'[p2] = World.loc[p2]
    World.polite' = World.polite
}

/** Do nothing for a step. Should only be usable if all other actions are disabled. */
pred doNothing {
    -- GUARD 
    all p: Process | {
        not leaveEnabled[p]
        not enterEnabled[p]
        not raiseEnabled[p]
        not deferEnabled[p]
    }

    -- ACTION/FRAME
    World.loc' = World.loc 
    World.flags' = World.flags
    World.polite' = World.polite
}

// Take a transition right now 
pred delta {
    some p: Process | {
        raise[p] or 
        enter[p] or 
        leave[p] or 
        defer[p]
    } or 
    doNothing
}

showTransition: run { 
    init
    always { delta }
} for exactly 2 Process


///////////////////////////////////////////////////////////////////////////
//// MODEL VALIDATION: 
//// Does our *model* reflect the system the way we want? 
///////////////////////////////////////////////////////////////////////////

DEBUG_prestate: assert {
    init
    always {delta}
    eventually { 
        World.loc[ProcessA] = Waiting
        World.loc[ProcessB] = InCS
        World.flags = ProcessA + ProcessB
        // GIVEN: World.polite = ProcessB // unsat
        // TESTING:
           World.polite = ProcessA // sat
    }
} is sat

// If a process p is in the critical section, it cannot be that World.polite = p
// ^ Too strong
// If a process p is in the critical section, either:
//   - it is impolite OR
//   - the other process isn't Waiting




// Tests of inclusion 

sat_raise: assert {some p: Process | raise[p]} is sat
  for exactly 2 Process
sat_enter: assert {some p: Process | enter[p]} is sat
  for exactly 2 Process
sat_leave: assert {some p: Process | leave[p]} is sat
  for exactly 2 Process
sat_defer: assert {some p: Process | defer[p]} is sat
  for exactly 2 Process


// *** !!! These mean different things. ***
//sat_init: assert {some s: State | init[s]} is sat
sat_init: assert {init} is sat
  for exactly 2 Process

/** Notice: we can write _prefix_ tests like this. This is a useful debugging 
    technique if you're getting UNSAT on finding lasso traces, because nothing here 
    says that the lasso trace has to follow the system _after_ the last next_state use. */
sat_processA_loop: assert {
    init
    raise[ProcessA]
    next_state defer[ProcessA]
    next_state next_state enter[ProcessA]
    next_state next_state next_state leave[ProcessA]
} is sat


// Tests of exclusion

disj_raise_enter: assert {
  some p: Process | { eventually { raise[p] and enter[p] } }
} is unsat for exactly 2 Process

disj_raise_defer: assert {
  some p: Process | { eventually { raise[p] and defer[p] } }
} is unsat for exactly 2 Process

// ... and so on ... 


// /////////////////////////////////////////////////////////////////////
// //// SYSTEM VALIDATION: 
// //// What properties do we want from the *system*?
// /////////////////////////////////////////////////////////////////////

// // Requirements

// (1) Mutual exclusion
// Never have more than one process in the critical section at once. 

// We'll use the inductive technique to check this. We had an interesting
// discussion about whether certain operators were needed in this context. 
//  I've taken some notes on that discussion. 

pred good_me { 
    // MUTUAL EXCLUSION
    #{p: Process | World.loc[p] = InCS} <= 1

    // ENRICHMENT: FORBID PRESTATES WITH BAD FLAG USE
    all p: Process | World.loc[p] in (InCS + Waiting + Halfway) implies p in World.flags 
    // ENRICHMENT: FORBID PRESTATES WITH BAD POLITENESS

    // Needs excluding, but too weak...
    (some p: Process | World.loc[p] in (InCS + Waiting)) implies
       some World.polite

    // Stronger:
    // (World.polite != p1)
    
    all disj p1,p2: Process | (World.loc[p1] = InCS) => { 
    
        // Maybe I'm not the polite one (implying the other process arrived either just after
        // I was being polite, or after I entered the critical section.)
        World.polite != p1
        or
        // Maybe they aren't interested at all, so it doesn't matter if I'm polite.
        (p2 not in World.flags)
        or 
        // Maybe I moved in when their flag was false, but then they became interested.
        // Here, they'd be in Halfway... (we could also write this as, their flag is true
        //   but I am the polite one still).
        World.loc[p2] in Halfway
    }
    
}

-- If the initial state is really initial, then it's good. 
req_me_init: assert init is sufficient for good_me
-- Why don't we need `always` here? Because we're using the inductive approach. 
--   Temporal Forge will indeed always give us a full trace, but we have not said 
--   it must be a _valid trace of this system_. Thus, we can ignore everything but 
--   the first state. If we started to do something more complex, we'd want to 
--   think carefully about whether `always` is needed. 

pred next_good_me {
    -- next_state: advance the state index by one
    next_state good_me}

req_me_consec: assert  
 {good_me and delta} is sufficient for next_good_me

-- Why no `always` here? Again, because we're using the inductive method, 
-- we only care about the first two states of the trace Forge finds us. 
-- the "trace that Forge finds" isn't necessarily a valid system trace,
-- just the first transition is so constrained. 


// (2) Non-starvation 
// If a process indicates interest by flag=true, it will eventually get access. 

// Initial try: it turns out this isn't *quite* right, though.
// (It passes; what could be /wrong/?)
pred non_starvation {
    always { 
        all p: Process | {
            // if p is interested then 
            // Passes:
            // (World.loc[p] = Waiting) implies
            // What if:
            (p in World.flags) implies
            // This ends up OK too. But we are forgetting something. We modeled the processes
            // as constantly seeking access; they have no option to _remain uninterested_. 
            // Exercise: add this, and consider the consequences for the model. 
            // (It turns out that this is why we need the flags still, and politeness
            //  isn't enough.)
            // some later state where p gets access
                (eventually World.loc[p] = InCS)
        }}}
req_non_starvation: 
  assert {init and always delta} is sufficient for non_starvation
