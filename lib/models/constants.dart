class Constants{
  static filePath() =>"C:/Users/mlple/Downloads/words.txt";
  static int qtdTuplasInBucket() => 10000;

  static int hashFunction(String input, int qntBuckets) {
    const int prime = 16777619;
    const int offsetBasis = 2166136261;

    int hash = offsetBasis;

    for (int i = 0; i < input.length; i++) {
      hash ^= input.codeUnitAt(i);
      hash *= prime;
    }
    return hash % qntBuckets;
  }
}