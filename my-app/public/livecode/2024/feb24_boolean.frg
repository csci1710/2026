#lang forge "in_class" "tim_nelson@brown.edu"
/*
  Boolean Logic (Feb 22 -- 24)

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

abstract sig Formula {
    -- which valuations of Vars make this formula true?
    satisfiedBy: set Valuation
}
-- v0, v1, p, q, -- essential boolean inputs
--   if in Forge I write "f.satisfiedBy = Valuation  - f.child.satisfiedBy"
--    then the whole thing is one essential boolean input. 
-- We're modeling the boolean structure, not expressions yet.
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

// v0 && v1
inst oneAndWithVarChildren {
  And = `And0
  Var = `Var0 + `Var1
  Formula = And + Var
  a_left = `And0 -> `Var0
  a_right = `And0 -> `Var1
}

-- include And with 2 Var children
-- but BEWARE
// run {wellformed}
//   for exactly 3 Formula
//   for oneAndWithVarChildren

----------------------------

-- Which of the Var(iables) is true?
-- Truth value set, table, ...
sig Valuation {
    truths: set Var
}

// We'd like to model it like this... |=
/*pred semantics[f: Formula, v: Valuation] {
    // .. recursion ..
}*/

-- "Mock recursion". We can't actually recur in Forge, but we can
-- write constraints that enforce the structure we'd get with recursion.
--   (this trick wouldn't be safe if we had cycles in our syntax
--      more on that on Monday)
pred semantics {
/*   f instanceof Var => val set f to true
   f instance And => semantics[f.a_left, val] and semantics[f.a_right, val]
   */

  all f: Var | {
    -- set of valuations that set <f> to true
    f.satisfiedBy = {v: Valuation | f in v.truths}
  }

  all f: Not | {
    f.satisfiedBy = Valuation - f.child.satisfiedBy
  }

  all f: And | {
     -- set intersection!
    f.satisfiedBy = f.a_left.satisfiedBy & f.a_right.satisfiedBy
  }

  all f: Or | {
     -- set intersection!
    f.satisfiedBy = f.o_left.satisfiedBy + f.o_right.satisfiedBy
  }

}

-- Added after class
run {
    wellformed
    semantics
} for exactly 5 Formula
-- The default visualization isn't super great for this, because it
-- labels objects "FormulaX" rather than "AndX" or "NotY".