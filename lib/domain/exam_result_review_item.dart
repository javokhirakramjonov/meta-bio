import 'package:json_annotation/json_annotation.dart';
import 'package:meta_bio/domain/question.dart';

part 'exam_result_review_item.g.dart';

@JsonSerializable()
class ExamResultReviewItem {
  final Question question;
  final Set<int> selectedVariantIds;
  final Set<int> correctVariantIds;

  ExamResultReviewItem({
    required this.question,
    required this.selectedVariantIds,
    required this.correctVariantIds,
  });

  factory ExamResultReviewItem.fromJson(Map<String, dynamic> json) =>
      _$ExamResultReviewItemFromJson(json);

  Map<String, dynamic> toJson() => _$ExamResultReviewItemToJson(this);
}
