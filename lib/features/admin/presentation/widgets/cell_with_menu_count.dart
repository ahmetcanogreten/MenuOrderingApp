import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sizer/sizer.dart';

import 'package:meal_ordering_app/features/menu/models/menu.dart';

const kDayGreenBorderColor = Colors.green;
const kDayGreenFillColor = Color.fromRGBO(165, 214, 167, 1);

const kDayBlueBorderColor = Colors.blue;
const kDayBlueFillColor = Color.fromRGBO(144, 202, 249, 1);

Color getBorderColor(DateTime day, List<Menu> menus) {
  if (menus.any((eachMenu) => isSameDay(day, DateTime.parse(eachMenu.date)))) {
    return kDayGreenBorderColor;
  } else {
    return kDayBlueBorderColor;
  }
}

int getNumberOfMenuForADay(DateTime day, List<Menu> menus) {
  return menus
      .where((eachMenu) => isSameDay(day, DateTime.parse(eachMenu.date)))
      .length;
}

class CellWithMenuCount extends StatelessWidget {
  final DateTime day;
  final DateTime focusedDay;
  final List<Menu> menus;
  final bool isGreen;

  const CellWithMenuCount(
      {required this.day,
      required this.focusedDay,
      required this.menus,
      this.isGreen = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: isGreen ? kDayGreenFillColor : kDayBlueFillColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: isSameDay(day, focusedDay)
                ? isGreen
                    ? kDayGreenBorderColor
                    : kDayBlueBorderColor
                : Colors.transparent,
            width: 2),
      ),
      child: Stack(
        children: [
          Center(child: Text(day.day.toString())),
          if (getNumberOfMenuForADay(day, menus) != 0)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(1.w),
                child: Text(
                  getNumberOfMenuForADay(day, menus).toString(),
                  style: TextStyle(fontSize: 8.sp),
                ),
              ),
            )
        ],
      ),
    );
  }
}
