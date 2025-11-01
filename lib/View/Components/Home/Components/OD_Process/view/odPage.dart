import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ODpage extends StatefulWidget {
  const ODpage({super.key});

  @override
  State<ODpage> createState() => _ODpageState();
}

class _ODpageState extends State<ODpage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * .05,
            vertical: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Profile Header =====
              Stack(
                children: [
                  // Centered Home text
                  Center(
                    child: Text(
                      "OD Process",
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Right-aligned icons
                ],
              ),
              SizedBox(height: size.height * 0.02),
              SizedBox(
                height: 750,
                child: Center(
                  child: Text(
                    "Comming Soon...",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
