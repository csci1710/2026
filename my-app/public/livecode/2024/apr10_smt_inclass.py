from z3 import *

def demoBool():
        # Create a new solver
        s = Solver()

        # declare some boolean *solver* variables
        p, q = Bools('p q')         
        
        s.add(Or(p, q))
        if s.check() == sat:        
            print(s.model()) # "model" ~= "instance" here :/
        
        # (Think: how would we get a different instance?)

        # getting at pieces of a model for programmatic use
        print(s.model().evaluate(p)) # can pass a formula              

# demoBool()

def demoUninterpreted():
    s = Solver()
    # ; Ints, UNINTERPRETED Functions (think of as like relations in Alloy)        
    a, b = Ints('a b')  
    f = Function('f', IntSort(), IntSort())
    s.add(And(b > a, f(b) < f(a)))        
    if s.check() == sat:        
        print(s.model()) 
    print(s.model().evaluate(f(a)))
    print(s.model().evaluate(f(b)))
    print(s.model().evaluate(f(1000000)))

#demoUninterpreted()

def demoReals():
    s = Solver()
    x = Real('x') 
    s.add(x*x > 4) 
    s.add(x*x < 9) 
    result = s.check()
    if result == sat:
        print(s.model())    
    else: 
        print(result)

# demoReals()


def demoFactoringInt():
    s = Solver()
    
    # (x - 2)(x + 2) = x^2 - 4
    # Suppose we know the RHS and want to find an *equivalent formula* LHS. 
    # We will solve for the roots:
    # (x - ROOT1)(x + ROOT2) = x^2 - 4
    
    xi, r1i, r2i = Ints('x root1 root2') # int vars

    # Note: don't use xi ** 2 -- gives unsat?
    s.add(ForAll(xi, (xi + r1i) * (xi + r2i) == (xi * xi) - 4  )) # type: ignore
    result = s.check()
    if result == sat:
        print(s.model())    
    else: 
        print(result)

    s.reset()   
    
    # Try another one: 
    # (x + 123)(x - 321) = x^2 - 198x - 39483
    s.add(ForAll(xi, (xi + r1i) * (xi + r2i) 
                        == (xi * xi) + (198 * xi) - 39483))
    result = s.check()
    if result == sat:
        print(s.model())    
    else: 
        print(result)
    # Note how fast, even with numbers up to almost 40k. Power of theory solver.

#demoFactoringInt()

def demoFactoringReals():
    s = Solver()
    x, r1, r2 = Reals('x root1 root2') # real number vars
    # ^ As before, solve for r1, r2 because they are unbound in outer constraints
    #   x is quantified over and therefore not a var to "solve" for

    # (x + ???)(x + ???) = x^2 - 198x - 39484         
    # s.add(ForAll(x, (x + r1) * (x + r2) 
    #                     == (x * x) + (198 * x) - 39484)) # type: ignore

    # Note e.g., x^2 - 2x + 5 has no real roots (b^2 - 4ac negative)
    s.add(ForAll(x, (x + r1) * (x + r2) 
                        == (x * x) - (2 * x) + 5))

    result = s.check()
    if result == sat:
        print(s.model())    
    else: 
        print(result)

#demoFactoringReals()

def coefficients():
    s = Solver()
    x, r1, r2, c1, c2 = Reals('x root1 root2 c1 c2') # real number vars        
    s.add(ForAll(x, ((c1*x) + r1) * ((c2*x) + r2) == (2 * x * x)))
    result = s.check()
    if result == sat:
        print(s.model())    
    else: 
        print(result)  

coefficients()