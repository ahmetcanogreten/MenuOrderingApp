import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:flutter/material.dart';
import 'package:meal_ordering_app/features/admin/presentation/pages/admin_page.dart';
import 'package:meal_ordering_app/features/authentication/presentation/pages/register_page.dart';
import 'package:meal_ordering_app/features/authentication/presentation/pages/splash_page.dart';
import 'package:meal_ordering_app/features/menu/presentation/pages/home_page.dart';
import 'package:meal_ordering_app/features/menu/presentation/pages/calendar_page.dart';
import 'package:meal_ordering_app/features/menu/presentation/widgets/dashboard_page.dart';
import 'package:meal_ordering_app/features/menu/presentation/widgets/statistics_page.dart';

import 'features/authentication/presentation/pages/login_page.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      page: EmptyRouterPage,
      children: [
        AutoRoute(path: 'splash', page: SplashPage, initial: true),
        AutoRoute(path: 'login', page: LoginPage),
        AutoRoute(path: 'register', page: RegisterPage),
        AutoRoute(path: 'home', page: HomePage, children: [
          AutoRoute(path: 'admin', name: 'AdminRouter', page: AdminPage),
          // AutoRoute(
          //     path: 'statistics',
          //     name: 'StatisticsRouter',
          //     page: StatisticsPage),
          AutoRoute(
              path: 'dashboard', name: 'DashboardRouter', page: DashboardPage),
          AutoRoute(path: 'future', name: 'FutureRouter', page: CalendarPage),
        ]),
      ],
    ),
  ],
)
class AppRouter extends _$AppRouter {}
