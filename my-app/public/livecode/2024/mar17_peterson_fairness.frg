#lang forge 

// STARTING POINT FOR MARCH 17, 2023
//   PETERSON LOCK (but not quite right)

-- enable the temporal solver
option problem_type temporal
-- set maximum trace length (default: 5)
option max_tracelength 10
-- set minimum trace length (default: 1)
-- (The solver does iterative deepening, so a longer minimum length 
--  can sometimes, but not always, speed things up.)
option min_tracelength 1


/*
  Model of a (WORKING) mutual-exclusion protocol called the Peterson Lock.
  
  We have two global pieces of state:
    - a flag for each process
    - a process ID that is "polite"
  
  // run by 2 different processes
  while(true) {
    [DISINTERESTED]
    this.flag = true
    [HALFWAY]
    polite = this
    [WAITING]
    while (other flag == true && polite == me) {};
    // take our turn 
    [IN_CS]
    this.flag = false
  }

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

one sig Flag {}
abstract sig Process {
    var loc: one Location,
    var flag: lone Flag
}
one sig ProcessA, ProcessB extends Process {}

// Location in the program
abstract sig Location {}
one sig Disinterested, Halfway, Waiting, InCS extends Location {}

// Helper sig to hold the global shared variable
one sig Global {
    var polite: lone Process
}

/////////////////////////////////////////////////////////////////////

pred init {
    all p: Process | { 
        p.loc = Disinterested
        no p.flag
    }
    no Global.polite
}

// Disinterested -> Halfway
pred raiseEnabled[p: Process] {
    -- guard
    p.loc = Disinterested
}
pred raise[p: Process] {
    raiseEnabled[p]
    p.loc' = Halfway    
    p.flag' = Flag
    all p2: Process - p | p2.flag' = p2.flag
    all p2: Process - p | p2.loc' = p2.loc
    Global.polite = Global.polite'
}

pred noYouEnabled[p: Process] {
    p.loc = Halfway
}
pred noYou[p: Process] {
    noYouEnabled[p]
    p.loc' = Waiting
    flag' = flag
    Global.polite' = p
    all p2: Process - p | p2.loc' = p2.loc
}

// Waiting -> InCS
pred enterEnabled[p: Process] {
    -- In Peterson, this is now "_either_ only p has flag raised, 
    --   _or_ other process is polite."
    (flag = p->Flag) or (Global.polite != p)    
    p.loc = Waiting
}
pred enter[p: Process] {
    enterEnabled[p]
    p.loc' = InCS
    flag' = flag
    Global.polite = Global.polite'
    all p2: Process - p | p2.loc' = p2.loc
}

// InCS -> Disinterested
pred leaveEnabled[p: Process] {
    p.loc = InCS
}
pred leave[p: Process] { 
    leaveEnabled[p]
    p.loc' = Disinterested
    flag' = flag - (p->Flag)
    Global.polite = Global.polite'
    all p2: Process - p | p2.loc' = p2.loc
}

pred doNothing {
    -- guard
    -- no! this would not limit doNothing at all; it says that 
    --   no other transition predicate _ran_, not _could run_
    --all p: Process | not raise[p] and not enter[p] and not leave[p]
    
    all p: Process | {
        not raiseEnabled[p] and 
        not noYouEnabled[p] and
        not enterEnabled[p] and 
        not leaveEnabled[p]
    }

    -- action
    flag' = flag
    loc' = loc
    Global.polite = Global.polite'
}

pred delta {
    some p: Process | {
        raise[p] or
        noYou[p] or
        enter[p] or
        leave[p]
    } 
    or 
    { 
        doNothing 
    }
}

----------------
-- Mutual exclusion

pred good {
    -- Original
    #{p: Process | p.loc = InCS} <= 1
    -- Enrichment
    all p: Process | {
        p.loc = InCS implies some p.flag
        p.loc = Waiting implies some p.flag
    }
}

-- A test for the SYSTEM (think of as a "public test": assuming we've
--   modeled the system well, if this passes or fails, it tells us something
--   about the SYSTEM, and we can use that knowledge outside the model. E.g.,
--   if this failed, it would mean the algorithm was broken in this way!)
test expect {
    checkSafetyInTemporalMode_counterexample: {
        init
        always delta
        eventually not good
    } is unsat -- if no counterexamples, then our property holds OF THE SYSTEM
}

-- But "assuming we've modeled the system well" is a terrifying assumption!
--   If it fails, and we overly trust the result of such a SYSTEM check, 
--   we could cause a lot of harm in the real world. So we should test
--   the *model itself* in some other way(s). These are a sort of _private_
--   test suite.
test expect {
    -- this isn't about the _algorithm_; it's about our model.
    
    -- VERY SPECIFIC EXAMPLES (still testing the model though)
    -- it would be reasonable to write these first, if you knew about the problem
    --  even without a wheat! but you wouldn't be able to run them

    -- This needed addition of "noYou" for Peterson lock
    processALoops: {
        init
        raise[ProcessA]
        next_state noYou[ProcessA]
        next_state next_state enter[ProcessA]
        next_state next_state next_state leave[ProcessA]
    } is sat
    processTwoThingsUnsat: {
        init
        always delta
        -- only in first state...        
        // raise[ProcessA]
        // enter[ProcessA]        
        -- more powerful:
        // eventually {
        //     raise[ProcessA]
        //     enter[ProcessA]        
        // }
        -- even better
        some p: Process | 
        eventually {
            (raise[p] and enter[p]) or
            (raise[p] and leave[p]) or
            (leave[p] and enter[p])
        }
    } is unsat

    -- debugging: GET CONCRETE!!!
    -- This should be UNSAT now in Peterson lock
    deadlockRegression: {
        init
        -- get concrete:
        raise[ProcessA]
        next_state raise[ProcessB]
        -- did we get frozen here anymore in Peterson? no.
        next_state next_state doNothing
    } is unsat

    -- But that's not really strong enough as a "deadlock" test.
    --  The presence of _any_ doNothing means something is broken, now.    
    deadlockRegression_better: {
        init
        always delta -- BUG
        eventually doNothing
    } is unsat

    -- MORE GENERAL CHECKS OF PROPERTIES (still testing the model)
    lassoSat: { init and always delta } is sat
    onlyOneProcess_counterexample: { 
        init 
        always delta
        eventually {
            some disj p1, p2: Process | {
                // could write raise[p1] or ... 
                // could also write (assumes that loc changes always)
                p1.loc != p1.loc' and p2.loc != p2.loc'
            }
        }
    } is unsat
    raiseFirst: {
        init
        some p: Process | raise[p]
    } is sat
    leaveFirst_counterexample: {
        init
        some p: Process | leave[p]
    } is unsat

}


---------------------------------------------------------------------
-- Liveness: how do we find violations of the property:
--   "it always holds that, whenever a process is interested, it 
--    eventually gets access?" (Mar 06)
--
-- CE to simpler property, that doesn't look at interest:
-- We had a CE that looked like:
--   Dis/0/Dis/0
--   Dis/0/W/1
--   Dis/0/InCS/1
--   Dis/0/Dis/0
--
-- Doing this _without a Trace sig_ via temporal mode
---------------------------------------------------------------------

// run {
//     init
//     always delta
// }

test expect {
    noStarvation_counterexample: {
        init
        always delta
        not {
            -- naive version:
            all p: Process | {
                always { 
                    -- interested if flag is raised (DANGER!)
                    some p.flag implies
                    --p.loc = Waiting implies
                        eventually (p.loc = InCS)
                }
            }
        }
    } is unsat -- we want this to be true in Peterson

}

/////////////////////////////////////////////////////////////////////
// For use in 2nd half of class
/////////////////////////////////////////////////////////////////////

pred weakFairness {
    all p: Process | {
        (eventually always 
                (raiseEnabled[p] or
                 enterEnabled[p] or
                 leaveEnabled[p] or
                 noYouEnabled[p])) 
        => 
        (always eventually (enter[p] or raise[p] or leave[p] or noYou[p]))        
    }
}
