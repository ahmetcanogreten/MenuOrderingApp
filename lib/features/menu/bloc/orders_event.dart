part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class GetOrders extends OrdersEvent {
  final List<int> menuIds;

  const GetOrders({required this.menuIds});

  @override
  List<Object> get props => [menuIds];
}

class OrderMenuEvent extends OrdersEvent {
  final int menuId;

  const OrderMenuEvent({required this.menuId});

  @override
  List<Object> get props => [menuId];
}

class RemoveOrderMenuEvent extends OrdersEvent {
  final int orderId;

  const RemoveOrderMenuEvent({required this.orderId});

  @override
  List<Object> get props => [orderId];
}
