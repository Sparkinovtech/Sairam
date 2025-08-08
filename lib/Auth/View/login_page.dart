import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sairam_incubation/Auth/bloc/auth_bloc.dart';
import 'package:sairam_incubation/Auth/bloc/auth_state.dart';
import 'package:sairam_incubation/Utils/dialogs/error_dialog.dart';
import 'package:sairam_incubation/Utils/exceptions/auth_exceptions.dart';

import 'login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is LoggedOutState) {
          // Show error if any
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, "User Not Found", "");
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
              context,
              "Wrong credentials",
              "Please Enter the valid Password",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Authentication error", "");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Invalid email entered", "");
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
                  padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Login", style: GoogleFonts.inconsolata(fontSize: 45, color: Colors.white)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Welcome Back", style: GoogleFonts.inconsolata(fontSize: 35, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                    ),
                    padding: EdgeInsets.only(top: 40, left: 20 , right: 20 , bottom: 20),
                    child: SingleChildScrollView(
                      child: LoginForm(),
                    ),
                  ) ,
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
