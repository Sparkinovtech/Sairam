import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
Future<Future> showErrorDialog(BuildContext context , String text) async {
  var size = MediaQuery.of(context).size;
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context){
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1 ,sigmaY: 1),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30 , vertical: 20),
            width: size.width * .3,
            height: size.height * .48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child:  Lottie.asset("assets/error.json",repeat: true),
                ),
                SizedBox(height: size.height * .02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(text , style:
                      GoogleFonts.lato(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                    ],
                  ),
                SizedBox(height: size.height * .027,),

                Center(
                  child: MaterialButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    elevation: 0,
                    color: Colors.red,
                    minWidth:size.width * .6,
                    height: size.height * .05,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text("OK",style: GoogleFonts.lato(color: Colors.white , fontSize: 15,fontWeight: FontWeight.w500),),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  );
}
