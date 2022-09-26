part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class GetMenus extends MenuEvent {
  final int year;
  final int month;

  const GetMenus({required this.year, required this.month});

  @override
  List<Object> get props => [year, month];
}

class AddMenuEvent extends MenuEvent {
  final String menuName;
  final List<String> mealNames;
  final DateTime date;

  const AddMenuEvent(
      {required this.menuName, required this.mealNames, required this.date});

  @override
  List<Object> get props => [menuName, mealNames, date];
}

class DeleteMenuEvent extends MenuEvent {
  final int menuId;

  const DeleteMenuEvent({required this.menuId});

  @override
  List<Object> get props => [menuId];
}
