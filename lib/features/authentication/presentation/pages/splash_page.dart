import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:meal_ordering_app/router/app_router.dart';

import 'package:meal_ordering_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        // print(Supabase.instance.client.auth.recoverSession(jsonStr))
        if (state is LoggedIn) {
          context.router.replace(const HomeRoute());
        } else if (state is NotLoggedIn) {
          context.router.replace(const RegisterRoute());
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
