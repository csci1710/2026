#lang forge/temporal

// one sig Counter { var counter: lone Int }

// pred init { no Counter.counter }
// pred step { 
//     Counter.counter' = add[Counter.counter, 1] }
// run {
//     init
//     always { step }
// } for 2 Int

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
    always {
        // World.loc = World.loc'
        // World.flags = World.flags'
        some p: Thread | {
            enter[p] or raise[p] or leave[p]
        }
    }
}


