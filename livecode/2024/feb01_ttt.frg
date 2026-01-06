#lang forge/bsl

/*
  Tic-tac-toe boards
  Jan 30, 2023 livecode
  Requires Forge 2.3.0+ 
*/

abstract sig Player {}
one sig X, O extends Player {}

sig Board {
    board: pfunc Int -> Int -> Player
}

pred wellformed[b: Board] {
    all row, col: Int | {
        (row < 0 or row > 2 or col < 0 or col > 2) implies
        no b.board[row][col]
    }
}

// run {
//     some b: Board | wellformed[b]
// } for exactly 1 Board

pred Xturn[b: Board] {
    -- same number of X and O on board
    #{row, col: Int | b.board[row][col] = X} = 
    #{row, col: Int | b.board[row][col] = O}
}

pred Oturn[b: Board] {
    #{row, col: Int | b.board[row][col] = X} = 
    add[#{row, col: Int | b.board[row][col] = O}, 1]
}
pred balanced[b: Board] {
    Oturn[b] or Xturn[b]
}

pred winRow[b: Board, p: Player] {
    some row: Int | {
        b.board[row][0] = p
        b.board[row][1] = p
        b.board[row][2] = p
    }
}

pred winCol[b: Board, p: Player] {
    some col: Int | {
        b.board[0][col] = p
        b.board[1][col] = p
        b.board[2][col] = p
    }
}


pred winner[b: Board, p: Player] {
    winRow[b, p]
    or 
    winCol[b, p]
    or {
      b.board[0][0] = p
      b.board[1][1] = p
      b.board[2][2] = p
    } or {
      b.board[0][2] = p
      b.board[1][1] = p
      b.board[2][0] = p
    }
}

// run {    
//     all b: Board | {
//         -- X has won, and the board looks OK
//         wellformed[b]
//         winner[b, X]
//         balanced[b]
//         -- X started in the middle
//         b.board[1][1] = X
//     }
// } for exactly 2 Board

-------------------------------------------------
-- Games

pred starting[b: Board] {
    all row, col: Int | 
        no b.board[row][col]
}

pred move[pre: Board, post: Board, row: Int, col: Int, p: Player] {
    -- GUARD (what needs to hold about the pre-state?)
    no pre.board[row][col] 
    -- no winner yet?
    -- row and col are within [0,2]
    -- correct player's turn

    -- ACTION (what does the post-state then look like?)
}

/*
  Note: the lab stencil for this week shows *one way* to possibly
  fill in the move predicate based on the English above.
*/