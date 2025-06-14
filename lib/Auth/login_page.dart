import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sairam_incubation/Utils/images.dart';

import '../Utils/login_form.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(background,fit: BoxFit.cover,),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:[
                  Colors.white.withOpacity(.8),
                  Colors.white.withOpacity(.9)
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.height * .04,),
                Center(
                  child: Image.asset(mainlogo),
                ),
                SizedBox(height: size.height * .02,),
                Text("Welcome Back",style: GoogleFonts.inter(color: Colors.blue,fontSize: 24,fontWeight: FontWeight.bold),),
                SizedBox(height: size.height * .02,),
                Text("Login to continue",style: GoogleFonts.inter(color: Colors.blue,fontSize: 16,fontWeight: FontWeight.w500),),
              ],
            ),
          ),
          Positioned.fill(
            top: size.height * .33,
            child:LoginForm(),
          ),
        ],
      ),
    );
  }
}
