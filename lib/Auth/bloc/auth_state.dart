import 'package:flutter/material.dart';
import 'package:sairam_incubation/Auth/Model/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthInitialiseState extends AuthState {
  const AuthInitialiseState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class LoggedInState extends AuthState {
  final AuthUser user;
  const LoggedInState(this.user);
}

class RegisteringState extends AuthState {
  final Exception? exception;
  const RegisteringState(this.exception);
}

class LoggedOutState extends AuthState {
  final Exception? exception;
  final bool isLoading;
  const LoggedOutState(this.exception, this.isLoading);

  @override
  String toString() {
    return """LoggedOutState :
    Exception : ${exception.toString()}
    isLoading : $isLoading
    """;
  }
}

class ForgotPasswordState extends AuthState {
  const ForgotPasswordState();
}

class RequiresEmailVerifiactionState extends AuthState {
  const RequiresEmailVerifiactionState();
}
