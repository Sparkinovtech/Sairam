import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
  String subText,
) async {
  var size = MediaQuery.of(context).size;

  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: size.height * 0.7,
              maxWidth: size.width * 0.8,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Error animation
                    SizedBox(
                      height: size.height * 0.2,
                      child: Lottie.asset("assets/error.json", repeat: true),
                    ),
                    const SizedBox(height: 16),

                    // Main text
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtext (wraps for long error messages)
                    Text(
                      subText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // OK Button
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: () => Navigator.pop(context),
                        elevation: 0,
                        color: Colors.red,
                        height: size.height * 0.05,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "OK",
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
