#lang forge/bsl "in_class" "tim_nelson@brown.edu"
/*
  Boolean Logic (Feb 22)

  Note: when you see Tim running Forge in class and it looks like an old 
  version, that's just because Tim is running a development branch which 
  isn't always synched on version numbers.
*/ 


/*

   if(this.getLeftChild() != null && 
      this.getLeftChild().value < goal) { ... }

*/

---------------------
-- Syntax of Formulas
---------------------

abstract sig Formula {}
sig Var extends Formula {}
sig And extends Formula {a_left, a_right: one Formula}
sig Or extends Formula {o_left, o_right: one Formula}
sig Not extends Formula {child: one Formula}

pred subFormulaOf[sub: Formula, f: Formula] {
    reachable[sub, f, child, a_left, a_right, o_left, o_right]
}

pred wellformed {
    all f: Formula | not subFormulaOf[f, f]
}

example leftBranchFormula is {wellformed} for {
  And = `And0
  a_left = `And0 -> `VarNeqNull
  a_right = `And0 -> `VarLTLeft
  Var = `VarNeqNull + `VarLTLeft -- refer to bottom-level true/false values
  Formula = And + Var -- you can do this! but order matters
}

example noCyclesAllowed is {not wellformed} for {
    And = `And0
    a_left = `And0 -> `And0
    a_right = `And0 -> `And0
    Formula = And
}

inst oneAndWithVarChildren {
  And = `And0
  Var = `Var0 + `Var1
  Formula = And + Var
  a_left = `And0 -> `Var0
  a_right = `And0 -> `Var1
}

-- include And with 2 Var children
run {wellformed}
  for exactly 5 Formula
  for oneAndWithVarChildren
