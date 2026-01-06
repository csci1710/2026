#lang forge 

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

sig Implies extends Formula {i_left, i_right: one Formula }

pred subFormulaOf[sub: Formula, f: Formula] {
    reachable[sub, f, child, a_left, a_right, o_left, o_right,
              i_left, i_right] }
pred wellformed {
    all f: Formula | not subFormulaOf[f, f] }

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
    // set comprehension
    all f: Var | f.trueIn = {v: Valuation | f in v.truths}
    all f: And | f.trueIn = f.a_left.trueIn & f.a_right.trueIn
      // {v: Valuations | v in f.a_left.trueIn and v in f.a_right.trueIn       
    all f: Or |  f.trueIn = f.o_left.trueIn + f.o_right.trueIn
    all f: Not | f.trueIn = Valuation - f.child.trueIn
    all f: Implies | f.trueIn = 
      {v: Valuation | v in f.i_left.trueIn implies v in f.i_right.trueIn }
    // .. more operators? add here! 
}

interesting5: run {
  wellformed
  semantics
  some a1: And | { a1.a_left != a1.a_right}
  some Not
  some o1: Or |  { o1.o_left != o1.o_right}
} for exactly 5 Formula

/*
  Hypothesis: we don't really need implication because
    the other operators can express implication on 
    their own. 

  Version 1: Find me an implication such that 
    NO OTHER POSSIBLE formula has the same meaning.
     [This is really hard to do.]
  Version 2: I believe that A => B is equivalent 
    to (!A or B). Find me a counterexample to that 
    conjecture. 
    [This is much easier to do! We just have to say there exists 
     such an Or formula and such an Implies formula.]

*/

pred counterexample { 
    // Don't forget these:
    semantics
    wellformed 

    // There exist these: A => B     
    //                   !A or B
    // (We don't care what A and B are.)
    some i: Implies, o: Or, n: Not | {
        i.i_left = n.child
        i.i_right = o.o_right
        o.o_left = n
        
        // And additionally, the two are _not_ equivalent.
        i.trueIn != o.trueIn
    }
}
implies_equiv_or_ce: assert {counterexample} is unsat for 7 Formula

// We could have written this more cleanly, but this works for our purposes.

