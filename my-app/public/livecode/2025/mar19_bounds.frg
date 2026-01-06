#lang forge 
// We'll start in Relational Forge...

// option sb 0

sig City { roads: set City }
// 0--4 City atoms
//one sig Providence extends City {}
// run {} for exactly 2 City
//run {all c1, c2: City | c1 in c2.roads} for exactly 2 City
//run {roads = City -> City} for exactly 2 City
//run {one roads} for exactly 2 City
run {some c: City | some c.roads} for exactly 4 City

/*
  Where do the secondary variables come from?

  SOLVERS REQUIRE THIS: (x0 or x1) and (x2 or x3)
  // Conjunctive Normal Form

  (x0 and x1) or (x2 and x3)
   -----> CNF?
*/