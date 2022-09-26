import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order extends Equatable {
  final int id;
  final String userId;
  final int menuId;

  const Order({required this.id, required this.userId, required this.menuId});

  @override
  List<Object> get props => [id, userId, menuId];

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
