import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Auth/View/forget_page.dart';
import 'package:sairam_incubation/Auth/View/login_page.dart';
import 'package:sairam_incubation/Auth/View/signup_page.dart';
import 'package:sairam_incubation/Auth/bloc/auth_bloc.dart';
import 'package:sairam_incubation/Auth/bloc/auth_event.dart';
import 'package:sairam_incubation/Auth/bloc/auth_state.dart';
import 'package:sairam_incubation/Utils/images.dart';
import 'package:sairam_incubation/View/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: Duration(seconds: 1),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is LoggedInState) {
                return HomePage();
              } else if (state is LoggedOutState) {
                return LoginPage();
              } else if (state is ForgotPasswordState) {
                return ForgetPage();
              } else if (state is RequiresEmailVerifiactionState) {
                // TODO return an email verification page that needs to be built
              } else if (state is RegisteringState) {
                return SignupPage();
              }
              return Scaffold(body: CircularProgressIndicator());
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(background),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withValues(alpha: .3),
                  Colors.white.withValues(alpha: .8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.center,
              ),
            ),
          ),
          FadeTransition(
            opacity: _animation,
            child: Center(child: Image.asset(logo, scale: 1.2)),
          ),
        ],
      ),
    );
  }
}
