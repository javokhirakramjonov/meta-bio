import 'package:json_annotation/json_annotation.dart';

part 'module.g.dart';

@JsonSerializable()
class Module {
  final int id;
  final String name;
  final int rank;
  final int examsCount;

  Module({
    required this.id,
    required this.name,
    required this.rank,
    required this.examsCount,
  });

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleToJson(this);
}
