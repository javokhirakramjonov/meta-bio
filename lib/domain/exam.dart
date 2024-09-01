import 'package:json_annotation/json_annotation.dart';
import 'package:meta_bio/domain/exam_item_result.dart';

part 'exam.g.dart';

@JsonSerializable()
class Exam {
  final int id;
  final int moduleId;
  final String title;
  final String description;
  final bool isPublished;
  final int rank;
  final int questionsCount;
  final int submissionsCount;
  final ExamItemResult? result;

  Exam({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.description,
    required this.isPublished,
    required this.rank,
    required this.questionsCount,
    required this.submissionsCount,
    this.result,
  });

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);

  Map<String, dynamic> toJson() => _$ExamToJson(this);
}
