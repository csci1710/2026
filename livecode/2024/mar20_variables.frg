#lang forge
option verbose 5

abstract sig Person {
  followers: set Person
}
sig Alice, Bob, Charli extends Person {}
run {some followers} for exactly 3 Person 
