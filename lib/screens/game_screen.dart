import 'package:flutter/material.dart';

import '/utils/ai.dart';

class GameScreen extends StatefulWidget {
  static const routeName = '/game';
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  List<List<String>> _board = List.generate(3, (_) => List.filled(3, ''));
  bool _isPlayerTurn = true;
  final bool _isPlayerFirst = true;
  int _playerScore = 0;
  int _aiScore = 0;
  int _drawCount = 0;
  late AI _ai;

  @override
  void initState() {
    super.initState();
    _ai = AI(strategy: AIStrategy.smart);
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _board = List.generate(3, (_) => List.filled(3, ''));
      _isPlayerTurn = _isPlayerFirst;
    });

    if (!_isPlayerFirst) {
      _aiMove();
    }
  }

  void _aiMove() {
    final move = _ai.nextMove(_board);
    _makeMove(move![0], move[1]);
  }

  void _makeMove(int row, int col) {
    setState(() {
      _board[row][col] = _isPlayerTurn ? 'X' : 'O';
      _isPlayerTurn = !_isPlayerTurn;
    });

    final winner = _checkWinner();
    if (winner != null) {
      _handleEndGame(winner);
    } else if (_checkDraw()) {
      _handleEndGame(null);
    } else if (!_isPlayerTurn) {
      _aiMove();
    }
  }

  String? _checkWinner() {
    // Check rows and columns
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] != '' &&
          _board[i][0] == _board[i][1] &&
          _board[i][0] == _board[i][2]) {
        return _board[i][0];
      }

      if (_board[0][i] != '' &&
          _board[0][i] == _board[1][i] &&
          _board[0][i] == _board[2][i]) {
        return _board[0][i];
      }
    }

    // Check diagonals
    if (_board[0][0] != '' &&
        _board[0][0] == _board[1][1] &&
        _board[0][0] == _board[2][2]) {
      return _board[0][0];
    }

    if (_board[0][2] != '' &&
        _board[0][2] == _board[1][1] &&
        _board[0][2] == _board[2][0]) {
      return _board[0][2];
    }

    return null;
  }

  bool _checkDraw() {
    return _board.every((row) => row.every((cell) => cell != ''));
  }

  void _handleEndGame(String? winner) {
    if (winner == 'X') {
      _playerScore++;
    } else if (winner == 'O') {
      _aiScore++;
    } else {
      _drawCount++;
    }

    String message = winner == null
        ? 'Draw!'
        : winner == 'X'
            ? 'あなたの勝ち!'
            : 'ＡＩの勝ち!';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.0),
          actions: <Widget>[
            Center(
                child: ElevatedButton(
              child: Text(message),
              onPressed: () {
                Navigator.of(context).pop();
                _startNewGame();
              },
            )),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('あなた: $_playerScore'),
        Text('　ＡＩ: $_aiScore'),
        Text('引分け: $_drawCount'),
        const SizedBox(height: 10),
        for (int row = 0; row < 3; row++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int col = 0; col < 3; col++)
                GestureDetector(
                  onTap: _board[row][col] == '' && _isPlayerTurn
                      ? () => _makeMove(row, col)
                      : null,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: _board[row][col] == 'X'
                          ? Colors.blue
                          : _board[row][col] == 'O'
                              ? Colors.red
                              : null,
                    ),
                    child: Center(
                      child: Text(
                        _board[row][col],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _startNewGame,
          child: const Text('リセット'),
        ),
      ],
    );
  }
}
