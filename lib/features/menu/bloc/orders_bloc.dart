import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meal_ordering_app/features/menu/models/order.dart';
import 'package:meal_ordering_app/features/menu/repositories/order_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final IOrderRepository _orderRepository;
  OrdersBloc({required IOrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(const OrdersLoaded(orders: [])) {
    on<GetOrders>((event, emit) async {
      final menuIds = event.menuIds;

      final orders = await _orderRepository.getOrders(menuIds: menuIds);

      emit(OrdersLoaded(orders: orders));
    });

    on<OrderMenuEvent>((event, emit) async {
      final menuId = event.menuId;

      final isMenuOrdered = await _orderRepository.orderMenu(menuId: menuId);
    });

    on<RemoveOrderMenuEvent>((event, emit) async {
      final orderId = event.orderId;

      final isMenuOrdered =
          await _orderRepository.removeOrder(orderId: orderId);
    });
  }
}
