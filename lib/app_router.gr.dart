// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    EmptyRouterRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const EmptyRouterPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    RegisterRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    AdminRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const AdminPage(),
      );
    },
    DashboardRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const DashboardPage(),
      );
    },
    FutureRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const CalendarPage(),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          EmptyRouterRoute.name,
          path: '/',
          children: [
            RouteConfig(
              '#redirect',
              path: '',
              parent: EmptyRouterRoute.name,
              redirectTo: 'splash',
              fullMatch: true,
            ),
            RouteConfig(
              SplashRoute.name,
              path: 'splash',
              parent: EmptyRouterRoute.name,
            ),
            RouteConfig(
              LoginRoute.name,
              path: 'login',
              parent: EmptyRouterRoute.name,
            ),
            RouteConfig(
              RegisterRoute.name,
              path: 'register',
              parent: EmptyRouterRoute.name,
            ),
            RouteConfig(
              HomeRoute.name,
              path: 'home',
              parent: EmptyRouterRoute.name,
              children: [
                RouteConfig(
                  AdminRouter.name,
                  path: 'admin',
                  parent: HomeRoute.name,
                ),
                RouteConfig(
                  DashboardRouter.name,
                  path: 'dashboard',
                  parent: HomeRoute.name,
                ),
                RouteConfig(
                  FutureRouter.name,
                  path: 'future',
                  parent: HomeRoute.name,
                ),
              ],
            ),
          ],
        )
      ];
}

/// generated route for
/// [EmptyRouterPage]
class EmptyRouterRoute extends PageRouteInfo<void> {
  const EmptyRouterRoute({List<PageRouteInfo>? children})
      : super(
          EmptyRouterRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'EmptyRouterRoute';
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: 'splash',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: 'login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute()
      : super(
          RegisterRoute.name,
          path: 'register',
        );

  static const String name = 'RegisterRoute';
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          path: 'home',
          initialChildren: children,
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [AdminPage]
class AdminRouter extends PageRouteInfo<void> {
  const AdminRouter()
      : super(
          AdminRouter.name,
          path: 'admin',
        );

  static const String name = 'AdminRouter';
}

/// generated route for
/// [DashboardPage]
class DashboardRouter extends PageRouteInfo<void> {
  const DashboardRouter()
      : super(
          DashboardRouter.name,
          path: 'dashboard',
        );

  static const String name = 'DashboardRouter';
}

/// generated route for
/// [CalendarPage]
class FutureRouter extends PageRouteInfo<void> {
  const FutureRouter()
      : super(
          FutureRouter.name,
          path: 'future',
        );

  static const String name = 'FutureRouter';
}
