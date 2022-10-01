import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meal_ordering_app/features/authentication/repositories/authentication_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final IAuthenticationRepository _authenticationRepository;
  final storage = const FlutterSecureStorage();

  AuthenticationBloc(
      {required IAuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(AuthenticationInitial()) {
    on<Register>((event, emit) async {
      emit(WaitLoggingIn());

      final email = event.email;
      final password = event.password;

      final user = await _authenticationRepository.signUp(
          email: email, password: password);

      if (user != null) {
        final role =
            await _authenticationRepository.getUserRole(userId: user.id);

        await storage.write(
          key: 'token',
          value: Supabase.instance.client.auth.currentSession
              ?.refreshToken, // TODO : Remove Supabase
        );

        emit(LoggedIn(user: user, role: role));
      } else {
        emit(LoggingInFailed());
      }
    });

    on<Login>((event, emit) async {
      emit(WaitLoggingIn());

      final email = event.email;
      final password = event.password;

      final user = await _authenticationRepository.signIn(
          email: email, password: password);

      if (user != null) {
        final role =
            await _authenticationRepository.getUserRole(userId: user.id);

        await storage.write(
          key: 'token',
          value: Supabase.instance.client.auth.currentSession
              ?.refreshToken, // TODO : Remove Supabase
        );

        emit(LoggedIn(user: user, role: role));
      } else {
        emit(LoggingInFailed());
      }
    });

    on<AutoLogin>((event, emit) async {
      final token = await storage.read(key: 'token');

      if (token == null) {
        emit(NotLoggedIn());
      } else {
        final session = await Supabase.instance.client.auth
            .setSession(token); // TODO : Remove Supabase
        if (session.error != null) {
          await storage.delete(key: 'token');
          emit(NotLoggedIn());
        }

        await storage.write(key: 'token', value: session.data?.refreshToken);

        final user = session.user!;
        final role =
            await _authenticationRepository.getUserRole(userId: user.id);
        emit(LoggedIn(user: user, role: role)); // TODO :
      }
    });
  }
}
