part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class NotLoggedIn extends AuthenticationState {}

class WaitLoggingIn extends AuthenticationState {}

class LoggedIn extends AuthenticationState {
  final User user;
  final String role;

  const LoggedIn({required this.user, required this.role});

  @override
  List<Object> get props => [user, role];
}

class LoggingInFailed extends AuthenticationState {}
