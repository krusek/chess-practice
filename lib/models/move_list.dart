import 'package:collection/collection.dart';

int countSpaces(String data) {
  return data.length - data.trimLeft().length;
}

List<List<String>> specialSplit({required List<String> data, int indent = 0}) {
  if (data.length == 0) return [];
  if (data.length == 1) return [data];

  final indentString = ''.padLeft(2 * indent);
  final childIndentString = indentString + '  ';
  List<int> children = [];
  final start = 0;
  int index = start;
  while (index < data.length) {
    final temp = data[index];
    final indentSize = countSpaces(temp);
    print('indent size: $indentSize');
    if (indentSize > 2 * indent) {
      print('too much indent: \n $temp');
      index++;
    } else if (indentSize == 2 * indent) {
      print('right indent: \n $temp');
      children.add(index);
      index++;
    } else {
      print('different indent: \n $temp, $indentSize, $indent');
      children.add(index);
      break;
    }
  }
  children.add(data.length);
  print(children);
  if (children.length == 1) {
    return [data];
  }
  final firstRemoved = children.sublist(1);
  return IterableZip([children, firstRemoved]).map((e) {
    return data.sublist(e.first, e.last);
  }).toList();
}

class Variation {
  final String name;
  final List<String> moves;
  final List<Variation> children;
  Variation(this.name, this.moves, this.children);

  static Variation fromStrings(List<String> data, [int indent = 0]) {
    // assert(data.isNotEmpty, 'data cannot be empty to create Variation');
    if (data.isEmpty) {
      print('empty data');
      return Variation('bad', [], []);
    }

    final line = data[0];
    final parts = line.split('#');
    final moves = parts[0].split(' ').where((element) => element != ':').toList();
    final name = parts.length == 2 ? parts[1].trim() : '';
    if (data.length == 1) {
      return Variation(
        name,
        moves,
        [],
      );
    }
    final children = Variation.iterableFromStrings(data.sublist(1), indent + 1);
    return Variation(name, moves, children.toList());
  }

  static Iterable<Variation> iterableFromStrings(List<String> data, [int indent = 0]) {
    final splitData = specialSplit(data: data, indent: indent);
    return splitData.map((e) {
      print(e);
      return Variation.fromStrings(e, indent);
    });
  }

  Iterable<String> allVariationStrings() sync* {
    final moveString = moves.join(' ');
    if (children.isEmpty) {
      yield moveString;
      return;
    }

    for (final child in children) {
      for (final moves in child.allVariationStrings()) {
        yield moveString.trim() + ' ' + moves.trim();
      }
    }
  }
}

Iterable<String> allVariationStrings(Iterable<Variation> variations) sync* {
  for (final variation in variations) {
    yield* variation.allVariationStrings();
  }
}
