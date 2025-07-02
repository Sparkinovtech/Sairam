import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog(
    context: context ,
    builder: (context){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child:BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 5 , sigmaX: 5),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30 , vertical: 15),
            width: MediaQuery.of(context).size.width * .1,
            height: MediaQuery.of(context).size.height * .4,
            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [

              ],
            ),
          ),
        )
      );
    }
  ).then((value) => value ?? false);
}
