import 'package:json_annotation/json_annotation.dart';
import 'package:meta_bio/domain/user.dart';

part 'leader.g.dart';

@JsonSerializable()
class Leader {
  final int rank;
  final User user;

  Leader({
    required this.rank,
    required this.user,
  });

  factory Leader.fromJson(Map<String, dynamic> json) => _$LeaderFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderToJson(this);
}
