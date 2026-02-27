#lang forge 

/*
  FORGE UPDATE! Version 5.1

  

  while(true) {
      // [state: uninterested]

      this.flag = true;  // raise transition
      // [state: waiting]

      while(other.flag == true); // enter transition
      // [state: in-cs]

      DO_SOMETHING();
      this.flag = false;  // leave transition
      // loop back, return to uninterested state
  }
*/














/** Initial state of the system */
pred init[s: State] {
}

/** raise flag (first line) */
pred raise[pre: State, p: Process, post: State] {
}
/** finish waiting (second line) */
pred enter[pre: State, p: Process, post: State] {
}
/** leave critical section (third/fourth line) */
pred leave[pre: State, p: Process, post: State] {
}

/** combined transition predicate */
pred delta[pre: State, post: State] {
}


/* How should we test this transition system?
       (1) IS THE MODEL ITSELF "GOOD" 
         (i.e., are we modeling correctly)?
       (2) IS THE SYSTEM "GOOD"?
         (i.e., trusting the model, what did we learn about the system?)
*/



