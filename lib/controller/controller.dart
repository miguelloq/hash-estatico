import 'package:flutter/cupertino.dart';
import 'package:hashbucket/models/bucket.dart';
import 'package:hashbucket/models/bucket_util.dart';
import 'package:hashbucket/models/constants.dart';

import '../models/tabela.dart';

class Controller extends ChangeNotifier{
  List<Bucket>? _buckets;

  String searchResult = "";
  String tableScanResult = "";

  void createBuckets({required Tabela dados,required int pageSize}){
    _buckets=BucketsGenerator.call(tabela: dados, withValuePerPage: pageSize);
    notifyListeners();
  }

  void tableScan(String valor) {
    if (_buckets != null) {
      tableScanResult = "Table scan nao implementado.";
      notifyListeners();
    }
  }

  void search(String valor) {
    if (_buckets != null) {
      final bucketNumber = Constants.hashFunction(valor);
      final chosenBucket = _buckets?[bucketNumber];
      // if (chosenBucket != null) {
      //   print(chosenBucket.lista);
      //   print('of: ${chosenBucket.cntOverflow}');
      //   print(chosenBucket.overflowBucket?.lista);
      // }
      final pagina = _readValue(bucket: chosenBucket, value: valor);
      if (pagina != null) {
        searchResult = "Chave encontrada na página $pagina. OF: ${chosenBucket!.cntOverflow.toString()}";
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

}