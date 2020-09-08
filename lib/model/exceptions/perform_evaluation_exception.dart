class PerformEvaluationException implements Exception {
  final String message;
  PerformEvaluationException(this.message);

  @override
  String toString() {
    return message;
  }
}
