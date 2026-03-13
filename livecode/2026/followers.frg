#lang forge 

//abstract 
sig Person {
  followers: set Person
}
one sig Alice, Bob, Charlie extends Person {}
run {some followers} //for exactly 3 Person 

/*
  (9) followers: AA AB AC BA BB BC CA CB CC
  (1) is there a 4th person or not?
  (7) AD BD CD DD DA DB DC
*/











/*

ALWAYS 
EVENTUALLY
UNTIL
NEXT_STATE

...
prev_state X  (in the first state)
  false
prev_state false 
  false
prev_state true 
  false 

*/