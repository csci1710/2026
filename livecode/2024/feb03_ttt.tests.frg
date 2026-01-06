#lang forge/bsl 
open "feb03_ttt.frg"

pred allWellformed {
    all b: Board | wellformed[b]
}

example middleRowWellFormed is {allWellformed} for {
    X = `X0
    O = `O0
    Player = `X0 + `O0
    Board = `Board0
    board = `Board0 -> (3 -> 0 -> `X0 +
                        1 -> 1 -> `X0 + 
                        1 -> 2 -> `X0)
}