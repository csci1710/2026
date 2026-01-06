from z3 import *

def nQueens(numQ):
        s = Solver()
        # Model board as 2d list of booleans. Note the list is *Python*, booleans are *Solver*
        cells = [ [ z3.Bool("cell_{i}{j}".format(i=i,j=j)) 
                    for j in range(0, numQ)] 
                    for i in range(0, numQ) ]
        #print(cells)
        
        # a queen on every row
        queenEveryRow = And([Or([cells[i][j] for j in range(0, numQ)]) for i in range(0, numQ)])
        #print(queenEveryRow) # for demo only
        s.add(queenEveryRow)

        # for every i,j, if queen present there, implies no queen at various other places
        # Recall: queens can move vertically, horizontally, and diagonally.
        # "Threaten" means that a queen could capture another in 1 move. 
        queenThreats = And([Implies(cells[i][j], # Prefix notaton: (And x y) means "x and y".
                                    And([Not(cells[i][k]) for k in range(0, numQ) if k != j] +
                                        [Not(cells[k][j]) for k in range(0, numQ) if k != i] +
                                        # Break up diagonals and don't try to be too smart about iteration
                                        [Not(cells[i+o][j+o]) for o in range(1, numQ) if (i+o < numQ and j+o < numQ) ] +
                                        [Not(cells[i-o][j-o]) for o in range(1, numQ) if (i-o >= 0 and j-o >= 0) ] +
                                        # flipped diagonals
                                        [Not(cells[i-o][j+o]) for o in range(1, numQ) if (i-o >= 0 and j+o < numQ) ] +
                                        [Not(cells[i+o][j-o]) for o in range(1, numQ) if (i+o < numQ and j-o >= 0) ]
                                        ))
                           for j in range(0, numQ)
                           for i in range(0, numQ)])
        #print(queenThreats) # for demo only
        s.add(queenThreats)

        if s.check() == sat:
            for i in range(0, numQ):
                print(' '.join(["Q" if s.model().evaluate(cells[i][j]) else "_" for j in range(0, numQ) ]))
        else: 
            print("unsat")

if __name__ == "__main__":
    nQueens(40)