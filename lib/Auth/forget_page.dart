import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Auth/login_page.dart';
import 'package:sairam_incubation/Auth/otp_verify_page.dart';
import 'package:sairam_incubation/Utils/images.dart';
class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  final TextEditingController _email  = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
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
                colors: [
                  Colors.white.withOpacity(.8),
                  Colors.white.withOpacity(.9),
                ]
              ),
            ),
          ),
          Positioned(
            top: size.height * .05,
            left: 6,
            child: IconButton(onPressed: (){
              Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade , child: LoginPage()));
            }, icon: Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,)),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * .09,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Forgot your  Password ?",style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24),),
                        ],
                      ),
                      SizedBox(height: size.height * .01,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Enter your email address and we will share a link to \ncreate a new password ",
                            style: GoogleFonts.poppins(color: Colors.black,fontSize: 13),),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * .05,),
                Form(
                  key: _key,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      validator: (v) => v == null || v.isEmpty ? "Enter the email Address" : !v.contains("@") ? "Invalid Email Address" : null,
                      controller: _email,
                      autofocus: false,
                      cursorColor: Colors.grey,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(.2),
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Enter Email Address",
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w500),
                        prefixIcon: Icon(CupertinoIcons.mail,color: Colors.grey,),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * .06,),
                MaterialButton(
                  onPressed: (){
                    if(_key.currentState!.validate()) {
                      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.bottomToTop, child: OtpVerifyPage()));
                    }
                  },
                  color: Colors.blue,
                  minWidth: size.width * .6,
                  height: size.height * .06,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text("Send",style: GoogleFonts.inter(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
