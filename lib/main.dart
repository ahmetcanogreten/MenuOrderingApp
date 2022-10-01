import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_ordering_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:meal_ordering_app/features/authentication/repositories/authentication_repository.dart';
import 'package:meal_ordering_app/features/menu/bloc/menu_bloc.dart';
import 'package:meal_ordering_app/features/menu/bloc/orders_bloc.dart';
import 'package:meal_ordering_app/features/menu/repositories/menu_repository.dart';
import 'package:meal_ordering_app/features/menu/repositories/order_repository.dart';
import 'package:meal_ordering_app/router/route_guards/send_to_login_if_not_logged_in.dart';
import 'package:meal_ordering_app/theme.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:meal_ordering_app/router/app_router.dart';

const String kSupabaseUrl = 'https://uexepghfmujmghjizwid.supabase.co';
const String kSupabaseToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVleGVwZ2hmbXVqbWdoaml6d2lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjM5MDk2OTQsImV4cCI6MTk3OTQ4NTY5NH0.d67vUakQaVc395H0v4GH2OwfF0MMAcIgPicUwLKGqCM';

Future<void> main() async {
  await Supabase.initialize(url: kSupabaseUrl, anonKey: kSupabaseToken);
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('tr')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en', 'US'),
    useOnlyLangCode: true,
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppRouter
      _appRouter; // = AppRouter(checkIfLoggedIn: CheckIfLoggedIn());
  final _authenticationBloc =
      AuthenticationBloc(authenticationRepository: AuthenticationRepository())
        ..add(AutoLogin());

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(
        checkIfLoggedIn:
            SendToLoginIfNotLoggedIn(authenticationBloc: _authenticationBloc));
  }

  @override
  void dispose() {
    _authenticationBloc.close(); // TODO : Should I wait ?
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _authenticationBloc),
            BlocProvider(
                create: (context) =>
                    MenuBloc(menuRepository: MenuRepository())),
            BlocProvider(
                create: (context) =>
                    OrdersBloc(orderRepository: OrderRepository())),
          ],
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              color: Colors.black,
              child: Center(
                child: SizedBox(
                  width:
                      constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
                  height: constraints.maxHeight > 1200
                      ? 1200
                      : constraints.maxHeight,
                  child: MaterialApp.router(
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    routerDelegate: _appRouter.delegate(),
                    routeInformationParser: _appRouter.defaultRouteParser(),
                    title: 'Flutter Demo',
                    theme: appLightTheme,
                    debugShowCheckedModeBanner: false,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
