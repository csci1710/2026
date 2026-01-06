#lang forge/temporal

option max_tracelength 10 

// The "world" at any given moment
one sig Counter {
    var count: one Int
}

run {
    Counter.count = 0
    always { 
        (Counter.count' = add[Counter.count, 1])
        or
        (Counter.count' = add[Counter.count, 2])
    }
} for 3 Int 
