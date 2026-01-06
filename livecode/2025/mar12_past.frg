#lang forge/temporal

////////////////////////////

abstract sig Color {}
one sig Red, Green, Yellow extends Color {}

sig Light {
    var color: one Color 
}

fun nextColor[c: Color]: one Color {
    // Method 1: use if-then-else 
    // c = Red => Green else {c = Yellow => Red else Yellow}
    // Method 2: define the relation and use join
    (Red->Green + Yellow->Red + Green->Yellow)[c]
}

pred init {all l: Light | l.color = Red}
pred advance {some l: Light | {
    l.color' = nextColor[l.color]
    all l2: Light-l | l2.color' = l2.color}}

/** The light must eventually turn green -- only enforced in the first state!
    (Also not necessarily true, by the system defined above.) */
pred req_1 {
    all l: Light | {
        eventually { l.color = Green }}}

/** There's always some light going to be red, some light going to be yellow, ...*/
pred req_1a {
    always eventually {some l: Light | l.color = Green}
    always eventually {some l: Light | l.color = Red}
    always eventually {some l: Light | l.color = Yellow}
}

/** the light will be red until it is green -- only enforced in the first state!
    (Also isn't guaranteed by the system defined above. Think about why.) */
pred req_2 {
    all l: Light | {
        l.color = Red until l.color = Green}}


show_light: run {init and always advance}

//req_1_holds: assert {init and always advance} is sufficient for req_1
//req_1a_holds: assert {init and always advance} is sufficient for req_1a
//req_2_holds: assert {init and always advance} is sufficient for req_2

-------------------------------

/* 
  Let's think about the PAST. 
    For the _future_, we have `always` and `eventually`. 
    This isn't so obviously useful in the traffic model, but consider:
      "If someone graduates, they should have previously taken an intro sequence."
      ...in a model where courses taken isn't reified into _persistent state_. 
      ""
*/