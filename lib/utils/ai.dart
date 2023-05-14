import 'dart:math';

enum AIStrategy { random, smart }

class AI {
  final AIStrategy strategy;

  AI({this.strategy = AIStrategy.smart});

  List<int>? nextMove(List<List<String>> board) {
    switch (strategy) {
      case AIStrategy.random:
        return _randomMove(board);
      case AIStrategy.smart:
        // 続きを表示
        return _smartMove(board);
      default:
        throw Exception('Unknown AI strategy');
    }
  }

  List<int>? _randomMove(List<List<String>> board) {
    final emptyCells = <List<int>>[];
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (board[row][col] == '') {
          emptyCells.add([row, col]);
        }
      }
    }

    if (emptyCells.isEmpty) {
      return null;
    }

    return emptyCells[Random().nextInt(emptyCells.length)];
  }

  List<int> _smartMove(List<List<String>> board) {
    int bestScore = -1;
    List<int> bestMove = [];

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (board[row][col] == '') {
          board[row][col] = 'O';
          int score = _minimax(board, 0, false);
          board[row][col] = '';
          if (score > bestScore) {
            bestScore = score;
            bestMove = [row, col];
          }
        }
      }
    }

    return bestMove;
  }

  int _minimax(List<List<String>> board, int depth, bool isMaximizing) {
    String? winner = _checkWinner(board);
    if (winner != null) {
      return winner == 'X' ? -1 : 1;
    }

    if (_checkDraw(board)) {
      return 0;
    }

    if (isMaximizing) {
      int bestScore = -1;
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          if (board[row][col] == '') {
            board[row][col] = 'O';
            int score = _minimax(board, depth + 1, false);
            board[row][col] = '';
            bestScore = max(bestScore, score);
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 1;
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          if (board[row][col] == '') {
            board[row][col] = 'X';
            int score = _minimax(board, depth + 1, true);
            board[row][col] = '';
            bestScore = min(bestScore, score);
          }
        }
      }
      return bestScore;
    }
  }

  String? _checkWinner(List<List<String>> board) {
    // Check rows and columns
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != '' &&
          board[i][0] == board[i][1] &&
          board[i][0] == board[i][2]) {
        return board[i][0];
      }

      if (board[0][i] != '' &&
          board[0][i] == board[1][i] &&
          board[0][i] == board[2][i]) {
        return board[0][i];
      }
    }

    // Check diagonals
    if (board[0][0] != '' &&
        board[0][0] == board[1][1] &&
        board[0][0] == board[2][2]) {
      return board[0][0];
    }

    if (board[0][2] != '' &&
        board[0][2] == board[1][1] &&
        board[0][2] == board[2][0]) {
      return board[0][2];
    }

    return null;
  }

  bool _checkDraw(List<List<String>> board) {
    return board.every((row) => row.every((cell) => cell != ''));
  }
}
