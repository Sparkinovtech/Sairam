import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';
import 'package:sairam_incubation/Auth/forget_page.dart';
import 'package:sairam_incubation/Auth/reset_page.dart';
import 'package:sairam_incubation/Utils/images.dart';
class OtpVerifyPage extends StatefulWidget {
  const OtpVerifyPage({super.key});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

final defaultPinTheme = PinTheme(
    width: 54,
    height: 54,
    textStyle: TextStyle(color: Color.fromRGBO(30, 60, 87, 1) , fontSize: 20 , fontWeight: FontWeight.w500),
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(.3),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
    )
);
final focusPinTheme = defaultPinTheme.copyDecorationWith(
  color: Colors.grey.withOpacity(.4),
    border: Border.all(color: Color.fromRGBO(114, 178, 238,1)),
  borderRadius: BorderRadius.circular(20),
);
final submittedPinTheme = defaultPinTheme.copyWith(
  decoration: defaultPinTheme.decoration?.copyWith(
    color: Color.fromRGBO(234, 239, 243, 1)
  ),
);
class _OtpVerifyPageState extends State<OtpVerifyPage> {

  late Timer _timer;
  int _remainingSeconds = 60;
  bool _canSend = false;
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _startCountdown();
  }
  void _startCountdown(){
    _canSend =false;
    _remainingSeconds = 60;
    _timer = Timer.periodic(Duration(seconds: 1 ), (timer){
      if(_remainingSeconds == 0){
        setState(() {
          _canSend = true;
        });
        _timer.cancel();
      }
      else{
        setState(() {
          _remainingSeconds--;
        });
      }

    });
  }
  String _formatTimer(int seconds){
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
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
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top:size.height * .03,
            left: 15,
            child: IconButton( onPressed: (){
              Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade , child: ForgetPage()));

            } ,icon: Icon( Icons.arrow_back_ios)),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30 , vertical: 70),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Verify your email address",style: GoogleFonts.inter(fontWeight: FontWeight.w500 , fontSize: 25),),
                    ],
                  ),
                  SizedBox(height: size.height * .03,),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.start ,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "We send you a 4 digit code to verify your email \n address ",style: TextStyle(color: Colors.black)),
                            TextSpan(text: "(example@sairamtap.edu.in). ",style: GoogleFonts.inter(color: Colors.grey,fontWeight: FontWeight.bold)),
                            TextSpan(text: "Enter \n the  in the field below",style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * .02,),
                  Form(
                    key: _key,
                    child: Pinput(
                      controller: _otpController,
                      validator: (v) => v == null || v.isEmpty ? "Enter the OTP Number" : "",
                      autofocus: false,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      showCursor: true,
                    ),
                  ),
                  SizedBox(height: size.height * .05,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "Didn't get the code ?",style: GoogleFonts.inter(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      SizedBox(width: size.width * .03,),
                      InkWell(
                        onTap: _canSend ? (){
                          setState(() {
                            _canSend = false;

                          });
                          _startCountdown();
                        } : null,
                        child: Text("Resend",style: GoogleFonts.inter(fontSize: 14,color: _canSend ? Colors.black :  Colors.grey,fontWeight: FontWeight.w800),),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height* .02,),
                  Center(
                    child: Text("Expires  in ${_formatTimer(_remainingSeconds)}",style:
                    GoogleFonts.inter(fontSize: 14,color: _remainingSeconds <= 10 ? Colors.red : Colors.black ,fontWeight:FontWeight.w500),),
                  ),
                  SizedBox(height: size.height * .03,),
                  MaterialButton(
                    onPressed: (){
                      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade , child: ResetPage()));
                    },
                    color: Colors.blue,
                    minWidth: size.width * .65,
                    height: size.height * .05,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text("Submit",style: GoogleFonts.inter(fontSize: 16,fontWeight: FontWeight.w700 , color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
