enum QuestionType {
  singleChoice(0),
  multipleChoice(1);

  final int id;

  const QuestionType(this.id);

  static QuestionType fromId(int id) {
    return QuestionType.values.firstWhere(
      (e) => e.id == id,
      orElse: () => throw ArgumentError('Invalid QuestionType id: $id'),
    );
  }
}
