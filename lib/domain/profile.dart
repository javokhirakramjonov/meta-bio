import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  Profile(this.id, this.firstName, this.lastName, this.phoneNumber);

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  Profile copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) {
    return Profile(
      id ?? this.id,
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      phoneNumber ?? this.phoneNumber,
    );
  }
}
