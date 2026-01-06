#lang forge/froglet 

// Players 
abstract sig Player {}
one sig X, O extends Player {}

// Board 
sig Board {
    // Partial function from (Int,Int) to Player
    board: pfunc Int -> Int -> Player
}

pred wellformed[b: Board] {
    all row, col: Int | {
        (row < 0 or row > 2 or col < 0 or col > 2)
        implies no b.board[row][col]
    }
}

run {some b: Board | wellformed[b]} for exactly 2 Board
// turns 
// end conditions 
// valid placements
// valid states 
// 