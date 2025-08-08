import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class NetworkDialog {

  //Singleton Class for the getting the same instance


  static final NetworkDialog _instance = NetworkDialog._internal();

  //Instance of the method
  factory NetworkDialog() => _instance;

  //Private Constructor
  NetworkDialog._internal();


  bool _isShowing = false;

   Future<void> showNetworkDialog(BuildContext context) async{
    if(_isShowing) return;
    _isShowing = true;
    await showDialog(context: context, barrierDismissible: false ,builder: (dialogContext){
      var size = MediaQuery.of(context).size;
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 0 , sigmaX: 0),
          child: AnimatedContainer(duration: Duration(seconds: 5),curve: Curves.easeInOut,
            width: size.width * .3,
            height: size.height * .34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Lottie.asset("assets/network.json",width: size.width * .3),
                ),
                SizedBox(height: size.height * .02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Network Issue",
                      style: GoogleFonts.inter(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Please connect to wifi or Mobile data"),
                  ],
                ),
                SizedBox(height: size.height * .01,),
                SizedBox(height: size.height * .03,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20 ,vertical: 0),
                  child: MaterialButton(
                    onPressed: (){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.black,
                          content: Text("Waiting for the Network Connection...",
                            style: GoogleFonts.inter(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w800),
                          )));

                    },
                    color: Colors.red,
                    minWidth: size.width * .7,
                    height: size.height * .05,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("OK",style: GoogleFonts.lato(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w800),),
                  ),
                )
              ],
            ),
          ),
        )
      );
    });
    _isShowing = false;
  }
  void hide(BuildContext context) {
    if (_isShowing) {
      Navigator.of(context, rootNavigator: true).pop();
      _isShowing = false;
    }
  }
}
