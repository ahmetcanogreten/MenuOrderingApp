import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_ordering_app/features/menu/bloc/orders_bloc.dart';
import 'package:meal_ordering_app/features/menu/models/order.dart';
import 'package:sizer/sizer.dart';

import 'package:meal_ordering_app/features/admin/presentation/widgets/meal_editable_tile.dart';
import 'package:meal_ordering_app/features/menu/bloc/menu_bloc.dart';

import 'package:meal_ordering_app/features/menu/models/menu.dart';
import 'package:table_calendar/table_calendar.dart';

class MenuExpandableTile extends StatelessWidget {
  final Menu menu;
  final bool isForAdmin;
  const MenuExpandableTile(
      {required this.menu, this.isForAdmin = false, super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(menu.name),
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      expandedAlignment: Alignment.bottomLeft,
      childrenPadding: EdgeInsets.all(4.w),
      children: [
        ...menu.meals.map((eachMeal) => MealEditableTile(meal: eachMeal)),
        SizedBox(height: 2.h),
        isForAdmin
            ? ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red[700])),
                icon: const Icon(Icons.delete),
                label: Text(tr('lbl_remove_menu')),
                onPressed: () {
                  context
                      .read<MenuBloc>()
                      .add(DeleteMenuEvent(menuId: menu.id));
                },
              )
            : BlocBuilder<MenuBloc, MenuState>(
                builder: (menuContext, menuState) {
                  return BlocBuilder<OrdersBloc, OrdersState>(
                    builder: (context, state) {
                      Order? order;
                      try {
                        order = (state as OrdersLoaded).orders.firstWhere(
                            (eachOrder) => eachOrder.menuId == menu.id);
                      } on StateError {
                        // do nothing
                      }

                      return ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green[700]),
                        ),
                        icon: Icon(order != null
                            ? Icons.favorite
                            : Icons.favorite_border),
                        label: Text(order != null
                            ? tr('lbl_remove_order')
                            : tr('lbl_order')),
                        onPressed: () async {
                          if (order != null) {
                            context
                                .read<OrdersBloc>()
                                .add(RemoveOrderMenuEvent(orderId: order.id));
                          } else {
                            final allOrders = (state as OrdersLoaded).orders;
                            final allMenus = (menuState as MenusLoaded).menus;
                            final bool isThereAnyOtherOrderForThisDay =
                                allOrders.any((eachOrder) => allMenus.any(
                                    (eachMenu) =>
                                        menu.date == eachMenu.date &&
                                        eachMenu.id == eachOrder.menuId));
                            if (isThereAnyOtherOrderForThisDay) {
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(tr('lbl_cannot_order')),
                                        content:
                                            Text(tr('lbl_cannot_order_more')),
                                      ));
                            } else {
                              context
                                  .read<OrdersBloc>()
                                  .add(OrderMenuEvent(menuId: menu.id));
                            }
                          }
                        },
                      );
                    },
                  );
                },
              )
      ],
    );
  }
}
