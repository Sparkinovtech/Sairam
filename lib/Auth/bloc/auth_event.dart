import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthUserRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  const AuthUserRegisterEvent({required this.email, required this.password});
}

class AuthUserLogInEvent extends AuthEvent {
  final String email;
  final String password;
  const AuthUserLogInEvent({required this.email, required this.password});
}

class AuthSendEmailVerificationEvent extends AuthEvent {
  const AuthSendEmailVerificationEvent();
}

class AuthForgotPasswordEvent extends AuthEvent {
  final String email;
  const AuthForgotPasswordEvent({required this.email});
}

class AuthHasForgotPasswordEvent extends AuthEvent {
  const AuthHasForgotPasswordEvent();
}

class AuthUserLogOutEvent extends AuthEvent {
  const AuthUserLogOutEvent();
}

class AuthUserShouldRegisterEvent extends AuthEvent {
  const AuthUserShouldRegisterEvent();
}
