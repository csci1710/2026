#lang forge/froglet 

/*
  Monday, February 3rd
  
  Today we start doing verification!
    - preservation
    - traces  [deferred the more in-depth trace example]
  
  Plan for next time: we'll probably switch to something more involved than TTT.
  Expect in-class exercise, because the "whirlwind tour" will be over. :-)
  
  Also, Siddhartha (PhD TA) will visit to talk about our autograder + hinting system.
  
  NOTE WELL: the book is more than just the lecture notes! It's worth reading either 
  the binary-search-tree or ripple-carry-adder sections in the "static scenarios"
  chapter.
*/

option run_sterling "ttt.js"

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

pred starting[b: Board] {
    all row, col: Int | {
        no b.board[row][col]
    }
}

pred XTurn2[b: Board] {
    remainder[#{row,col: Int | some b.board[row][col]}, 2] = 0
}

pred XTurn[b: Board] {
  // even number of entries
  // #X = #O
  #{row, col: Int | b.board[row][col] = X}
  = 
  #{row, col: Int | b.board[row][col] = O}
}

diffPreds: run {
  some b: Board | {
    not (XTurn[b] iff XTurn2[b])
  }
}

pred OTurn[b: Board] {
  // defn in terms of XTurn?
  // not XTurn[b] // see notes
  #{row, col: Int | b.board[row][col] = X}
  = 
  add[1, #{row, col: Int | b.board[row][col] = O}]
}

-- 2's comp: 4 bits = 2^4 = 16 Ints to work with
-- [-8, 7]
firstTest: run {some b: Board | starting[b]} for exactly 2 Board, 4 Int

pred winning[b: Board, p: Player] {
    -- win H
    some row: Int | {
        b.board[row][0] = p and
        b.board[row][1] = p and
        b.board[row][2] = p
    }
    or 
    -- win V
    (some col: Int | {
        b.board[0][col] = p 
        b.board[1][col] = p 
        b.board[2][col] = p
    })
    or
    -- win D
    {b.board[0][0] = p
     b.board[1][1] = p
     b.board[2][2] = p} 
    or 
    {b.board[0][2] = p
     b.board[1][1] = p
     b.board[2][0] = p}

}

findWinningX: run {
    some b: Board | { 
        wellformed[b]
        winning[b, X]
        (XTurn[b] or OTurn[b]) // balanced board
    }
} 
  for exactly 1 Board, 4 Int

pred move[pre: Board, r, c: Int, p: Player, post: Board] {
    // GUARD
    no pre.board[r][c]
    p = X implies XTurn[pre]
    p = O implies OTurn[pre]
    // Also guard: prevent invalid moves that would end up non-wellformed
    r >= 0 
    c >= 0 
    r <= 2 
    c <= 2
    // ACTION 
    post.board[r][c] = p
    // FRAME (nothing else changes)
    all r2, c2: Int | (r2 != r or c2 != c) => {
        post.board[r2][c2] = pre.board[r2][c2]
    }
}

///////////////////////////////////////
// Let's do some validation
///////////////////////////////////////

pred all_boards_starting {
    all b: Board | starting[b]
}
example emptyBoardIsStart is all_boards_starting for {
    Board = `Board0 
    X = `X   O = `O
    Player = X + O 
    no `Board0.board 
}

///// Let's some verification /////

pred balanced[b: Board] { 
    (XTurn[b] or OTurn[b]) // balanced board
}
// Show that for every REACHABLE TTT board, balanced holds 

// NOT THIS: 
// run { 
//     some b: Board | wellformed[b] and not balanced[b]
// }

length0: run {
    // Easy special case of reachability: check starting states
    some b: Board | {
        wellformed[b]
        starting[b]
        not balanced[b]
    }
}

length1: run {
    // Can I get to a bad state in 1 move exactly?
    // Approach #1
    some b1, b2: Board | {
        starting[b1] 
        some row, col: Int | some p: Player | {
            move[b1, row, col, p, b2]
        }
        not balanced[b2]
    }
}

lengthX: run {
    // Does move preserve balanced?
    some b1, b2: Board | {
        balanced[b1] 
        // Do we need this? Maybe not: balance should be preserved 
        // even if wellformedness isn't present! This remains unsat. 
        // So why did adding it speed things up?
        // Because sometimes constraints that aren't strictly needed 
        // can give the solver some help (just like sometimes extra 
        // constraints can slow it down...)
        //wellformed[b1] 
        some row, col: Int | some p: Player | {
            move[b1, row, col, p, b2]
        }
        not balanced[b2]
    }
} for exactly 2 Board