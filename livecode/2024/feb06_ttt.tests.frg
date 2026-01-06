#lang forge/bsl "class_ttt" "tim_nelson@brown.edu"
open "feb06_ttt.frg"

pred allWellformed {
    all b: Board | wellformed[b]
}

test suite for allWellformed {
    // allWellformed returns true for this instance
    example middleRowWellFormed is {allWellformed} for {
        X = `X0
        O = `O0
        Player = `X0 + `O0
        Board = `Board0
        board = `Board0 -> (1 -> 0 -> `X0 +
                            1 -> 1 -> `X0 + 
                            1 -> 2 -> `X0)
    }

    // allWellformed returns true for this instance
    example twoBoards is {allWellformed} for {
        X = `X0
        O = `O0
        Player = `X0 + `O0
        Board = `Board0 + `Board1
        board = `Board0 -> (1 -> 0 -> `X0 +
                            1 -> 1 -> `X0 + 
                            1 -> 2 -> `X0)
                        +
                `Board1 -> (0 -> 1 -> `X0 +
                            1 -> 1 -> `X0 + 
                            2 -> 1 -> `X0)
    }

    // allWellformed returns false for this instance
    example notWellFormed is {not allWellformed} for {
        X = `X0
        O = `O0
        Player = `X0 + `O0
        Board = `Board0
        board = `Board0 -> (3 -> 3 -> `X0 +
                            1 -> 1 -> `X0 + 
                            1 -> 2 -> `X0)
    }
}

-- in any trace, allWellformed holds
assert allWellformed is necessary for traces
for exactly 10 Board, 3 Int
for {next is linear}