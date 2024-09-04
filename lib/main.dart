import 'package:flutter/material.dart';
import 'package:hashbucket/controller/controller.dart';
import 'package:hashbucket/controller/data_loader.dart';
import 'package:hashbucket/models/pagina.dart';
import 'package:hashbucket/models/tabela.dart';
import 'package:hashbucket/models/tupla.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hash Index App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (_) => Controller(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final TextEditingController _bucketCountController = TextEditingController();
  final TextEditingController _pageSizeController = TextEditingController();
  final TextEditingController _searchKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Controller>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hash Index App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _bucketCountController,
              decoration: const InputDecoration(labelText: 'Número de Buckets'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _pageSizeController,
              decoration: const InputDecoration(labelText: 'Tamanho da Página'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pageSize = int.tryParse(_pageSizeController.text) ?? 10;
                //final Tabela dados = Tabela(lista: List.generate(466000, (index) => Tupla(valor: 'nome $index', chave: index)));
                //provider.createBuckets(dados: dados, pageSize: pageSize);
                final dataLoader = await DataLoader.loadFromFile();
              },
              child: const Text('Construir Índice'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchKeyController,
              decoration: const InputDecoration(labelText: 'Chave de Busca (valor da tupla)'),
            ),
            ElevatedButton(
              onPressed: () {
                final valor = _searchKeyController.text;
                provider.search(valor);
              },
              child: const Text('Buscar'),
            ),
            ElevatedButton(
              onPressed: () {
                final valor = _searchKeyController.text;
                provider.tableScan(valor);
              },
              child: const Text('Table Scan'),
            ),
            const SizedBox(height: 20),
            Text('Resultado da Busca: ${provider.searchResult}'),
            const SizedBox(height: 20),
            Text('Resultado do Table Scan: ${provider.tableScanResult}'),
          ],
        ),
      ),
    );
  }
}