import 'package:chess/chess.dart';
import 'package:flutter_stateless_chessboard/flutter_stateless_chessboard.dart';

String moveString = 'e4 e5 Nf3 Nc6 Bb5 : Nf6 O-O Nxe4 Re1 : Nd6 Nxe5 : Nxe5 Nc3 Nxb5 Rxe5 Be7 Nd5';

List<String> makeMoveList(String moveString) {
  return moveString.split(' ').where((element) => element != ':').toList();
}

final moveList = makeMoveList(moveString);
int moveIndex = 0;

String? expectedMove() {
  if (moveIndex == moveList.length) return null;
  return moveList[moveIndex];
}

bool moveEqualsSan(Chess chess, dynamic move, String san) {
  final expected = moveFromSan(chess, san);
  if (expected != null && move is Map) {
    print("$move, $expected");
    return expected.fromAlgebraic == move['from'] && expected.toAlgebraic == move['to'];
  }
  if (move is String) return move == san;
  if (move is ShortMove && expected != null) {
    return expected.fromAlgebraic == move.from && expected.toAlgebraic == move.to;
  }
  if (expected != null && move is Move) {
    print("$move, $expected");
    return expected.fromAlgebraic == move.fromAlgebraic && expected.toAlgebraic == move.toAlgebraic;
  }
  return false;
}

void printMove(dynamic move) {
  if (move is Move) {
    print('${move.fromAlgebraic} -> ${move.toAlgebraic}');
  } else if (move is ShortMove) {
    print('${move.from} -> ${move.to}');
  } else {
    print(move);
  }
}

void incrementMove() {
  moveIndex++;
}

bool validMoveFromFEN(String fen, dynamic move) {
  final chess = Chess.fromFEN(fen);
  return validMove(chess, move);
}

bool validMove(Chess chess, dynamic move) {
  final expected = expectedMove();
  if (expected == null) return false;
  print('expected: $expected');
  printMove(move);
  if (moveEqualsSan(chess, move, expected)) {
    return true;
  }
  return false;
}

String? makeMove(String fen, dynamic move) {
  final chess = Chess.fromFEN(fen);
  chess.move(move);
  incrementMove();
  return chess.fen;
}

Move? moveFromSan(Chess chess, String move) {
  final moves = chess.generate_moves();
  for (var i = 0, len = moves.length; i < len; i++) {
    /* strip off any trailing move decorations: e.g Nf3+?! */
    if (move.replaceAll(RegExp(r'[+#?!=]+$'), '') == chess.move_to_san(moves[i]).replaceAll(RegExp(r'[+#?!=]+$'), '')) {
      return moves[i];
    }
  }
  return null;
}

Move? getNextMove(String fen) {
  final chess = Chess.fromFEN(fen);
  final expected = expectedMove();
  print("expected next: $expected");
  if (expected == null) return null;
  final move = moveFromSan(chess, expected);
  printMove(move);
  return move;
}

String? getRandomMove(String fen) {
  final chess = Chess.fromFEN(fen);

  final moves = chess.moves();

  if (moves.isEmpty) {
    return null;
  }

  moves.shuffle();

  return moves.first;
}
