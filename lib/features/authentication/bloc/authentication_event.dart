part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class Register extends AuthenticationEvent {
  final String email;
  final String password;

  const Register({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AutoLogin extends AuthenticationEvent {}
