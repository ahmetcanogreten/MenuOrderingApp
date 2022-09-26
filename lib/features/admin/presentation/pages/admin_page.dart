import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_ordering_app/features/admin/presentation/widgets/add_menu.dart';
import 'package:meal_ordering_app/features/admin/presentation/widgets/cell_with_menu_count.dart';
import 'package:meal_ordering_app/features/admin/presentation/widgets/menu_expandable_tile.dart';
import 'package:meal_ordering_app/features/menu/bloc/orders_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:meal_ordering_app/features/menu/bloc/menu_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

const kMenuPollTimerInMs = 500;

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  DateTime _selectedDay = DateTime.now();
  bool _isAddingMeal = false;
  Timer? _menuGetTimer;
  Timer? _ordersGetTimer;

  @override
  void initState() {
    super.initState();

    _menuGetTimer = Timer.periodic(
        const Duration(milliseconds: kMenuPollTimerInMs), (timer) {
      context
          .read<MenuBloc>()
          .add(GetMenus(year: _selectedDay.year, month: _selectedDay.month));
    });

    _ordersGetTimer = Timer.periodic(
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
      builder: (context, state) {
        if (state is MenuLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MenusLoaded) {
          final menus = state.menus;

          return SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(2.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        margin: EdgeInsets.all(2.w),
                        child: TableCalendar(
                          headerStyle: const HeaderStyle(
                              formatButtonVisible: false, titleCentered: true),
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
                                (day.isAfter(today) || isSameDay(day, today));
                          },
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _selectedDay = focusedDay;
                            });

                            _menuGetTimer?.cancel();
                            _menuGetTimer = Timer.periodic(
                                const Duration(
                                    milliseconds: kMenuPollTimerInMs), (timer) {
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
                                      menus: menus),
                              defaultBuilder: (context, day, focusedDay) =>
                                  CellWithMenuCount(
                                      day: day,
                                      focusedDay: focusedDay,
                                      menus: menus),
                              selectedBuilder: (context, day, focusedDay) =>
                                  CellWithMenuCount(
                                      day: day,
                                      focusedDay: focusedDay,
                                      menus: menus)),
                          focusedDay: _selectedDay,
                          firstDay: DateTime.utc(2022, 1, 1),
                          lastDay: DateTime.utc(2030, 1, 1),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: BlocBuilder<OrdersBloc, OrdersState>(
                            builder: (context, orderState) {
                              final orders =
                                  (orderState as OrdersLoaded).orders;
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        tr('lbl_orders'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                    ...menus
                                        .where((eachMenu) => isSameDay(
                                            DateTime.parse(eachMenu.date),
                                            _selectedDay))
                                        .map((eachMenu) => Row(
                                              children: [
                                                Text('${eachMenu.name} : '),
                                                Text(
                                                    '${orders.where((eachOrder) => eachOrder.menuId == eachMenu.id).length}'),
                                              ],
                                            ))
                                        .toList()
                                  ]);
                            },
                          ),
                        ),
                      ),
                      ...menus
                          .where((eachMenu) => isSameDay(
                              DateTime.parse(eachMenu.date), _selectedDay))
                          .map((eachMenu) => Card(
                                  child: MenuExpandableTile(
                                menu: eachMenu,
                                isForAdmin: true,
                              )))
                          .toList(),
                      _isAddingMeal
                          ? AddMenu(
                              date: _selectedDay,
                              onComplete: () {
                                setState(() {
                                  _isAddingMeal = false;
                                });
                              },
                            )
                          : ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: Text(tr('lbl_add_menu')),
                              onPressed: () {
                                setState(() {
                                  _isAddingMeal = true;
                                });
                              },
                            ),
                      SizedBox(height: 10.h)
                    ],
                  ),
                )
              ],
            ),
          );
        }

        return const Text('Error State'); // TODO
      },
    );
  }
}
