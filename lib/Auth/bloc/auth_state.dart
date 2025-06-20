import 'package:flutter/material.dart';
import 'package:sairam_incubation/Auth/Model/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class LoggedInState extends AuthState {
  final AuthUser user;
  const LoggedInState(this.user);
}

class RegisteringState extends AuthState {
  final Exception? e;
  const RegisteringState(this.e);
}

class LoggedOutState extends AuthState {
  const LoggedOutState();
}

class ForgotPasswordState extends AuthState {
  const ForgotPasswordState();
}

class RequiresEmailVerifiactionState extends AuthState {
  const RequiresEmailVerifiactionState();
}

class LoadingState extends AuthState {
  const LoadingState();
}
