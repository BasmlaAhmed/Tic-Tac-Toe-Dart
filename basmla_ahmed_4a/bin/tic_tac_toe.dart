// Basmla Ahmed 4A
import 'dart:io';
import 'dart:math';

void main() {
  print("Welcome to the game! Choose Game Mode: ");
  print("1: You VS Human");
  print("2: You VS Computer (Easy Mode)");
  print("3: You VS Computer (Hard Mode)");

  String choice = stdin.readLineSync()!;
  TicTacToe game = TicTacToe();

  switch (choice) {
    case '1':
      game.playGame(false, false); // Player VS Player
      break;
    case '2':
      game.playGame(true, false); // Computer (Easy Mode)
      break;
    case '3':
      game.playGame(true, true); // Computer (Hard Mode)
      break;
    default:
      print("Invalid input");
      return;
  }
}

class TicTacToe {
  // Values for each spot in the board
  List<String> Values = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
  bool winner = false; // See if there's a winner
  bool isXturn = true; // If true it's X's turn otherwise it's O's turn
  int moveCount = 0; // Keep track of the number of moves taken

  void playGame(bool isVsComputer, bool isHardMode) {
    bool playAgain = true;
    while (playAgain) {
      // Reset game for a new round
      resetGame();
      // The Game will continue until there's a winner or it's a tie
      while (!winner && moveCount < 9) {
        // This display the current state of the board
        boardGame();
        if (isXturn || !isVsComputer) {
          getCharacter();
        } else if (isHardMode) {
          getMinimaxMode();
        } else {
          getComputerMove();
        }
        // Check if the current move has created a winning combination
        checkWinner();

        // if a winner is found tis msg will be displayed and the loop will break
        if (winner) {
          print("Player ${isXturn ? 'X' : 'O'} is the Winner!");
          break;
        }
        // This used to switch turns (If it was X's turn, now its O's turn and vice versa)
        isXturn = !isXturn;
        // Increment the move count after each turn
        moveCount++;
      }

      // If no winner came up and all the spots have been taken then it's a Tie
      if (!winner && moveCount == 9) {
        print("It's a tie. There's No Winner");
      }
      // Displaying the final state of the Game Board
      boardGame();

      playAgain = askToPlayAgain();
    }
    // Displaying thanks msg at the end of the game
    print("Thanks for playing!");
  }


  // This function takes input from the user validates this input and updates the board for the next play
// Person Vs Person
  void getCharacter() {
    bool validMove = false; // no valid moves is been made initially.
    // Keep asking until a valid move happen
    while (!validMove) {
      // this will print X or O for the user if the isXturn true it will be X otherwise it will be O
      print("Choose a number for ${isXturn ? 'X' : 'O'}");
      // Handling Error
      try {
        // taking input from the user and parsing it to integer
        int number = int.parse(stdin.readLineSync()!);
        // handling the taken no. to be between 1 and 9 and if the spot is not already taken
        if (number < 1 ||
            number > 9 ||
            Values[number - 1] == 'X' ||
            Values[number - 1] == 'O') {
          // if the chosen no. not between 1 and 9 and if the spot is taken this msg will be displayed
          print("This Number is Already Taken or Invalid. Choose Another One!");
        } else {
          // if the input is valid the game will continue
          // we make no.-1 as index start with 0 so if the user choose place 9 it will be index 8
          Values[number - 1] = isXturn ? 'X' : 'O';
          // a valid move happen so the loop will stop
          validMove = true;
        }
        // if there is any error like input non-numeric value, this msg will be displayed
      } catch (e) {
        print("Invalid Input. Please Enter a number between 1 and 9");
      }
    }
  }


// this function handles the movement of the computer
// Person Vs Computer (Easy Mode)
  void getComputerMove() {
    Random random = Random(); // Generate random numbers
    bool validMove = false;
    int number = 0; // The randomly selected number will be stored here

    // the loop will continue until t find a valid move
    while (!validMove) {
      // generate a random number between 1 and 9
      number = random.nextInt(9) +
          1; // (+1 is added as nextInt(9) will generate from 0 to 8)
      // we check if the selected spot is available
      if (Values[number - 1] != 'X' && Values[number - 1] != 'O') {
        // if the spot is free computer will play with X or O
        Values[number - 1] = isXturn ? 'X' : 'O';
        // the loop will end as there is a valid move happened
        validMove = true;
      }
    }
    // After the computer make a move it will print which symbol it used and in what position
    print("Computer Choose ${isXturn ? 'X' : 'O'} for position $number");
  }



