import 'dart:developer' as devTools;

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sairam_incubation/Auth/Service/authentication_provider.dart';
import 'package:sairam_incubation/Auth/bloc/auth_event.dart';
import 'package:sairam_incubation/Auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthenticationProvider provider)
    : super(const AuthStateUninitialized()) {
    /// Sending verification email to user if needed
    on<AuthSendEmailVerificationEvent>((event, emit) async {
      try {
        await provider.sendEmailVerification();
        emit(state);
      } on FirebaseAuthException catch (e) {
        devTools.log(e.code);
      }
    });

    // Sending mail for resetting password
    on<AuthForgotPasswordEvent>((event, emit) async {
      try {
        await provider.resetPassword();
        emit(LoggedOutState());
      } on FirebaseAuthException catch (e) {
        devTools.log(e.code);
      }
    });
  }
}
