import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
 Future<bool> successDialog(BuildContext context){
   var size = MediaQuery.of(context).size;
   return showDialog(
     context: context,
     barrierDismissible: true,
     builder: (context){
       return Dialog(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(15),
         ),
         child: BackdropFilter(
           filter: ImageFilter.blur(sigmaX: 10 , sigmaY: 10),
           child: AnimatedContainer(
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(15),
             ),
             duration: Duration(seconds: 10),
             child: Center(
               child: Column(
                 children: [
                   Lottie.asset("",repeat: true),
                   Text("Order Send Successfully" ,
                     style: GoogleFonts.lato(color: Colors.black , fontSize: 15,fontWeight: FontWeight.bold),),
                 ],
               ),
             )
           ),
         ),
       );
     }
   ).then((value) => value ?? false);
 }
