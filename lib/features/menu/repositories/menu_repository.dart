import 'package:easy_localization/easy_localization.dart';
import 'package:meal_ordering_app/features/menu/models/meal.dart';
import 'package:meal_ordering_app/features/menu/models/menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IMenuRepository {
  Future<List<Menu>> getMenus({required int year, required int month});

  Future<bool> addMenu(
      {required String menuName,
      required List<String> mealNames,
      required DateTime date});

  Future<bool> deleteMenu({required int menuId});
}

class MenuRepository extends IMenuRepository {
  @override
  Future<List<Menu>> getMenus({required int year, required int month}) async {
    final nextMonth = month > 12 ? month : month + 1;
    final nextYear = nextMonth > 12 ? year + 1 : year;

    final res = await Supabase.instance.client
        .from('menu')
        .select()
        .gte('date', DateTime.utc(year, month, 1))
        .lte('date', DateTime.utc(nextYear, nextMonth, 1))
        .execute();

    if (res.hasError) {
      // TODO
      return [];
    } else {
      final menus = (res.data! as List)
          .map((e) => Menu.fromJson(e as Map<String, dynamic>))
          .toList();
      final menuIds = menus.map((e) => e.id).toList();
      final resMeals = await Supabase.instance.client
          .from('meal')
          .select()
          .in_('menuId', menuIds)
          .execute();

      if (resMeals.hasError) {
        // TODO
        return [];
      } else {
        for (final eachMeal in (resMeals.data! as List)) {
          menus
              .firstWhere((eachMenu) => eachMenu.id == eachMeal['menuId'])
              .meals
              .add(Meal.fromJson(eachMeal as Map<String, dynamic>));
        }
      }

      return menus;
    }
  }

  @override
  Future<bool> addMenu(
      {required String menuName,
      required List<String> mealNames,
      required DateTime date}) async {
    final resMenu = await Supabase.instance.client.from('menu').insert([
      {'name': menuName, 'date': DateFormat.yMd().format(date)}
    ]).execute();

    if (resMenu.hasError) {
      return false;
    } else {
      final menuId = resMenu.data!.first['id'] as int;

      final resMeal = await Supabase.instance.client
          .from('meal')
          .insert(mealNames
              .map((eachMealName) => {'name': eachMealName, 'menuId': menuId})
              .toList())
          .execute();

      if (resMeal.hasError) {
        return false;
      } else {
        return true;
      }
    }
  }

  @override
  Future<bool> deleteMenu({required int menuId}) async {
    final resMeals = await Supabase.instance.client
        .from('meal')
        .delete()
        .eq('menuId', menuId)
        .execute();
    if (resMeals.hasError) {
      return false;
    } else {
      final resMenu = await Supabase.instance.client
          .from('menu')
          .delete()
          .match({'id': menuId}).execute();

      if (resMenu.hasError) {
        return false;
      } else {
        return true;
      }
    }
  }
}
