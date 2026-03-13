# This file implements the naive solver we discussed in class: it only does 
# a backtracking search, with no real constraint-propagation. That is, it 
# can't _propagate_ "a must be true" into "a implies b" to yield "b must be true".

# DPLL adds that inference to this backtracking framework.

from dataclasses import dataclass

@dataclass(frozen=True)
class BooleanFormula():
    pass
@dataclass(frozen=True)
class And(BooleanFormula):     
    left: BooleanFormula
    right: BooleanFormula
@dataclass(frozen=True)
class Or(BooleanFormula):     
    left: BooleanFormula
    right: BooleanFormula
@dataclass(frozen=True)
class Not(BooleanFormula):     
    child: BooleanFormula
@dataclass(frozen=True)
class Var(BooleanFormula):     
    name: str
@dataclass(frozen=True)
class Const(BooleanFormula):
    sign: bool

def simplify(f: BooleanFormula) -> bool:
    match f:
        case And(left = l, right = r): 
            return simplify(l) and simplify(r)
        case Or(left = l, right = r): 
            return simplify(l) or simplify(r)
        case Not(child = c):
            return not simplify(c)
        case Var(name = n):
            raise ValueError(f'simplify called on formula with variable remaining: {n}')
        case Const(sign = s):
            return s
        case _: 
            raise ValueError(f'simplify called with unexpected type: {f}')

def variables_in(f: BooleanFormula) -> list[Var]:
    match f:
        case And(left = l, right = r): 
            return list(set(variables_in(l) + variables_in(r)))
        case Or(left = l, right = r): 
            return list(set(variables_in(l) + variables_in(r)))
        case Not(child = c):
            return variables_in(c)
        case Var(name = n):
            return [f]
        case Const(sign = s):
            return []
        case _: 
            raise ValueError(f'variables_in called with unexpected type: {f}')

def substitute(f: BooleanFormula, v: str, sign: bool) -> BooleanFormula:
    match f:
        case And(left = l, right = r): 
            return And(substitute(l, v, sign), substitute(r, v, sign))
        case Or(left = l, right = r): 
            return Or(substitute(l, v, sign), substitute(r, v, sign))
        case Not(child = c):
            return Not(substitute(c, v, sign))
        case Var(name = n):
            if n == v: return Const(sign)
            else: return f
        case Const(sign = s):
            return f
        case _: 
            raise ValueError(f'substitute called with unexpected type: {f}')


def solve(formula: BooleanFormula) -> bool:
    '''Naive SAT-solver that uses only a backtracking search'''
    remaining = variables_in(formula) # note: no inference 
    if len(remaining) == 0: 
        return simplify(formula)
    else:
        branch = remaining[0] # note: *MANY* heuristics possible
        true_result = solve(substitute(formula, branch.name, True))
        if true_result:    # same as last version
            return True    # but allow early termination
        else: 
            false_result = solve(substitute(formula, branch.name, False))
            return false_result 

def examples():        
    a = Var('a')
    b = Var('b')
    na = Not(a)
    nb = Not(b)

    ex1 = And(a, Or(a, b))
    print(solve(ex1))
    ex2 = And(And(Or(na, nb), 
                  Or(a, b)),
              And(Or(na, b),
                  Or(a, nb)))
    print(solve(ex2))

if __name__ == '__main__':
    examples()