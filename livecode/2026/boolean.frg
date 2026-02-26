#lang forge
// /froglet

option run_sterling "boolean.cnd"


/*
  
   Many of you pointed out that ChatGPT isn't great at writing Forge. 
   This is true in my experience. ClaudeCode w/ Opus is better but 
   still not great. (I've had some luck using it to debug, though I 
   needed my own expertise.) 
   
   HOWEVER, note how "prompts" and "specifications" 
   share some features...








   Some interesting responses:

   "The difference was in specificity. I think that all of the examples 
   are based off of projects that the LLM found on the Internet, but when 
   instructed for 1710, it looked for projects with that label as opposed 
   to general logic course projects. "

   "The results for the first were very broad for both of us. For the 
   second one, my results were very technical because ChatGPT went 
   off heuristics of what the course might cover based on its name, 
   but my partner's LLM did a web search of the course and turned up a 
   lot of actually interesting project ideas, though based on things that
   are on the course site, or other ideas that have previously been done."

*/



/*
  Let's model if-statement conditionals. We don't know what the specific 
  program is, exactly, so let's start by modeling booleans. E.g., 
 
  if(this.getLeftChild() != null &&
      this.getLeftChild().value < goal) { 
      ... 
  }

  In this model, we'd just call "this.getLeftChild() != null" a boolean
  variable name, something like "x_17".

*/

// Syntax
abstract sig Formula {
    satisfiedBy: set Valuation
}
sig Var extends Formula {}
sig Not extends Formula { child: one Formula }
sig And extends Formula { a_left, a_right: one Formula }
sig Or extends Formula { o_left, o_right: one Formula }

pred subformulaOf[sub: Formula, super: Formula] {
    reachable[sub, super, child,  
                          a_left, a_right, o_left, o_right]
}

pred wellformed_syntax {
    // Cycles? 
    all f: Formula | not subformulaOf[f, f]
}
pred wellformed {
    wellformed_syntax
    wellformed_semantics
}

// Note: moved run/assert to the end, to ensure Valuation is in scope.

// Feb 20th Content

// Then Feb 25 Content


// Semantics
// E.g., "Variables need to be true or false"

/*
   //if(myObject.foo() == 1 && myObject.bar() == 1) {
   if(A && B) {
   ...
   }
*/

/** Maps every boolean variable to either 
    true or false. Our "input" to a fmla */
sig Valuation {
    //truths:  pfunc Var -> True
    truths: set Var
}

/** Evaluates to true IFF fmla is true under val */
pred wellformed_semantics { //[f: Formula, val: Valuation] {
    // all f: Formula | {
    all f: univ | f in Formula => {
        (f in Var) => f.satisfiedBy = 
          {v: Valuation | f in v.truths}
        (f in And) => f.satisfiedBy = 
          {v: Valuation | 
            v in f.a_left.satisfiedBy and 
            v in f.a_right.satisfiedBy } 
        (f in Or) => f.satisfiedBy = 
          {v: Valuation | 
            v in f.a_left.satisfiedBy or  
            v in f.a_right.satisfiedBy } 
        (f in Not) => f.satisfiedBy = 
          Valuation - f.child.satisfiedBy
    }
    
    // (f in And) => ...
  /*
    
    (f instanceof And) => 
      (semantics[f.a_left, val] and 
       semantics[f.a_right, val])

  */
}

pred relational_things {
    all f: Formula | {
        // in relational forge, "f" is the set
        // of one column and one row
        f = Formula
    }

    Formula = Var + And + Or + Not
}


interestingExample: run {
    wellformed // remember to use _both_ the syntax and semantics wf predicates
    // give us a single formula, not a forest of them
    some top: Formula | {
        all other: Formula | top != other => {
            subformulaOf[other, top]
        }
    // Use a variety of operators
    //some And
    some Or
    some Not

    // Since this is a demo, avoid unnecessary duplication
    all a: And | some a.a_left => a.a_left != a.a_right
    all o: Or | some o.o_left => o.o_left != o.o_right
    all n: Not | (some n.child and some n.child.child) => n.child.child != n

    }
} for exactly 6 Formula, 2 Var, exactly 2 And // use at least 2 different variables

// TEXTBOOK: this chapter shows how we check DeMorgan's law, etc.


assert { some a: And | a.a_left = a} 
  is inconsistent with wellformed_syntax


fun subf: set Formula -> Formula {
    // We could do this; better to just move the definition into this helper to begin with.
    {f1, f2: Formula | subformulaOf[f1,f2] }
}

fun direct_subf: set Formula -> Formula {
    // No transitive closure, because we aren't trying to get _reachability_
    //{f1, f2: Formula | f2 = f1.(child + a_left + a_right + o_left + o_right) }
    // But we can do even better...
    (child + a_left + a_right + o_left + o_right)
}