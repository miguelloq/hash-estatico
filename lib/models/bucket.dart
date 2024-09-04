import 'package:hashbucket/models/pagina.dart';
import 'package:hashbucket/models/tabela.dart';
import 'package:hashbucket/models/tupla.dart';
import 'package:hashbucket/models/constants.dart';

class RowBucket{
  final String chave;
  final int numPagina;
  RowBucket({required this.chave, required this.numPagina});
}

class Bucket {
  final String id;
  final List<RowBucket> lista;
  Bucket? overflowBucket;
  int cntOverflow = 0;

  Bucket({
    required this.id,
    required this.lista,
  });

  bool isOverflow() => lista.length == Constants.qtdTuplasInBucket();
}
