import 'package:flutter/material.dart';
import 'package:sairam_incubation/Auth/Model/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = "Please Wait a moment...",
  });
}

class AuthInitialiseState extends AuthState {
  const AuthInitialiseState({required super.isLoading});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

class LoggedInState extends AuthState {
  final AuthUser user;
  const LoggedInState({required this.user, required super.isLoading});
}

class RegisteringState extends AuthState {
  final Exception? exception;
  const RegisteringState({required this.exception, required super.isLoading});
}

class LoggedOutState extends AuthState {
  final Exception? exception;

  const LoggedOutState({required this.exception, required super.isLoading});

  @override
  String toString() {
    return """LoggedOutState :
    Exception : ${exception.toString()}
    isLoading : $isLoading
    """;
  }
}

class ForgotPasswordState extends AuthState {
  const ForgotPasswordState({required super.isLoading});
}

class RequiresEmailVerifiactionState extends AuthState {
  const RequiresEmailVerifiactionState({required super.isLoading});
}
