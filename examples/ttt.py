# A *PROGRAM* to play tic-tac-toe (TN Jan 29, 2023)
# Play alternates between an interactive keyboard player and a computer player.
# The computer player moves randomly. When someone has won or the board is full,
# play ceases and a winner (or tie) is declared.

import random

###############################################################
from typing import Union, Literal
# A board is a dictionary that maps pairs of integers to some player mark
# only X and O are valid player marks
PlayerType = Union[Literal['X'], Literal['O']]
BoardType = dict[tuple[int, int], PlayerType]
X: PlayerType = 'X'
O: PlayerType = 'O'
###############################################################

def print_board(board: BoardType): 
    """Prints the tic-tac-toe board"""  
    print('------------------------------')  
    for row in range(3):
        columns = [board[(row,col)] if (row,col) in board else " " for col in range(3)]
        if row > 0: 
            print('-----')        
        print('|'.join(columns))
            
def game_over(board: BoardType) -> str:
    """Is this game over?
       If X has won, return 'X' 
       If O has won, return 'O'
       If the board is full, with no winner, retunr 'T'
       Otherwise, the game continues: return ' '."""
        
    diagonals = [[(0,0), (1,1), (2,2)], [(0,2), (1,1), (2,0)]]

    for player in [X, O]:
        # 3 in a row
        if any([all([(row,col) in board and board[(row,col)] == player for col in range(3)]) for row in range(3)]):
            return player
        # 3 in a column
        if any([all([(row,col) in board and board[(row,col)] == player for row in range(3)]) for col in range(3)]):
            return player
        # 3 diagonally
        if any([all([(row,col) in board and board[(row,col)] == player for (row,col) in diagonal]) for diagonal in diagonals]): 
            return player
    
    # Without a winner, the game is over if the board is full
    if len(board) >= 9: return "T"
    else: return " "

def get_random_move(board: BoardType) -> tuple[int,int]:
    """Select a random unoccupied square on the board."""
    choices = [(row,col) for row in range(3) for col in range(3) if (row,col) not in board]
    return random.choice(choices)

def do_computer_turn(board: BoardType) -> BoardType:
    """Executes a turn of tic-tac-toe, starting from `board`, for the computer player.
        Returns the final board reached."""
    choice = get_random_move(board)
    board.update({choice: O})
    if game_over(board) != " ":
        return board
    return do_player_turn(board)

def do_player_turn (board: BoardType) -> BoardType:
    """Executes a turn of tic-tac-toe, starting from `board`, for the interactive player.
       Returns a final board reached."""
    print_board(board)
    row = input("Enter a row to move at (between 0 and 2): ")
    col = input("Enter a column to move at (between 0 and 2): ")
    row = int(row)
    col = int(col)
    if row not in range(3):
        print("Error: row given needs to be between 0 and 2 inclusive.")
        return do_player_turn(board)
    if col not in range(3):
        print("Error: column given needs to be between 0 and 2 inclusive.")
        return do_player_turn(board)
    if (row,col) in board:
        print("Error: There was already a move at that location. Try another.")
        return do_player_turn(board)
        
    board.update({(row,col): X})
    if game_over(board) != " ":
        return board
    return do_computer_turn(board)


# Start here!
if __name__ == '__main__':
    print("Let's play tic-tac-toe! You'll be X, and I'll be O. You go first.")
    starting_board: BoardType = {}
    end_board = do_player_turn(starting_board)
    print_board(end_board)
    print(f'Game over! Winner (X, O, or Tie): {game_over(end_board)}')


