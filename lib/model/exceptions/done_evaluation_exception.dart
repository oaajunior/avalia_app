class DoneEvaluationException implements Exception {
  final String message;
  DoneEvaluationException(this.message);

  @override
  String toString() {
    return message;
  }
}
