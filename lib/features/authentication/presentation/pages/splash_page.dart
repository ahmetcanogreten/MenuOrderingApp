import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:meal_ordering_app/app_router.dart';

import 'package:meal_ordering_app/features/authentication/bloc/authentication_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is NotLoggedIn) {
          context.router.replace(const RegisterRoute());
        } else if (state is LoggedIn) {
          context.router.replace(const HomeRoute());
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
