part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersLoaded extends OrdersState {
  final List<Order> orders;

  const OrdersLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}
