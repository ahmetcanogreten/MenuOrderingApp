import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meal_ordering_app/features/menu/models/meal.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu extends Equatable {
  final int id;
  final String name;
  final String date;

  @JsonKey(name: 'created_at')
  final String createdAt;
  final bool isOrderable;

  @JsonKey(defaultValue: [])
  final List<Meal> meals;

  const Menu({
    required this.id,
    required this.name,
    required this.date,
    required this.createdAt,
    required this.isOrderable,
    required this.meals,
  });

  @override
  List<Object> get props => [id, name, date, createdAt, isOrderable, meals];

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
