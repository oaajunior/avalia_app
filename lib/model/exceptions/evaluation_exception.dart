class EvaluationException implements Exception {
  final String message;
  EvaluationException(this.message);

  @override
  String toString() {
    return message;
  }
}
