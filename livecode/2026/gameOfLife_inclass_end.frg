#lang forge/temporal

option run_sterling "gameOfLife_inclass.js"

/*
  Exercise: let's model Conway's Game of Life in Forge. 
  Since Life is all about cells changing state over time, let's use 
  Temporal Forge. That's much more convenient, right?

  We have some design choices to make. 
  How will we approximate an infinite board?
*/

one sig Board {
    var alive: set Int->Int
}

/** Helper to obtain the living neighbors of some (r,c) pair.
    For convenience, this evaluates to a 4-ary relation where
    r and c are always the first two columns. */
fun neighborhoods[alyv: Int->Int]: Int->Int->Int->Int {
    { r: Int, c: Int, r2: Int, c2: Int |
        let rows = (add[r, 1] + r + add[r, -1]) |
        let cols = (add[c, 1] + c + add[c, -1]) |
            (r2->c2) in (alyv & ((rows->cols) - (r->c))) }
}

/** Encodes the GoL cellular-automaton rule. */
pred step {
    let nhood = neighborhoods[Board.alive] |
        // A cell becomes alive if it had 3 cells in the previous state.
        let birthing =  { r: Int, c: Int | 
          (r->c) not in Board.alive and #nhood[r][c] in 3 } |
        // A cell survives if it had 2 or 3 neighbors in a previous state.
        let surviving = { r: Int, c: Int | 
          (r->c) in Board.alive and #nhood[r][c] in (2 + 3) } |
            Board.alive' = birthing + surviving
}

/** Some constraints to make the instance more readable and interesting.
    Fill in what YOU think is suitable here. */
pred pretty {
    // Only use the inner 4x4 of the board
    // - instances that go outside the 4x4 inner space
    // - loses (I think) the 2xALL x2 band oscillator
    //   ... IF we are running deliberately in toroidal
    // Context matters! (it's perfectly fine if running on inf. board)
}

------------

/** This state loops with period=2. */
pred oscillator {
    // characterize a period-2 oscillator
    Board.alive = Board.alive''
    Board.alive != Board.alive'
}

runOscillator : run { 
    always step 
    oscillator 
    pretty
} for 3 Int

/** How can we characterize a "glider"? */ 
pred glider {
    // "same shape" but offset by some x-offset, y-offset
    // *ANY* period, in this case (it's fun to try for p=2 though)
    // We can get +2 with '', +4 with '''', .. 
    // If we don't know the period in advance, use eventually, right?
    // eventually { xNOW = xTHEN } ---> x = x
    // TRICK: *add extra "ghost" state* to keep track of history
    //    or... use a BUNCH of "or"s :-(
    //    or...  drop out of temporal forge and use sig State.
}

