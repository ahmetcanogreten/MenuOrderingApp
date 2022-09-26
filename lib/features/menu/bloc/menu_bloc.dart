import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meal_ordering_app/features/menu/models/menu.dart';
import 'package:meal_ordering_app/features/menu/models/order.dart';
import 'package:meal_ordering_app/features/menu/repositories/menu_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final IMenuRepository _menuRepository;
  List<Menu> _menus = [];

  MenuBloc({required IMenuRepository menuRepository})
      : _menuRepository = menuRepository,
        super(MenuLoading()) {
    on<GetMenus>((event, emit) async {
      final year = event.year;
      final month = event.month;

      final menus = await _menuRepository.getMenus(year: year, month: month);

      _menus = [...menus];

      emit(MenusLoaded(menus: [..._menus]));
    });

    on<AddMenuEvent>((event, emit) async {
      final menuName = event.menuName;
      final mealNames = event.mealNames;
      final date = event.date;

      final isMenuCreated = _menuRepository.addMenu(
          menuName: menuName, mealNames: mealNames, date: date);
    });

    on<DeleteMenuEvent>((event, emit) async {
      final menuId = event.menuId;

      // TODO : Optimistic delete
      // _menus = [..._menus.where((eachMenu) => eachMenu.id != menuId).toList()];
      // emit(MenusLoaded(menus: _menus));

      final isMenuDeleted = await _menuRepository.deleteMenu(menuId: menuId);
    });
  }
}
