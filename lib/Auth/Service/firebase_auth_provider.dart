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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailId,
        password: password,
      );
      final user = this.user;
      if (user == null) {
        throw UserNotLoggedInException();
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw UserNotFoundAuthException();
      } else if (e.code == "invalid-credential") {
        throw WrongPasswordAuthException();
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
  Future<void> logout() async {
    final user = _getCurrentUser();
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  Future<void> resetPassword() async {
    final user = _getCurrentUser();
    if (user == null) {
      return;
    }
    String? email = user.email;
    if (email == null) {
      return;
    }
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
      await user.sendEmailVerification();
    }
  }

  User? _getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
