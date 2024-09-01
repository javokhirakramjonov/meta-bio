import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String firstName;
  final String lastName;
  final String avatar;
  final int score;
  int? rank;

  User({
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.score,
    this.rank,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
