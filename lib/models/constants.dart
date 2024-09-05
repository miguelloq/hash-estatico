class Constants{
  static filePath() =>"C:/Users/mlple/Downloads/words.txt";
  static int qtdTuplasInBucket() => 5;

  static int hashFunction(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = 31 * hash + input.codeUnitAt(i);
    }
    return hash.abs() % 80001;
  }
}