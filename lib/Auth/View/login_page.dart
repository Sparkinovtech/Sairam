import 'dart:developer' as devtools;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sairam_incubation/Auth/bloc/auth_bloc.dart';
import 'package:sairam_incubation/Auth/bloc/auth_state.dart';
import 'package:sairam_incubation/Utils/dialogs/error_dialog.dart';
import 'package:sairam_incubation/Utils/dialogs/loading_overlay.dart';
import 'package:sairam_incubation/Utils/exceptions/auth_exceptions.dart';
import 'package:sairam_incubation/Utils/images.dart';

import '../../Utils/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is LoggedOutState) {
          bool isLoading = context.loaderOverlay.visible;
          devtools.log("From the Login Page : ${state.exception.toString()}");
          devtools.log("From the Login Page : $isLoading");

          if (!context.mounted) return;
          if (state.isLoading) {
            devtools.log("From Login page : Loader overlay is initiated");
            context.loaderOverlay.show(
              widgetBuilder: (_) {
                return LoadingOverlay(text: "Connecting...");
              },
            );
          } else if (!state.isLoading) {
            devtools.log("From Login page : Loader overlay is closed");
            context.loaderOverlay.hide();
          }

          // Show error if any
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, "User Not Found");
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, "Wrong credentials");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Authentication error");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Invalid email entered");
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: Image.asset(background, fit: BoxFit.cover)),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: .8),
                    Colors.white.withValues(alpha: .9),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.height * .04),
                  Center(child: Image.asset(mainlogo)),
                  SizedBox(height: size.height * .02),
                  Text(
                    "Welcome Back",
                    style: GoogleFonts.inter(
                      color: Colors.blue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * .02),
                  Text(
                    "Login to continue",
                    style: GoogleFonts.inter(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(child: LoginForm()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
