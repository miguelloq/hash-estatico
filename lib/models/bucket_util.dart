import 'package:hashbucket/models/pagina.dart';
import 'package:hashbucket/models/tabela.dart';

import 'bucket.dart';
import 'constants.dart';

class BucketsGenerator{
  static int _calcNB(int nr, int fr) => (nr/fr).ceil() + 1;

  static void _addValueBucket(Bucket bucket,String tuplaValor, int numPagina){
    final lista = bucket.lista;
    if (bucket.isOverflow()) {
      if (bucket.overflowBucket == null) {
        bucket.cntOverflow++;
        bucket.overflowBucket = Bucket(id:bucket.cntOverflow.toString(),lista:[]);
      }
      _addValueBucket(bucket.overflowBucket!, tuplaValor, numPagina);
      bucket.cntColisao++;
    } else {
      lista.add(RowBucket(chave: tuplaValor, numPagina: numPagina));
    }
  }

  static List<Bucket> _generateBuckets({required List<Pagina> paginas, required int nb}){
    List<Bucket> buckets = List.generate(nb,(int idx)=>Bucket(id:idx.toString(),lista:[])).toList();
    for(final pagina in paginas){
      for(final tupla in pagina.valores){
        final desirableBucketId =  Constants.hashFunction(tupla.valor,buckets.length);
        final desirableBucket = buckets[desirableBucketId];
        _addValueBucket(desirableBucket, tupla.valor, pagina.numero);
      }
    }
    return buckets;
  }

  static (List<Bucket>, List<Pagina>) call({required Tabela tabela,required int withValuePerPage}){
    final List<Pagina> paginas = Pagina.from(tabela:tabela,withValuePerPage:withValuePerPage);
    final nr = tabela.lista.length;
    final fr = Constants.qtdTuplasInBucket();
    final nb = _calcNB(nr, fr);
    return (_generateBuckets(paginas: paginas,nb: nb),paginas);
  }
}