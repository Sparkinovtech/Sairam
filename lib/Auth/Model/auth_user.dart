import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final bool isEmailVerified;
  final String email;
  final String userId;
  AuthUser({
    required this.email,
    required this.userId,
    required this.isEmailVerified,
  });
  factory AuthUser.fromFirebase(User user) {
    return AuthUser(
      email: user.email!,
      userId: user.uid,
      isEmailVerified: user.emailVerified,
    );
  }
}
