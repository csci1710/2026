#lang forge/temporal

one sig Counter { var counter: one Int }

pred init { Counter.counter = 0 }
pred step { Counter.counter' = add[Counter.counter, 1] }







run {
    init
    always { step }
}