import 'dart:developer' as devtools;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sairam_incubation/Auth/bloc/auth_bloc.dart';
import 'package:sairam_incubation/Auth/bloc/auth_state.dart';
import 'package:sairam_incubation/Utils/dialogs/error_dialog.dart';
import 'package:sairam_incubation/Utils/exceptions/auth_exceptions.dart';
import 'package:sairam_incubation/Utils/images.dart';

import '../../Utils/signup_form.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is RegisteringState) {
          devtools.log("coming here because of the error");
          if (!context.mounted) return;
          devtools.log("has passed the above if statement");

          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, "Weak Password");
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, "Email Already in use");
          } else if (state.exception is GenericAuthException) {
            devtools.log("i am in generic auth exception");
            await showErrorDialog(context, "Failed to register");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Invalid email");
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
                    Colors.white.withValues(alpha: .9),
                    Colors.white.withValues(alpha: .8),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.height * .03),
                  Center(child: Image.asset(mainlogo)),
                  SizedBox(height: size.height * .02),
                  Text(
                    "Create An Account",
                    style: GoogleFonts.inter(
                      color: Colors.blue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(top: size.height * .25, child: SignUpForm()),
          ],
        ),
      ),
    );
  }
}
