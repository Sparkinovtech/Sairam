import 'dart:developer' as devtools;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sairam_incubation/Auth/Model/auth_user.dart';
import 'package:sairam_incubation/Auth/Service/authentication_provider.dart';
import 'package:sairam_incubation/Utils/exceptions/auth_exceptions.dart';
import 'package:sairam_incubation/firebase_options.dart';

class FirebaseAuthProvider implements AuthenticationProvider {
  @override
  Future<void> initialise() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    devtools.log("From firebase provider : Firebase Initialised");
  }

  @override
  Future<bool> isEmailVerified() async {
    final user = _getCurrentUser();
    if (user == null) {
      return false;
    }
    return user.emailVerified;
  }

  @override
  Future<AuthUser> login({
    required String emailId,
    required String password,
  }) async {
    try {
      if (emailId.trim().isEmpty || password.trim().isEmpty) {
        throw InvalidEmailAuthException(); // Or a specific EmptyFieldsException
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailId.trim(),
        password: password.trim(),
      );

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw UserNotLoggedInException();
      }

      return AuthUser.fromFirebase(currentUser);
    } on FirebaseAuthException catch (e) {
      devtools.log("FirebaseAuthException: ${e.code}");

      switch (e.code) {
        case "user-not-found":
          throw UserNotFoundAuthException();
        case "wrong-password":
          throw WrongPasswordAuthException();
        case "invalid-email":
          throw InvalidEmailAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (e) {
      devtools.log("Unknown error: $e");
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    final user = _getCurrentUser();
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Future<AuthUser> signup({
    required String emailId,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailId,
        password: password,
      );
      final user = this.user;
      if (user == null) {
        throw UserNotLoggedInException();
      }
      return user;
    } on FirebaseAuthException catch (e) {
      devtools.log(e.code);
      if (e.code == "email-already-in-use") {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == "weak-password") {
        throw WeakPasswordAuthException();
      } else if (e.code == "invalid-email") {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get user {
    final user = _getCurrentUser();
    if (user == null) {
      return null;
    }
    return AuthUser.fromFirebase(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _getCurrentUser();
    if (user != null) {
      devtools.log(user.toString());
      devtools.log("Sending user email");
      await user.sendEmailVerification();
    } else {
      devtools.log("Some exception occured");
    }
  }

  User? _getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
