#lang forge     ////////froglet 

/*
  if(this.getLeftChild() != null && 
     this.getRightChild() != null) { ... }
 

  and && conjunction 
  implication 
  or || disjunction
  iff biconditional <=> 
  true false booleans 
  negation not ! 
  exclusive-or XOR

  evaluation order in "if", eager vs. lazy (PL)
  order of operations, precedence 
  

*/

abstract sig Formula {
    trueIn: set Valuation
} 
sig Var extends Formula {}
sig Not extends Formula { child: one Formula }
sig And extends Formula { a_left, a_right: one Formula }
sig Or extends Formula { o_left, o_right: one Formula }
// we could add "Implies", "Xor", etc. and perhaps we will. 

pred subFormulaOf[sub: Formula, f: Formula] {
    reachable[sub, f, child, a_left, a_right, o_left, o_right] }
pred wellformed {
    all f: Formula | not subFormulaOf[f, f] }

justWellformed5: run {
  wellformed
} for exactly 5 Formula

// A boolean instance, mapping variables to booleans
sig Valuation {
  // We could do this:
  // v: func Var -> Boolean // ...  
  truths: set Var
}

// Does this formula evaluate to true, given this valuation?
//pred semantics[f: Formula, val: Valuation] {
  // pseudocode
  //f in Var => val.v[f] = True
  //f in And => semantics[f.left, val] and semantics[f.right, val]
//}

pred semantics {
    all f: Var | f.trueIn = {v: Valuation | f in v.truths}
}

