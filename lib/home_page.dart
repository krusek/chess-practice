import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/flutter_stateless_chessboard.dart';
import 'package:chess/chess.dart' as ch;
import 'package:flutter_stateless_chessboard/types.dart';

import 'utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.of(context).size;
    final size = min(viewport.height, viewport.width);
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Random Chess"),
      ),
      body: Center(
        child: Chessboard(
          fen: _fen,
          size: size,
          orientation: Color.WHITE,
          onMove: (move) {
            print(_fen);
            if (!validMoveFromFEN(_fen, move)) {
              return;
            }
            final nextFen = makeMove(_fen, {
              'from': move.from,
              'to': move.to,
              'promotion': 'q',
            });
            print(move.from);
            print(move.to);
            print(move.promotion);

            if (nextFen != null) {
              setState(() {
                _fen = nextFen;
              });

              Future.delayed(Duration(milliseconds: 300)).then((_) {
                final chess = ch.Chess.fromFEN(_fen);
                // final computerMove = getNextMove(_fen);

                final computerMove = getNextMove(_fen);
                final computerFen = makeMove(_fen, computerMove);

                if (computerMove != null && computerFen != null) {
                  setState(() {
                    _fen = computerFen;
                  });
                }
              });
            }
          },
        ),
      ),
    );
  }
}
