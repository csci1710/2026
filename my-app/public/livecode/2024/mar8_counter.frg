#lang forge

-- enable temporal operators
option problem_type temporal
-- enable traces of up to length 10 (default is 5)
option max_tracelength 10
-- enable traces of length as small as 1 (default is 1)
option min_tracelength 1

one sig Counter {
  -- If a field is labeled "var", it can change over time
  var counter: one Int
}

run {
-- Temporal-mode formulas "start" at the first state
-- The counter starts out at 0
  Counter.counter = 0
  -- The counter is incremented every transition:
  always Counter.counter' = add[Counter.counter, 1]
} for 3 Int 
-- [-4, 3]