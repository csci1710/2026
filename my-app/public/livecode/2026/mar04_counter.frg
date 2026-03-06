#lang forge/temporal
option max_tracelength 16

one sig Counter { var counter: one Int }

pred init { Counter.counter = 0 }
pred step { 
    Counter.counter' = add[Counter.counter, 1] }
run {
    init
    always { step }
} 