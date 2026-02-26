#lang forge 

sig Town { roads: set Town }
one sig Providence extends Town {}
run {} for exactly 5 Town
