import 'dart:developer' as devtools;

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sairam_incubation/Auth/Service/authentication_provider.dart';
import 'package:sairam_incubation/Auth/bloc/auth_event.dart';
import 'package:sairam_incubation/Auth/bloc/auth_state.dart';
import 'package:sairam_incubation/Utils/exceptions/auth_exceptions.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthenticationProvider provider)
    : super(const AuthStateUninitialized()) {
    // Initialise the Firebase app
    on<AuthInitialiseEvent>((event, emit) async {
      await provider.initialise();
      final user = provider.user;
      if (user == null) {
        emit(const LoggedOutState(null, false));
      } else if (!user.isEmailVerified) {
        emit(const RequiresEmailVerifiactionState());
      } else {
        emit(LoggedInState(user));
      }
    });

    /// Sending verification email to user if needed
    on<AuthSendEmailVerificationEvent>((event, emit) async {
      try {
        devtools.log("Email verification sent");
        await provider.sendEmailVerification();
        emit(state);
      } on FirebaseAuthException catch (e) {
        devtools.log("From the Auth Bloc : ${e.code}");
        emit(RequiresEmailVerifiactionState());
      }
    });

    // Sending mail for resetting password
    on<AuthForgotPasswordEvent>((event, emit) async {
      try {
        await provider.resetPassword(email: event.email);
        emit(LoggedOutState(null, false));
      } on FirebaseAuthException catch (e) {
        devtools.log("From the Auth Bloc : ${e.code}");
        emit(ForgotPasswordState());
      }
    });
    // for going to the foget password view page
    on<AuthHasForgotPassworEvent>((event, emit) {
      devtools.log("Is Entering the Forgot page");
      emit(ForgotPasswordState());
    });

    // Logging in the user
    on<AuthUserLogInEvent>((event, emit) async {
      final String email = event.email;
      final String password = event.password;

      try {
        emit(LoggedOutState(null, true));
        await Future.delayed(Duration(seconds: 5));
        final user = await provider.login(emailId: email, password: password);
        if (user.isEmailVerified) {
          emit(LoggedOutState(null, false));
          emit(LoggedInState(user));
        } else {
          emit(const LoggedOutState(null, false));
          emit(RequiresEmailVerifiactionState());
        }
      } on Exception catch (e) {
        emit(LoggedOutState(e, false));
      }
    });

    // Logging out the user
    on<AuthUserLogOutEvent>((event, emit) async {
      try {
        await provider.logout();
        emit(LoggedOutState(null, false));
      } on GenericAuthException catch (e) {
        devtools.log("From the Auth Bloc : ${e.toString()}");
        emit(LoggedOutState(e, false));
      }
    });

    // Registering new user
    on<AuthUserRegisterEvent>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.signup(emailId: email, password: password);
        provider.sendEmailVerification();
        emit(RequiresEmailVerifiactionState());
      } on FirebaseAuthException catch (e) {
        devtools.log("From the Auth Bloc : ${e.code}");
        emit(RegisteringState(e));
      }
    });

    on<AuthUserShouldRegisterEvent>((event, emit) {
      emit(RegisteringState(null));
    });
  }
}
