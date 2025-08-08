import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/View/bottom_nav_bar.dart';

class Success {
  static void showSuccessDialog(BuildContext context) {
    var size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.grey.withValues(alpha: .5),
      builder: (context) {
        Timer(Duration(seconds: 5), () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            PageTransition(
              type: PageTransitionType.fade,
              child: BottomNavBar(),
            ),
          );
        });
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 1, sigmaX: 1),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: AnimatedContainer(
                width: size.width * .3,
                height: size.height * .3,
                duration: Duration(seconds: 1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Lottie.asset(
                        "assets/Success.json",
                        width: size.width * .35,
                        height: size.height * .2,
                        repeat: true,
                      ),
                      SizedBox(height: size.height * .01),
                      Text(
                        "Request Send Successfully!",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
