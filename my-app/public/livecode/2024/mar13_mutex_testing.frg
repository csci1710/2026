#lang forge 

-- enable the temporal solver
option problem_type temporal
-- set maximum trace length (default: 5)
option max_tracelength 10
-- set minimum trace length (default: 1)
-- (The solver does iterative deepening, so a longer minimum length 
--  can sometimes, but not always, speed things up.)
option min_tracelength 1


/*
  Model of a mutual-exclusion protocol

  // run by 2 different processes
  while(true) {
    this.flag = true
    while(other.flag == true) {}
    // take our turn 
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
one sig Disinterested, Waiting, InCS extends Location {}

-- temporal mode manages state _change_ itself
// one sig State {
//     var loc: func Process -> Location,
//     var flags: set Process
// }

-- formulas are evaluated with respect to some state index
-- init: "the first state is initial"
-- next_state init: "the second state is initial"
-- next_state next_state init: "the third state is initial"
pred init {
    all p: Process | { 
        p.loc = Disinterested
        no p.flag
    }
}

// Disinterested -> Waiting
pred raiseEnabled[p: Process] {
    -- guard
    p.loc = Disinterested
}
pred raise[p: Process] {
    raiseEnabled[p]
    p.loc' = Waiting
    --flag' = flag + (p -> Flag) 
    p.flag' = Flag
    all p2: Process - p | p2.flag' = p2.flag
    all p2: Process - p | p2.loc' = p2.loc
}

// Waiting -> InCS
pred enterEnabled[p: Process] {
    flag = p->Flag -- only p has flag raised (TODO: in?)
    p.loc = Waiting
}
pred enter[p: Process] {
    enterEnabled[p]
    p.loc' = InCS
    flag' = flag
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
    all p2: Process - p | p2.loc' = p2.loc
}

pred doNothing {
    -- guard
    -- no! this would not limit doNothing at all; it says that 
    --   no other transition predicate _ran_, not _could run_
    --all p: Process | not raise[p] and not enter[p] and not leave[p]
    
    all p: Process | {
        not raiseEnabled[p] and not enterEnabled[p] and not leaveEnabled[p]
    }

    -- action
    flag' = flag
    loc' = loc
}

pred delta {
    some p: Process | {
        raise[p] or
        enter[p] or
        leave[p] or 
        doNothing
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
        not always good -- at some point, mutual-exclusion fails
    } is unsat -- if no counterexamples, then our property holds OF THE SYSTEM
}
-- But "assuming we've modeled the system well" is a terrifying assumption!
--   If it fails, and we overly trust the result of such a SYSTEM check, 
--   we could cause a lot of harm in the real world. So we should test
--   the *model itself* in some other way(s). These are a sort of _private_
--   test suite.
test expect {
    -- this isn't about the _algorithm_; it's about our model.
    initSatisfiable: { init } is sat
    tracesSatisfiable: { init and always delta} is sat
    -- ...but bugs aren't always that straightforward
    canEnterInitially: {
        -- take enter IN FIRST STATE
        -- assuming init in first state
        init
        some p: Process | enter[p]
    } is unsat
    canRaiseInitially: {
        some p: Process | raise[p]
    } is sat
    singleLoopInitially: {
        init
        always delta 
        -- ^ these 2 lines aren't strictly necessary, 
        -- but they widen the chance to fail
        some p: Process | {
            raise[p]
            next_state enter[p]
            next_state next_state leave[p]
        }
    } is sat
    
    -- VERY SPECIFIC EXAMPLES (still testing the model though)
    -- it would be reasonable to write these first, if you knew about the problem
    --  even without a wheat! but you wouldn't be able to run them
    testDeadlockScenario_sat: {
        init
        always delta 

        raise[ProcessA]
        next_state raise[ProcessB]
        next_state next_state doNothing -- ...
    } is sat
    testDeadlockScenario_unsat: {
        init
        always delta 

        raise[ProcessA]
        next_state raise[ProcessB]
        next_state next_state enter[ProcessA] -- can't do this, we're stuck
    } is unsat


}


// test expect {
//     baseCase: {
//         some s: State | init[s] and not good[s]
//     } for exactly 1 State is unsat
//     inductiveCase: {
//         some pre, post: State | {
//             delta[pre, post]
//             good[pre]
//             not good[post]
//         }
//     } for exactly 2 State is unsat
// }

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
                    -- interested if flag is raised
                    some p.flag implies
                    --p.loc = Waiting implies
                        eventually (p.loc = InCS)
                }
            }
        }
    } is sat // failure of property

}

// re-add "test" to run this block if you make changes
test expect {
    testDoNothing_canHappen: {
        init
        always delta
        eventually doNothing
    } is sat
    testDoNothing_cantHappenFirst: {
        init
        always delta
        doNothing -- in the first state!
    } is unsat
    testDoNothing_restrictions: {
        init
        always delta
        // counterexample
        // TODO ... add other 2 normal transitions
        not { always (doNothing => {all p: Process | not raiseEnabled[p]}) } 
    } is unsat
}

// A until B
//   eventually B happens, _and_
//   until that point, A must hold
//   "if nobody else is Waiting, then nobody else is InCS until I am"

// past-time operators
//   prev_state etc. 

