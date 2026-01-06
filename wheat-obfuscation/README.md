
# Encryption Tool

This is a command-line tool for encrypting files for use by Toadus Ponens.

## Prerequisites

Before running the tool, make sure you have the following installed:

- Node.js
- npm (Node Package Manager)
- TypeScript Node: You can install this by running `npm install -g ts-node`

# Encrypting Files for Toadus Ponens


## Ensure you have a Wheat, a grader, and hints
Toadus Ponens requires 3 files to be enabled for an assignment:

- A correct implementation of the assignment (a wheat). This should be named `assignmentname.wheat`. Crucially, this wheat should have Sterling turned off.

An example wheat for directed tree:
```
#lang forge

option run_sterling off

sig Node {edges: set Node}

pred isDirectedTree {
	edges.~edges in iden -- Injective, each child has at most one parent
	lone edges.Node - Node.edges -- At most one element that does not have a parent
	no (^edges & iden) -- No loops
	lone Node or Node in edges.Node + Node.edges -- Either one node or every node has either a child or a parent.
}
```


- A Forge test suite used to evaluate the quality of an immplementation. All tests in this suite suite *must* have unique names. This file should be named `assignmentname.grader`
An example grader
```
test expect {
  injective : {isDirectedTree implies (edges.~edges in iden)} is theorem
  injective_insufficient : {(edges.~edges in iden) and !isDirectedTree} is sat

  root : {isDirectedTree implies (lone edges.Node - Node.edges) } is theorem
  loopless : {isDirectedTree implies (no (^edges & iden))} is theorem
  connected : {isDirectedTree implies (lone Node or Node in edges.Node + Node.edges) } is theorem
}


example twoNodeTree is isDirectedTree for {
  Node = `Node1 + `Node2
  edges = `Node1->`Node2
}

example notJustInjective is {not isDirectedTree} for {

	Node =`Node1 + `Node2 + `Node3
    edges = `Node1->`Node3 + `Node2->`Node2 + `Node3->`Node1
}
```

- A hints file, containing hints to be given to students. This hints file shouold be named `assignmentname.grader.json`. 
Each test in the grader should have a corresponding hint, to be provided if that test fails. An example grader should look something like:
```
{
    "injective" : "A directed tree should be injective... or some such hint.",
	"root" : "A directed tree should have a root... or some such hint.",
	"loopless" : "A directed tree should be loopless... or some such hint.",
	"connected" : "A directed tree should be connected... or some such hint.",
    "twoNodeTree" : "A directed tree can have two nodes, one edge ... or some such hint.",
	"injective_insufficient" : "All injective graphs are not directed trees ... or some such hint."
}
```

## Encrypting these files

Once you have these files, in a directory `<src-directory>`, you can encrypt files as follows:
`ts-node encryption-tool.ts <src-directory> <target directory>`

This will encrypt and copy over files to the target directory. If the target directory is in this repository, you will have to add and push these files to the repository. Typically, the `<target directory>` should be `my-app/public/toadusponensfiles`.