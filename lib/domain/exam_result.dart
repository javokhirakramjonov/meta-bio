import 'package:json_annotation/json_annotation.dart';
import 'package:meta_bio/domain/user.dart';

part 'exam_result.g.dart';

@JsonSerializable()
class ExamResult {
  final int id;
  final User user;
  final int score;
  final int correctCount;
  final int inCorrectCount;
  final String duration;

  ExamResult({
    required this.id,
    required this.user,
    required this.score,
    required this.correctCount,
    required this.inCorrectCount,
    required this.duration,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) =>
      _$ExamResultFromJson(json);

  Map<String, dynamic> toJson() => _$ExamResultToJson(this);
}
