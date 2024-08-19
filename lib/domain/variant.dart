import 'package:json_annotation/json_annotation.dart';

part 'variant.g.dart';

@JsonSerializable()
class Variant {
  final int id;
  final String text;

  Variant({
    required this.id,
    required this.text,
  });

  factory Variant.fromJson(Map<String, dynamic> json) =>
      _$VariantFromJson(json);

  Map<String, dynamic> toJson() => _$VariantToJson(this);
}