  // this function handles the movement of the computer minimax
// Person Vs Computer (Hard Mode)
  void getMinimaxMode() {
    int bestScore = -1000;
    int bestMove = -1;

    for (int i = 0; i < Values.length; i++) {
      if (Values[i] != 'X' && Values[i] != 'O') {
        Values[i] = isXturn ? 'X' : 'O';
        int score = minimax(0, false);
        Values[i] = (i + 1).toString();

        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }
     Values[bestMove] = isXturn ? 'X' : 'O';
     print("Computer chose ${isXturn ? 'X' : 'O'} for position ${bestMove + 1}");
  }

  int minimax(int depth, bool isMaximizing) {
    String? winner = checkWinner();
    if (winner == 'X') return 10 - depth; // maximizer win
    if (winner == 'O') return depth - 10; // minimizer win
    if (isTie()) return 0; // tie

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < Values.length; i++) {
        if (Values[i] != 'X' && Values[i] != 'O') {
          Values[i] = 'X';
          int score = minimax(depth + 1, false);
          Values[i] = (i + 1).toString();
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < Values.length; i++) {
        if (Values[i] != 'X' && Values[i] != 'O') {
          Values[i] = 'O';
          int score = minimax(depth + 1, true);
          Values[i] = (i + 1).toString();
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }

  bool isTie() {
    for (var value in Values) {
      if (value != 'X' && value != 'O') return false;
    }
    return true;
  }


  bool askToPlayAgain() {
    // asking the Player if he wants to play again
    print("Do you want to play again? yes/no");
    // take input from user and turn it to lowercase if it's not lower
    String response = stdin.readLineSync()!.toLowerCase();

    if (response == 'yes') {
      // this indicates that the user wants to play again
      return true;
    } else if (response == 'no') {
      // end the game
      return false;
    } else {
      // if the user enters anything rather than yes or no the game will end too
      print("Invalid input, Exiting the game");
      return false;
    }
  }

  void resetGame() {
    // Reset game variables for a new round
    Values = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
    isXturn = true;
    winner = false;
    moveCount = 0;
  }

// This function display the Tic-Tac-Toe Game Board with a 3x3 grid
  void boardGame() {
    print("  ــ    ــ   ــ");
    print(
        "| ${Values[0]}  |  ${Values[1]}  |  ${Values[2]} |"); // 1st row with Values
    print("  ــ    ــ   ــ");
    print(
        "| ${Values[3]}  |  ${Values[4]}  |  ${Values[5]} |"); // 2st row with Values
    print("  ــ    ــ   ــ");
    print(
        "| ${Values[6]}  |  ${Values[7]}  |  ${Values[8]} |"); // 3st row with Values
    print("  ــ    ــ   ــ");
  }

// This function check if there's a winner and defines all possible winning combinations
  String? checkWinner() {
    // Define all possible winning combinations Rows-Columns-Diagonals
    List<List<int>> winnerCombination = [
      [0, 1, 2], // top row
      [3, 4, 5], // middle row
      [6, 7, 8], // bottom row
      [0, 3, 6], // left column
      [1, 4, 7], // middle column
      [2, 5, 8], // right column
      [0, 4, 8], // top left to bottom right diagonal
      [2, 4, 6] // top right to bottom left diagonal
    ];
// The foreach loops through the winnerCombination (values stored in combo ) and checks if there is a matching set
    for (var combo in winnerCombination) {
      // first we check if the index 0 equal to index 1
      // if the first comparison true we will check for the next if index 1 equal to index 2 and this will mean that all these are equal (either X or O )
      if (Values[combo[0]] == Values[combo[1]] &&
          Values[combo[1]] == Values[combo[2]]) {
        //if both comparisons are true then we have a winner
        winner = true;
        // after indicating a winner we will break the loop to stop checking for a winner again
        break;
      }
    }
    return null;
  }
}
