#lang forge/temporal

sig Counter {
    var count: one Int
}
pred trace {
    all c: Counter | c.count = 0
    always {
        all c: Counter | c.count' = add[c.count, 1]
    }
}

// REQUIREMENT: The counters always agree...
req_counters_agree: assert {
    // For every state, starting now, they agree
    always { 
        all c1, c2: Counter | c1.count = c2.count
    }
} is necessary for trace

////////

abstract sig Color {}
one sig Red, Green, Yellow extends Color {}

sig Light {
    var color: one Color 
}

// the cars all stopped!
pred stopped {}

// The light must eventually turn green
pred req_1 {
    all l: Light | {
        eventually { l.color = Green }
    }
}

// the stopped predicate must hold true until the light turns green
pred req_2 {
    all l: Light | {
        // Problem?: what should happen when the color IS green
        // Problem?: should this also mean the light does turn green?
        // Problem?: what happens after the obligation is met?
        // always {l.color != Green implies stopped}

        stopped until l.color = Green
    }
}