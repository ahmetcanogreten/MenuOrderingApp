import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_ordering_app/features/menu/bloc/menu_bloc.dart';
import 'package:sizer/sizer.dart';

class AddMenu extends StatefulWidget {
  final void Function() onComplete;
  final DateTime date;
  const AddMenu({required this.onComplete, required this.date, super.key});

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final _menuNameController = TextEditingController();
  final List<TextEditingController> _mealNameControllers = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              tr('lbl_add_menu'),
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            TextFormField(
              controller: _menuNameController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: tr('lbl_menu_name')),
            ),
            SizedBox(height: 4.h),
            ..._mealNameControllers
                .map((eachController) => Padding(
                      padding: EdgeInsets.only(bottom: 4.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 4.w,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: TextFormField(
                              controller: eachController,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: tr('lbl_meal_name')),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _mealNameControllers.remove(eachController);
                              });
                            },
                            child: Icon(Icons.delete, size: 6.w),
                          )
                        ],
                      ),
                    ))
                .toList(),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 4.w,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _mealNameControllers.add(TextEditingController());
                        });
                      },
                      label: Text(tr('lbl_add_meal'))),
                )
              ],
            ),
            SizedBox(height: 8.h),
            ElevatedButton(
                onPressed: () {
                  final menuName = _menuNameController.text;
                  final mealNames = _mealNameControllers
                      .map((eachController) => eachController.text)
                      .where((eachName) => eachName.isNotEmpty)
                      .toList();
                  final date = widget.date;

                  BlocProvider.of<MenuBloc>(context, listen: false).add(
                    AddMenuEvent(
                      menuName: menuName,
                      mealNames: mealNames,
                      date: date,
                    ),
                  );

                  widget.onComplete();
                },
                child: Text(tr('lbl_add_menu')))
          ],
        ),
      ),
    );
  }
}
