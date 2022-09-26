import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_ordering_app/features/admin/presentation/widgets/cell_with_menu_count.dart';
import 'package:meal_ordering_app/features/admin/presentation/widgets/menu_expandable_tile.dart';
import 'package:meal_ordering_app/features/menu/bloc/orders_bloc.dart';
import 'package:meal_ordering_app/features/menu/models/menu.dart';
import 'package:meal_ordering_app/features/menu/models/order.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:meal_ordering_app/features/menu/bloc/menu_bloc.dart';

const kMenuPollTimerInMs = 500;
const kOrderPollTimerInMs = 500;

bool isThereMyOrderForThisDay(
    {required DateTime day,
    required List<Order> myOrders,
    required List<Menu> menus}) {
  try {
    final menusForThisDay =
        menus.where((menu) => isSameDay(DateTime.parse(menu.date), day));

    return myOrders.any((myOrder) =>
        menusForThisDay.any((eachMenu) => eachMenu.id == myOrder.menuId));
  } on StateError {
    return false;
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  Timer? _menuGetTimer;
  Timer? _myOrderGetTimer;

  @override
  void initState() {
    super.initState();

    _menuGetTimer = Timer.periodic(
        const Duration(milliseconds: kMenuPollTimerInMs), (timer) {
      context
          .read<MenuBloc>()
          .add(GetMenus(year: _selectedDay.year, month: _selectedDay.month));
    });

    _myOrderGetTimer = Timer.periodic(
        const Duration(milliseconds: kMenuPollTimerInMs), (timer) {
      List<int> menuIds;
      final menuBlocState = context.read<MenuBloc>().state;
      if (menuBlocState is MenusLoaded) {
        menuIds = menuBlocState.menus.map((e) => e.id).toList();
        context.read<OrdersBloc>().add(GetOrders(menuIds: menuIds));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (menuContext, state) {
        if (state is MenuLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MenusLoaded) {
          final menus = state.menus;

          return BlocBuilder<OrdersBloc, OrdersState>(
            builder: (context, orderState) {
              final myOrders = (orderState as OrdersLoaded)
                  .orders
                  .where((eachOrder) =>
                      eachOrder.userId ==
                      Supabase.instance.client.auth.currentUser?.id)
                  .toList(); // TODO : Remove Supabase from here

              return SafeArea(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(2.w),
                      child: Column(
                        children: [
                          Card(
                            margin: EdgeInsets.all(2.w),
                            child: TableCalendar(
                              headerStyle: const HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true),
                              calendarFormat: CalendarFormat.month,
                              startingDayOfWeek: StartingDayOfWeek.monday,
                              availableGestures: AvailableGestures.none,
                              onDaySelected: (selectedDay, focusedDay) async {
                                setState(() {
                                  _selectedDay = selectedDay;
                                });
                              },
                              enabledDayPredicate: (day) {
                                final today = DateTime.now();
                                return ![DateTime.sunday, DateTime.saturday]
                                        .contains(day.weekday) &&
                                    (day.isAfter(today) ||
                                        isSameDay(day, today));
                              },
                              onPageChanged: (focusedDay) {
                                setState(() {
                                  _selectedDay = focusedDay;
                                });

                                _menuGetTimer?.cancel();
                                _menuGetTimer = Timer.periodic(
                                    const Duration(
                                        milliseconds: kMenuPollTimerInMs),
                                    (timer) {
                                  context.read<MenuBloc>().add(GetMenus(
                                      year: _selectedDay.year,
                                      month: _selectedDay.month));
                                });
                              },
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDay, day);
                              },
                              calendarBuilders: CalendarBuilders(
                                  todayBuilder: (context, day, focusedDay) =>
                                      CellWithMenuCount(
                                        day: day,
                                        focusedDay: focusedDay,
                                        menus: menus,
                                        isGreen: isThereMyOrderForThisDay(
                                            day: day,
                                            myOrders: myOrders,
                                            menus: menus),
                                      ),
                                  defaultBuilder: (context, day, focusedDay) =>
                                      CellWithMenuCount(
                                        day: day,
                                        focusedDay: focusedDay,
                                        menus: menus,
                                        isGreen: isThereMyOrderForThisDay(
                                            day: day,
                                            myOrders: myOrders,
                                            menus: menus),
                                      ),
                                  selectedBuilder: (context, day, focusedDay) =>
                                      CellWithMenuCount(
                                        day: day,
                                        focusedDay: focusedDay,
                                        menus: menus,
                                        isGreen: isThereMyOrderForThisDay(
                                            day: day,
                                            myOrders: myOrders,
                                            menus: menus),
                                      )),
                              focusedDay: _selectedDay,
                              firstDay: DateTime.utc(2022, 1, 1),
                              lastDay: DateTime.utc(2030, 1, 1),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ...menus
                                  .where((eachMenu) => isSameDay(
                                      DateTime.parse(eachMenu.date),
                                      _selectedDay))
                                  .map((eachMenu) => Card(
                                          child: MenuExpandableTile(
                                        menu: eachMenu,
                                      )))
                                  .toList(),
                              SizedBox(height: 10.h)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }

        return const Text('Error State'); // TODO
      },
    );
  }
}
