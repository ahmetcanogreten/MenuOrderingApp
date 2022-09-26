import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal.g.dart';

@JsonSerializable()
class Meal extends Equatable {
  final int id;
  final int menuId;
  final String name;

  @JsonKey(name: 'created_at')
  final String createdAt;

  const Meal({
    required this.id,
    required this.menuId,
    required this.name,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, menuId, name, createdAt];

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  Map<String, dynamic> toJson() => _$MealToJson(this);
}
