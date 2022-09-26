import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_ordering_app/app_router.dart';
import 'package:meal_ordering_app/features/authentication/bloc/authentication_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return AutoTabsScaffold(
          homeIndex: ((state as LoggedIn).role == 'admin') ? 2 : 1,
          routes: [
            if ((state as LoggedIn).role == 'admin') const AdminRouter(),
            // const StatisticsRouter(),
            const DashboardRouter(),
            const FutureRouter()
          ],
          bottomNavigationBuilder: (context, tabsRouter) => BottomNavigationBar(
              currentIndex: tabsRouter.activeIndex,
              onTap: tabsRouter.setActiveIndex,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              items: [
                if ((state as LoggedIn).role == 'admin')
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.settings),
                      label: tr('lbl_admin_page')),
                // BottomNavigationBarItem(
                //     icon: const Icon(Icons.query_stats),
                //     label: tr('lbl_statistics_page')),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.restaurant),
                    label: tr('lbl_dashboard_page')),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.calendar_month),
                    label: tr('lbl_calender_page'))
              ]),
        );
      },
    );
  }
}
