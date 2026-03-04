#lang forge 
open "mar02_mutex.frg"

/*
  Some example test shapes. 
  See the BSTs chapter for testing tips: https://forge-fm.github.io/book/2026/chapters/bst/bst.html
*/

// Some very basic tests: all the transitions are possible? Init is possible?
canInit: assert {some s: State | init[s]} is sat
canEnter: assert {some pre: State, t: Thread, post: State | enter[pre, t, post]} is sat
canRaise: assert {some pre: State, t: Thread, post: State | raise[pre, t, post]} is sat
canLeave: assert {some pre: State, t: Thread, post: State | leave[pre, t, post]} is sat

// Check single-transition trace prefixes:
firstEnter: assert {some pre: State, t: Thread, post: State | init[pre] and enter[pre, t, post]} is unsat
firstRaise: assert {some pre: State, t: Thread, post: State | init[pre] and raise[pre, t, post]} is sat
firstLeave: assert {some pre: State, t: Thread, post: State | init[pre] and leave[pre, t, post]} is unsat

// We expect all the transitions to be mutually exclusive. No, we actually expect 
// something stronger: we never see 2 transitions _enabled_ at the same time. This
// is easier to test if we split out the guard of each transition, which we have done now.
disjEnterLeave: assert {some pre: State, t: Thread | 
  enterEnabled[pre, t] and leaveEnabled[pre, t]} is unsat
disjLeaveRaise: assert {some pre: State, t: Thread | leaveEnabled[pre, t] and raiseEnabled[pre, t]} is unsat
disjEnterRaise: assert {some pre: State, t: Thread | enterEnabled[pre, t] and raiseEnabled[pre, t]} is unsat

// ... ... ... We'll add more. 



