#lang forge
// /froglet


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

run {
    wellformed_syntax
    some top: Formula | {
        all other: Formula | top != other => {
            subformulaOf[other, top]
        }
    }
} for exactly 8 Formula 

assert { some a: And | a.a_left = a} 
  is inconsistent with wellformed_syntax

// Feb 20th Content

/*

// Any worries about the wellformed predicate from our stencil? E.g., 
pred wellformed {
    -- No tumblers at negative indices
    -- No breaks at a negative lengths
    all l: Lock, t, h: Int |
        (l.breaks[t][h] = True) implies 
          (t >= 0 and h >= 0) 
}
*/

// Semantics
// E.g., "Variables need to be true or false"

/*
   //if(myObject.foo() == 1 && myObject.bar() == 1) {
   if(A && B) {
   ...
   }
*/

one sig True {}

/** Maps every boolean variable to either 
    true or false. Our "input" to a fmla */
sig Valuation {
    //truths: pfunc Var -> True
    truths: set Var
}

/** Evaluates to true IFF fmla is true under val */
pred wellformed_semantics { //[f: Formula, val: Valuation] {
    all f: Formula | {
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
}