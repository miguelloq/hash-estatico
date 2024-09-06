import 'package:flutter/material.dart';
import 'package:hashbucket/controller/controller.dart';
import 'package:hashbucket/controller/data_loader.dart';
import 'package:hashbucket/models/pagina.dart';
import 'package:hashbucket/models/tabela.dart';
import 'package:hashbucket/models/tupla.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hash Index App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (_) => Controller(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hash Index App'),
      ),
      body: FutureBuilder<List<Tupla>>(
        future: DataLoader.loadFromFile(),
        builder: (context, snapshot) => switch (snapshot) {
          (final snapshot)
              when snapshot.connectionState == ConnectionState.waiting =>
            const Center(child: CircularProgressIndicator()),

          (final snapshot) when snapshot.data is List<Tupla> =>
            MainContent(data: snapshot.data as List<Tupla>),

          (_) => const Center(child: Text("Erro em pegar os dados")),
        },
      ),
    );
  }
}

class MainContent extends StatefulWidget {
  final List<Tupla> data;

  const MainContent({super.key, required this.data});

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  final TextEditingController _pageSizeController = TextEditingController();
  final TextEditingController _searchKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Controller>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _pageSizeController,
            decoration: const InputDecoration(labelText: 'Tamanho da Página'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => provider.createBuckets(
              dados: Tabela(lista: widget.data),
              pageSize: int.tryParse(_pageSizeController.text) ?? 10,
            ),
            child: const Text('Construir Índice'),
          ),
          const SizedBox(height: 20),
          Text(provider.statistics,textAlign:TextAlign.center),
          const SizedBox(height: 20),
          provider.statistics.isNotEmpty?
              Column(children: [
                TextField(
                  controller: _searchKeyController,
                  decoration: const InputDecoration(
                      labelText: 'Chave de Busca (valor da tupla)'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => provider.search(_searchKeyController.text),
                  child: const Text('Buscar'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => provider.tableScan(_searchKeyController.text,),
                  child: const Text('Table Scan'),
                ),
                const SizedBox(height: 20),
                Text('Resultado da Busca: ${provider.searchResult}'),
                const SizedBox(height: 20),
                Text('Resultado do Table Scan: ${provider.tableScanResult}'),
              ],):const SizedBox()
        ],
      ),
    );
  }
}
