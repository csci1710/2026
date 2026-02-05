#lang forge/froglet
-- First sublanguage

/*

  ********************

  Tim's example avatar:

  Nim Telson is a junior engineer at a database company. Nim didn't get a
  chance to take a databases class in school, so they want to better understand
  some of the data structures used in modern databases. Ideally, they would also 
  learn some techniques that would help them verify those data structures or even 
  implementations of them.

  ********************

  Tim's example responses:

  * How does this assignment relate to my learning goals for this class? Reference the specific learning goals you described regarding your avatar.

  The PBT assignment gives Nim practice at phrasing property goals in natural language
  and property-checking code rather than "point-wise" tests. This is already useful 
  for writing a test suite at Nim's work.
  
  * What role is an LLM like Gemini serving in helping me achieve these learning goals?
  
  In this case, Gemini helps Nim to generate initial code and iterate on expressing 
  the right set of properties for topological sort. 

  * What degree of confidence do you have in the correctness of your generated responses? How did you quantify correctness?

  ...

  * How could you refine your specifications to Gemini to obtain more precise and accurate responses?

  ...


  ********************

  Versioning Reminders:
    - Docs: https://forge-fm.github.io/forge-documentation/5.0/
    - Book: https://forge-fm.github.io/book/2026
    - VSCode: `forge-fm`, not `forge-language-server`
    - Forge: Version 5.X
  (It's necessary to keep multiple versions of these, since others outside 
   Brown use the materials. Unless we need to make a breaking change, you'll
   always be working in version 5 this year.)

   ********************

   This is a basic model of Tic-Tac-toe, built in class on January 26, 2026.
*/

// Step 1: What are the datatypes? 
// Player
// Board, 3x3 matrix / 2d array
// win condition, start condition 
// moves, sequence of steps in the game 

abstract sig Player {}
one sig X, O extends Player {}

sig Board {
    -- Partial function ~= dictionary, (Int x Int) --> Player
    board: pfunc Int -> Int -> Player
}

/** Is a given board well-formed (i.e., not "garbage") */
pred wellformed[b: Board] {
    all row, col: Int | {
        (row < 0 or row > 2 or col < 0 or col > 2)
          implies no b.board[row][col]
    }
}

/** This board is a starting state for the game. */
pred starting[b: Board] {
  all row, col: Int | {
    no b.board[row][col]
  }
}

pred winRow[b: Board, p: Player] {
    some row: Int | {
      all col: Int | (col = 0 or col = 1 or col = 2){
        b.board[row][col] = p
        // b.board[row][1] = p
        // b.board[row][2] = p
      }
    }
}

pred winCol[b: Board, p: Player] {
    some col: Int | {
        b.board[0][col] = p
        b.board[1][col] = p
        b.board[2][col] = p
    }
}

pred winDiag[b: Board, p: Player] {
    { 
      b.board[0][0] = p  
      b.board[1][1] = p
      b.board[2][2] = p
    } or { 
      b.board[0][2] = p  
      b.board[1][1] = p
      b.board[2][0] = p
    }
}

pred winning[b: Board, p: Player] {
    winRow[b, p] or 
    winCol[b, p] or 
    winDiag[b, p]
}

/** It's X's turn in this board */
pred Xturn[b: Board] {
  #{row, col: Int | b.board[row][col] = X}
  = 
  #{row, col: Int | b.board[row][col] = O}
}

/** It's O's turn in this board */
pred Oturn[b: Board] {
  -- NO: not XTurn[b]
  #{row, col: Int | b.board[row][col] = X}
  = 
  add[#{row, col: Int | b.board[row][col] = O}, 1]
}

/** Potentially-reachable board state */
pred balanced[b: Board] {
    Xturn[b] or Oturn[b]
}


// FIND ME: an instance where there's some well-formed board
// "instance" ~= "scenario"
--run { some b: Board | wellformed[b] } for exactly 1 Board
run { 
    some b: Board | {
        wellformed[b]
        balanced[b]
        winning[b, X]
    }
} for exactly 1 Board

// JANUARY 28th 
// We haven't yet modeled the rules of the game, have we?

/** State transition from pre to post, 
    as <p> makes a move at <row>,<col> */
pred move[pre: Board, row: Int, col: Int, p: Player, post: Board] {
  -- GUARD
  --   It's the player's turn to move 
  p = X implies Xturn[pre]
  p = O implies Oturn[pre]
  --   There is no mark in row,col yet
  no pre.board[row][col]
  --   The game is not over (nobody has won)
  not winning[pre, X] 
  not winning[pre, O]
    -- ? where do we check for this?
  --   Row/col should be within the valid spaces
  row >= 0 and row <= 2
  col >= 0 and col <= 2
  -- ACTION
  --   Next player's turn after
  --     (What do we need to do here?)
  --   Mark for player p is now in row,col
  post.board[row][col] = p
  --   "Frame Condition": everything ELSE is the same
  all r2, c2: Int | (r2 != row or c2 != col) implies {
    //pre.board[r2][c2] = post.board[r2][c2] // same thing
    post.board[r2][c2] = pre.board[r2][c2]
  }
}

run { 
    some b1, b2: Board | {
        wellformed[b1]
        balanced[b1]
        some r,c: Int, p: Player | 
          move[b1, r, c, p, b2]
    }
} for exactly 2 Board
