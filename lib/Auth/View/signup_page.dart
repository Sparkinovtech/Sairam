import 'dart:developer' as devtools;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sairam_incubation/Auth/bloc/auth_bloc.dart';
import 'package:sairam_incubation/Auth/bloc/auth_state.dart';
import 'package:sairam_incubation/Utils/dialogs/error_dialog.dart';
import 'package:sairam_incubation/Utils/exceptions/auth_exceptions.dart';
import 'package:sairam_incubation/Utils/signup_form.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is RegisteringState) {
          if (!context.mounted) return;
          devtools.log("From Register Page : ${state.exception}");
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, "Weak Password", "");
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, "Email Already in use", "");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Failed to register", "");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Invalid email", "");
          } else if (state.exception is InvalidEmailFormatException) {
            await showErrorDialog(
              context,
              "Only SEC / SIT account registration allowed",
              "",
            );
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueGrey[800]!,
                Colors.blueGrey[600]!,
                Colors.blueGrey[400]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Text("Signup", style: GoogleFonts.inconsolata(fontSize: 45, color: Colors.white)),
                    ],
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(50),
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 30,
                            bottom: keyboardHeight > 0 ? keyboardHeight : 16,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: SignUpForm(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
