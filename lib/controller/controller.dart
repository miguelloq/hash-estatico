import 'package:flutter/cupertino.dart';
import 'package:hashbucket/models/bucket.dart';
import 'package:hashbucket/models/bucket_util.dart';
import 'package:hashbucket/models/constants.dart';

import '../models/pagina.dart';
import '../models/tabela.dart';

class Controller extends ChangeNotifier{
  List<Bucket>? _buckets;
  List<Pagina>? _paginas;
  String statistics = "";
  String searchResult = "";
  String tableScanResult = "";

  void createBuckets({required Tabela dados,required int pageSize}){
    final (buckets,paginas) = BucketsGenerator.call(tabela: dados, withValuePerPage: pageSize);
    _buckets= buckets;
    _paginas=paginas;
    final qPaginas = paginas.length;
    final (qntOverflow, qntColisoes) = _qntStats();
    statistics = "Quantidade de paginas geradas: $qPaginas "
        "\n Quantidade de Buckets gerados: ${buckets.length} "
        "\n Quantidade total de overflows: ${qntOverflow} "
        "\n Quantidade total de colisoes: ${qntColisoes} "
        "\n Porcentagem overflow ${(qntOverflow/buckets.length).toStringAsFixed(2)} "
        "\n Porcentagem colisoes: ${(qntColisoes/dados.lista.length).toStringAsFixed(2)}";
    notifyListeners();
  }

  void tableScan(String valor) {
    final Stopwatch time = Stopwatch()..start();
    int? findedPagina;
    for(final pagina in _paginas!){
       for(final tupla in pagina.valores){
         if(tupla.valor==valor){
           findedPagina=pagina.numero;
           time.stop();
         }
       }
    }
    if(findedPagina==null) time.stop();

    tableScanResult=findedPagina==null?
    "Nao foi encontrada"
    :"Valor encontrado na pagina de numero $findedPagina com o tempo ${time.elapsedMilliseconds} em ms";

    notifyListeners();
  }

  void search(String valor) {
    if (_buckets != null) {
      final bucketNumber = Constants.hashFunction(valor,_buckets!.length);
      final chosenBucket = _buckets?[bucketNumber];
      // if (chosenBucket != null) {
      //   print(chosenBucket.lista);
      //   print('of: ${chosenBucket.cntOverflow}');
      //   print(chosenBucket.overflowBucket?.lista);
      // }
      final pagina = _readValue(bucket: chosenBucket, value: valor);
      if (pagina != null) {
        searchResult = "Chave encontrada na página $pagina. Bucket que a chave foi encontrada tem OF: ${chosenBucket!.cntOverflow.toString()}";
      } else {
        searchResult = "Chave não encontrada.";
      }
      notifyListeners();
    }
  }

  int? _readValue({required Bucket? bucket, required String value}) {
    final lista = bucket?.lista ?? [];

    for (final rowBucket in lista) {
      if (rowBucket.chave.compareTo(value) == 0) {
        return rowBucket.numPagina;
      }
    }

    if (bucket?.overflowBucket != null) {
      return _readValue(bucket: bucket!.overflowBucket, value: value);
    }

    return null;
  }
  (int qntOverflow, int qntColisao) _qntStats(){
    int qntOverflow = 0;
    int qntColisoes = 0;
    if(_buckets==null) return (0,0);
    for(final bucket in _buckets!){
      qntOverflow+=bucket.cntOverflow;
      qntColisoes+=bucket.cntColisao;
    }
    return (qntOverflow,qntColisoes);
  }
}