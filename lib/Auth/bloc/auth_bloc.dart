import 'dart:developer' as devtools;

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sairam_incubation/Auth/Service/authentication_provider.dart';
import 'package:sairam_incubation/Auth/bloc/auth_event.dart';
import 'package:sairam_incubation/Auth/bloc/auth_state.dart';
import 'package:sairam_incubation/Profile/service/profile_cloud_firestore_provider.dart';
import 'package:sairam_incubation/Utils/exceptions/auth_exceptions.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    AuthenticationProvider provider,
    ProfileCloudFirestoreProvider cloudProvider,
  ) : super(const AuthStateUninitialized(isLoading: false)) {
    // Initialise the Firebase app
    on<AuthInitialiseEvent>((event, emit) async {
      await provider.initialise();
      final user = provider.user;
      if (user == null) {
        emit(const LoggedOutState(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const RequiresEmailVerifiactionState(isLoading: false));
      } else {
        emit(LoggedInState(user: user, isLoading: false));
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
        emit(RequiresEmailVerifiactionState(isLoading: false));
      }
    });

    // Sending mail for resetting password
    on<AuthForgotPasswordEvent>((event, emit) async {
      try {
        await provider.resetPassword(email: event.email);
        emit(LoggedOutState(exception: null, isLoading: false));
      } on FirebaseAuthException catch (e) {
        devtools.log("From the Auth Bloc : ${e.code}");
        emit(ForgotPasswordState(isLoading: false));
      }
    });
    // for going to the foget password view page
    on<AuthHasForgotPassworEvent>((event, emit) {
      devtools.log("Is Entering the Forgot page");
      emit(ForgotPasswordState(isLoading: false));
    });

    // Logging in the user
    on<AuthUserLogInEvent>((event, emit) async {
      final String email = event.email;
      final String password = event.password;

      try {
        emit(LoggedOutState(exception: null, isLoading: true));
        final user = await provider.login(emailId: email, password: password);
        if (user.isEmailVerified) {
          emit(LoggedOutState(exception: null, isLoading: false));
          emit(LoggedInState(user: user, isLoading: false));
        } else {
          emit(const LoggedOutState(exception: null, isLoading: false));
          emit(RequiresEmailVerifiactionState(isLoading: false));
        }
      } on Exception catch (e) {
        emit(LoggedOutState(exception: e, isLoading: false));
      }
    });

    // Logging out the user
    on<AuthUserLogOutEvent>((event, emit) async {
      try {
        await provider.logout();
        emit(LoggedOutState(exception: null, isLoading: false));
      } on GenericAuthException catch (e) {
        devtools.log("From the Auth Bloc : ${e.toString()}");
        emit(LoggedOutState(exception: e, isLoading: false));
      }
    });

    // Registering new user
    on<AuthUserRegisterEvent>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        emit(RegisteringState(exception: null, isLoading: true));
        final user = await provider.signup(emailId: email, password: password);
        await cloudProvider.createNewProfile(user: user);
        provider.sendEmailVerification();
        emit(RequiresEmailVerifiactionState(isLoading: false));
      } on FirebaseAuthException catch (e) {
        devtools.log("From the Auth Bloc : ${e.code}");
        emit(RegisteringState(exception: e, isLoading: false));
      }
    });

    on<AuthUserShouldRegisterEvent>((event, emit) async {
      emit(RegisteringState(exception: null, isLoading: false));
    });
  }
}
