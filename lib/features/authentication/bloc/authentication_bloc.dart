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
        await Future.wait([
          storage.write(key: 'email', value: email),
          storage.write(key: 'password', value: password),
        ]);
        emit(LoggedIn(user: user, role: role));
      } else {
        emit(LoggingInFailed());
      }
    });

    on<AutoLogin>((event, emit) async {
      final emailAndPasswordList = await Future.wait([
        storage.read(key: 'email'),
        storage.read(key: 'password'),
      ]);

      if (emailAndPasswordList.any((element) => element == null)) {
        emit(NotLoggedIn());
      } else {
        final email = emailAndPasswordList[0]!;
        final password = emailAndPasswordList[1]!;

        final user = await _authenticationRepository.signIn(
            email: email, password: password);

        if (user != null) {
          final role =
              await _authenticationRepository.getUserRole(userId: user.id);
          emit(LoggedIn(user: user, role: role)); // TODO :
        } else {
          await Future.wait([
            storage.delete(key: 'email'),
            storage.delete(key: 'password'),
          ]);
          emit(NotLoggedIn());
        }
      }
    });
  }
}
