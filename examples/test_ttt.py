# Tests for tic-tac-toe (TN Jan 29, 2023)
# (This is a bit complicated by the interactive nature of the keyboard player...)
import ttt

#####################################################
# We can write tests of the helper functions:
def test_game_over():
    assert ttt.game_over({}) == ' '
    assert ttt.game_over({(0,0): 'X', (1,1):'X', (2,2): 'X'}) == 'X'
    # ... Exercise: what's missing?

#####################################################
# We can even "mock" keyboard input to test the game itself (outside the scope of this example).

#####################################################
# We can write property-based tests, too! 
from hypothesis import given, settings, assume
from hypothesis.strategies import dictionaries, tuples, one_of, integers, just
@given(dictionaries(tuples(integers(), integers()), one_of(just('X'), just('O'))))
@settings(max_examples=500)
def test_pbt_game_over_small(board: ttt.BoardType):
    # only run on small random boards (not always efficient to do this; worst case it will just act as a filter)
    assume(len(board) < 3)
    assert ttt.game_over(board) == ' '



    

