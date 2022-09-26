// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      id: json['id'] as int,
      menuId: json['menuId'] as int,
      name: json['name'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'id': instance.id,
      'menuId': instance.menuId,
      'name': instance.name,
      'created_at': instance.createdAt,
    };
