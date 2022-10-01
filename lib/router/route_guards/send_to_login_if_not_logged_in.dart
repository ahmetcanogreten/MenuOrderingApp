import 'package:auto_route/auto_route.dart';
import 'package:meal_ordering_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:meal_ordering_app/router/app_router.dart';

class SendToLoginIfNotLoggedIn extends AutoRouteGuard {
  final AuthenticationBloc authenticationBloc;

  SendToLoginIfNotLoggedIn({required this.authenticationBloc});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (authenticationBloc.state is LoggedIn) {
      resolver.next(true);
    } else {
      router.pushAndPopUntil(const LoginRoute(), predicate: (_) => false);
      resolver.next(false);
    }
  }
}
