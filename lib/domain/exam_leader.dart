import 'package:json_annotation/json_annotation.dart';
import 'package:meta_bio/domain/user.dart';

part 'exam_leader.g.dart';

@JsonSerializable()
class ExamLeader {
  final User user;
  final int score;
  final int correctCount;
  final int inCorrectCount;
  final String duration;
  final int rank;

  ExamLeader({
    required this.user,
    required this.score,
    required this.correctCount,
    required this.inCorrectCount,
    required this.duration,
    required this.rank,
  });

  factory ExamLeader.fromJson(Map<String, dynamic> json) =>
      _$ExamLeaderFromJson(json);

  Map<String, dynamic> toJson() => _$ExamLeaderToJson(this);
}
