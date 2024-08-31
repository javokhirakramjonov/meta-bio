import 'package:json_annotation/json_annotation.dart';

part 'exam_item_result.g.dart';

@JsonSerializable()
class ExamItemResult {
  final int score;
  final int correctCount;
  final int inCorrectCount;
  final String duration;

  ExamItemResult({
    required this.score,
    required this.correctCount,
    required this.inCorrectCount,
    required this.duration,
  });

  factory ExamItemResult.fromJson(Map<String, dynamic> json) =>
      _$ExamItemResultFromJson(json);

  Map<String, dynamic> toJson() => _$ExamItemResultToJson(this);
}
