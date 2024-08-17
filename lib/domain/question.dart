import 'package:json_annotation/json_annotation.dart';
import 'package:meta_bio/domain/question_type.dart';
import 'package:meta_bio/domain/variant.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  final int id;
  final String text;
  final int mark;
  @JsonKey(fromJson: QuestionType.fromId)
  final QuestionType type;
  final List<Variant> variants;
  final int rank;

  Question({
    required this.id,
    required this.text,
    required this.mark,
    required this.type,
    required this.variants,
    required this.rank,
  });

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
