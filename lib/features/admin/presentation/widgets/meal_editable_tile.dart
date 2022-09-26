import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:meal_ordering_app/features/menu/models/meal.dart';

class MealEditableTile extends StatefulWidget {
  final Meal meal;
  const MealEditableTile({required this.meal, super.key});

  @override
  State<MealEditableTile> createState() => _MealEditableTileState();
}

class _MealEditableTileState extends State<MealEditableTile> {
  bool _isEditing = false;
  String _currentName = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 4.w,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 4.w),
          if (_isEditing) ...[
            Expanded(
              child: TextFormField(
                initialValue: _currentName,
              ),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.done, size: 4.w)),
          ] else ...[
            Text(widget.meal.name),
            // const Expanded(child: SizedBox()),
            // IconButton(
            //   icon: Icon(Icons.edit, size: 4.w),
            //   onPressed: () {
            //     setState(() {
            //       _isEditing = true;
            //       _currentName = widget.meal.name;
            //     });
            //   }, // TODO : Edit meal
            // ),
            // IconButton(
            //   icon: Icon(Icons.delete, size: 4.w),
            //   onPressed: () {}, // TODO : Delete meal
            // ),
          ],
        ],
      ),
    );
  }
}
