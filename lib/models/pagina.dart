import 'dart:collection';

import 'package:hashbucket/models/tabela.dart';
import 'package:hashbucket/models/tupla.dart';

class Pagina {
  final int numero;
  final List<Tupla> valores;

  Pagina._({required this.numero, required this.valores});

  static List<Pagina> from({required Tabela tabela, required int withValuePerPage}) {
    int registroQuantity = tabela.lista.length;
    int paginaQuantity = (registroQuantity / withValuePerPage).ceil();
    final List<Pagina> listaPagina = [];
    int index = 0;
    for (var i = 0; i < paginaQuantity; i++) {
      listaPagina.add(Pagina._(numero: index++, valores: tabela.lista.skip(i * withValuePerPage).take(withValuePerPage).toList()));
    }
    return listaPagina;
  }

  @override
  String toString() {
    String text = valores.fold("", (previousValue, element) => previousValue + element.toString() + "\n");
    return "Pagina {numero: $numero:\n$text}";
  }
}