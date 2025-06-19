import 'package:sairam_incubation/Auth/Model/auth_user.dart';

/// This is a contract class for all authentication backend,
/// can be used  to implement any authentication framework like
/// firebase, supabase etc.
abstract class AuthenticationProvider {
  /// Getting the current user directly rather than mentioning it using functions
  AuthUser? get user;

  /// Initialise any kind of backend for
  /// the authentication using this method
  Future<void> initialise();

  /// Classic User name and password sign in method,
  /// can include future method in the near future
  Future<AuthUser> signup({required String emailId, required String password});

  /// Similar to sign up
  Future<AuthUser> login({required String emailId, required String password});

  /// Execute this as per the user needs, make sure to have a
  /// alert to ask if the user is sure to logout
  Future<void> logout();

  /// check if email is verified to make sure
  /// the user is actually in control of the account
  /// , make sure to check for each time launching the app
  Future<bool> isEmailVerified();

  Future<void> sendEmailVerification();

  /// in case the user forgets the password, user this method
  Future<void> resetPassword();
}
