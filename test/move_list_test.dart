import 'package:flutter_test/flutter_test.dart';
import 'package:random_chess_app/models/move_list.dart';

void main() {
  test('test string splitter - one child', () {
    final data = '''e4 e5 Nf3 Nc6 Bb5 : # Ruy Lopez
  Nf6 O-O Nxe4 Re1 : 
    Nd6 Nxe5 : 
      Nxb5 Nxc6 Be7 Nxd8 Kxd8
      Nxe5 Nc3 Nxb5 Rxe5 Be7 Nd5
  a6
''';
    final splitData = data.split('\n');
    print(splitData);
    print(specialSplit(data: splitData, indent: 0));
  });

  test('test string splitter - two children', () {
    final data = '''e4 e5 Nf3 Nc6 Bb5 : # Ruy Lopez
  Nf6 O-O Nxe4 Re1 : 
    Nd6 Nxe5 : 
      Nxb5 Nxc6 Be7 Nxd8 Kxd8
      Nxe5 Nc3 Nxb5 Rxe5 Be7 Nd5
  a6
''';
    final splitData = data.split('\n').sublist(1);
    print(splitData);
    print(specialSplit(data: splitData, indent: 1));
  });

  test('test create variations', () {
    final data = '''e4 e5 Nf3 Nc6 Bb5 : # Ruy Lopez
  Nf6 O-O Nxe4 Re1 : 
    Nd6 Nxe5 : 
      Nxb5 Nxc6 Be7 Nxd8 Kxd8
      Nxe5 Nc3 Nxb5 Rxe5 Be7 Nd5
  a6''';
    final dataList = data.split('\n').toList();
    print(Variation.fromStrings(dataList).allVariationStrings().toList().join('\n---\n'));
  });

  test('test create simple variations', () {
    final data = '''e4 e5 Nf3 Nc6 Bb5 # Ruy Lopez
  Nf6 O-O Nxe4 Re1 
  a6
b4 e5
  a3
  a5
c4''';
    final dataList = data.split('\n').toList();
    print(allVariationStrings(Variation.iterableFromStrings(dataList)).toList().join('\n---\n'));
  });
}
