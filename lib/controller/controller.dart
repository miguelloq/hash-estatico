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
      final pagina = _readValue(bucket: chosenBucket, value: valor);
      if (pagina != null) {
        searchResult = "Chave encontrada na página $pagina.";
      } else {
        searchResult = "Chave não encontrada.";
      }
      notifyListeners();
    }
  }

  int? _readValue({required Bucket? bucket,required String value}){
    final lista = bucket?.lista ?? [];
    for(final rowBucket in lista){
      if(rowBucket.chave==value){
        return rowBucket.numPagina;
      }
    }
    if(bucket!=null){
      _readValue(bucket: bucket.overflowBucket, value: value);
    }
    return null;
  }

}