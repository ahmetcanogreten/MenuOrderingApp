import 'package:meal_ordering_app/features/menu/models/order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IOrderRepository {
  Future<List<Order>> getOrders({required List<int> menuIds});

  Future<bool> orderMenu({required int menuId});

  Future<bool> removeOrder({required int orderId});
}

class OrderRepository extends IOrderRepository {
  @override
  Future<bool> orderMenu({required int menuId}) async {
    final resOrder = await Supabase.instance.client.from('order').insert({
      'menuId': menuId,
      'userId': Supabase.instance.client.auth.currentUser!.id
    }).execute();

    if (resOrder.hasError) {
      return false;
    } else {
      return true;
    }
  }

  // @override
  // Future<List<Order>> getMyOrders({required List<int> menuIds}) async {
  //   final res = await Supabase.instance.client
  //       .from('order')
  //       .select()
  //       .eq('userId', Supabase.instance.client.auth.currentUser?.id)
  //       .in_('menuId', menuIds)
  //       .execute();

  //   if (res.hasError) {
  //     // TODO
  //     return [];
  //   } else {
  //     final orders = (res.data! as List)
  //         .map((e) => Order.fromJson(e as Map<String, dynamic>))
  //         .toList();
  //     return orders;
  //   }
  // }

  @override
  Future<List<Order>> getOrders({required List<int> menuIds}) async {
    final res = await Supabase.instance.client
        .from('order')
        .select()
        .in_('menuId', menuIds)
        .execute();

    if (res.hasError) {
      // TODO
      return [];
    } else {
      final orders = (res.data! as List)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList();
      return orders;
    }
  }

  @override
  Future<bool> removeOrder({required int orderId}) async {
    final res = await Supabase.instance.client
        .from('order')
        .delete()
        .eq('id', orderId)
        .execute();

    if (res.hasError) {
      return false;
    } else {
      return true;
    }
  }
}
