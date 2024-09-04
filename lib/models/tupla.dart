class Tupla {
  final int chave;
  final String valor;

  Tupla({required this.chave, required this.valor});

  @override
  String toString() {
    return 'Tupla {chave: $chave, valor: $valor}';
  }
}