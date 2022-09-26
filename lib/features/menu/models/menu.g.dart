// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
      id: json['id'] as int,
      name: json['name'] as String,
      date: json['date'] as String,
      createdAt: json['created_at'] as String,
      isOrderable: json['isOrderable'] as bool,
      meals: (json['meals'] as List<dynamic>?)
              ?.map((e) => Meal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': instance.date,
      'created_at': instance.createdAt,
      'isOrderable': instance.isOrderable,
      'meals': instance.meals,
    };
