import 'dart:io';

import 'package:hashbucket/models/constants.dart';

import '../models/tupla.dart';

class DataLoader {
  static Future<List<Tupla>> loadFromFile() async {
    final file = File(Constants.filePath());
    final lines = await file.readAsLines();

    final List<Tupla> tuplas = [];

    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      var tupla = Tupla(chave: i, valor: line);
      tuplas.add(tupla);
    }
    return tuplas;
  }
}