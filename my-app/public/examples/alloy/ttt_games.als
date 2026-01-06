/*
  Tic-tac-toe games model (TN Jan 2023)
  Adapted from Forge lecture notes for Alloy tour (Part 2)
*/

-- Enforce a total ordering on Board objects.
--   Beware: this enforces *exact* cardinality as well; if 
--   we say "for 9 Board", that will be rewritten to "for exactly 9 Board".
open util/ordering[Board]

abstract sig Player {}
one sig X, O extends Player {}

sig Board {
  board: Int -> Int -> Player
}

pred wellformed[s: Board] {
  -- row and column numbers used are between 0 and 2, inclusive  
  all row, col: Int | {
    (row < 0 or row > 2 or col < 0 or col > 2) 
      implies no s.board[row][col]      
  }
  -- at most one player may move in any square
  all row, col: Int | {
    lone s.board[row][col]
  }
}

run { some b: Board | wellformed[b]} 

------------------------------------------------------

pred XTurn[s: Board] {
  #{row, col: Int | s.board[row][col] = X} =
  #{row, col: Int | s.board[row][col] = O}
}

pred OTurn[s: Board] {
  #{row, col: Int | s.board[row][col] = X} =
  add[#{row, col: Int | s.board[row][col] = O}, 1]
}

pred winRow[s: Board, p: Player] {
  -- note we cannot use `all` here because there are more Ints  
  some row: Int | {
    s.board[row][0] = p
    s.board[row][1] = p
    s.board[row][2] = p
  }
}

pred winCol[s: Board, p: Player] {
  some column: Int | {
    s.board[0][column] = p
    s.board[1][column] = p
    s.board[2][column] = p
  }      
}

pred winner[s: Board, p: Player] {
  winRow[s, p]
  or
  winCol[s, p]
  or 
  {
    s.board[0][0] = p
    s.board[1][1] = p
    s.board[2][2] = p
  }
  or
  {
    s.board[0][2] = p
    s.board[1][1] = p
    s.board[2][0] = p
  }  
}

pred balanced[s: Board] {
  XTurn[s] or OTurn[s]
}
run { some b: Board | wellformed[b] and balanced[b]} 

run { some b: Board | wellformed[b] and balanced[b]} 
for exactly 1 Board

run { all b: Board | wellformed[b] and balanced[b]} 

------------------------------------------------------

pred move[pre: Board, row: Int, col: Int, p: Player, post: Board] {
  -- guard:
  no pre.board[row][col]   -- nobody's moved there yet
  p = X implies XTurn[pre] -- appropriate turn
  p = O implies OTurn[pre]  
  
  -- action:
  post.board[row][col] = p
  -- Buggy frame condition:
//  all row2: Int-row, col2: Int-col | {        
//     post.board[row2][col2] = pre.board[row2][col2]     
//  }  
  -- Correct frame condition
  all row2: Int, col2: Int | 
    ((row2 != row) or (col2 != col)) implies {    
       post.board[row2][col2] = pre.board[row2][col2]     
  }  
}

-- Generating Transitions
run {  
  some pre, post: Board | {
    wellformed[pre]
    some row, col: Int, p: Player | 
      move[pre, row, col, p, post]
    not winner[pre, X]
    not winner[pre, O]
    winner[post, X]    
  }
} 

------------------------------------------------------

-- A pair of boards with a move between them, 
--   where X has won in the pre-state, but 
--   has no longer won in the post-state
pred winningPreservedCounterexample {
  some pre, post: Board | {
    some row, col: Int, p: Player | 
      move[pre, row, col, p, post]
    winner[pre, X]
    not winner[post, X]
  }
}
run {
  all s: Board | wellformed[s]
  winningPreservedCounterexample
}

-------------------------------------------------------
-- Start part 2
-------------------------------------------------------

pred starting[s: Board] {
  all row, col: Int | 
    no s.board[row][col]
}


-- Assert this predicate to ask Alloy for a trace
pred traces {
    -- The trace starts with an initial state
    starting[first]     
    -- Every transition is a valid move
    all s: Board | some s.next implies {
      some row, col: Int, p: Player |
        move[s, row, col, p, s.next]
    }
}

-- 10 states is just enough for a full game
run { traces } for 10 Board 


