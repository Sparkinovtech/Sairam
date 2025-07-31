import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:step_progress/step_progress.dart';
class Tracker {
  static  void showTracker(BuildContext context) {
    var size = MediaQuery.of(context).size;
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.white,

            builder: (context) {
              int currentStep = 0;
              Timer? timer;
              return StatefulBuilder(
                builder: (context , stateMode){
                  timer ??= Timer.periodic(Duration(milliseconds: 800 ), (timer){
                    if(currentStep < 3){
                      currentStep++;
                      stateMode(() => {});
                    }else{
                     timer.cancel();
                    }
                  });
                  final detailWidget = [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(currentStep == 0)
                          Lottie.asset("" , repeat: false),
                        Text("Request Send Successfully",style: GoogleFonts.lato(color: Colors.black,fontSize:17,fontWeight: FontWeight.w800),),
                        // SizedBox(height: size.height * .03,),
                        // Text("Verifying for the components",style: GoogleFonts.lato(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w800),),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(currentStep == 1)
                          Lottie.asset("" , repeat: false),
                          Text("Checking for Details", style: GoogleFonts.lato(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w800),),
                        SizedBox(height: size.height * .02,),
                        Text("Finding the Component", style: GoogleFonts.lato(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w800),),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(currentStep == 2)
                          Lottie.asset("" , repeat: false),
                        Text("Notification Send ", style: GoogleFonts.lato(color: Colors.black, fontSize: 17,fontWeight: FontWeight.w800),),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(currentStep == 3)
                          Lottie.asset("" , repeat: false),
                        Text("Components Delivered" , style: GoogleFonts.lato(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w800),),
                      ],
                    )
                  ];
                  return Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 20 , bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StepProgress(
                          axis: Axis.vertical,
                          width:size.width,
                          height: size.height * .6,
                          currentStep: currentStep,
                          lineTitles: [
                            "Component Requested",
                            "Looking For Component",
                            "Notification Send",
                          ],

                          totalSteps: detailWidget.length,
                        ),
                      ],
                    ),
                  );
                },
              );
            }
        );
    }
}
