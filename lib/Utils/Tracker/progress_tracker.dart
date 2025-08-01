import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile_plus/timeline_tile_plus.dart';
class Tracker {
  static  void showTracker(BuildContext context) {
    var size = MediaQuery.of(context).size;
       showModalBottomSheet(
         backgroundColor: Colors.white,
         isScrollControlled: true,
         context: context,
         builder: (context){
           int currentStep = 0;
           Timer? timer;
           return StatefulBuilder(
             builder: (context , setState){
               timer ??= Timer.periodic(Duration(minutes: 5), (t){
                 if(currentStep < 3){
                   currentStep++;
                 setState(() =>{});
                 }else{
                   t.cancel();
                 }
               });

               final stepTitle = [
                 "Request Send",
                 "Checking Details",
                 "Notification Send",
                 "Components Delivered"
               ];
               final vectorAssets = [
                 "assets/worksheet.png",
                 "assets/find-clipboard.png",
                 "assets/notification.png",
                 "assets/box.png"
               ];
               final stepDescription = [
                 "We have received your request",
                 "We have checking for the details",
                 "Please Check your Notification",
                 "Components has been delivered",
               ];
               return Padding(
                 padding: EdgeInsets.only(left: 16 , right: 16 , top: 40 , bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                 child: SingleChildScrollView(
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       ListView.builder(
                         shrinkWrap: true,
                         itemCount: stepTitle.length,
                         physics: NeverScrollableScrollPhysics(),
                         itemBuilder: (BuildContext context, index){
                           final isCompleted = index < currentStep;
                           final isCurrent = index == currentStep;
                           return SizedBox(
                             height: size.height * .2,
                             child: TimelineTile(
                               alignment: TimelineAlign.manual,
                               lineXY: 0.1,
                               isFirst: index == 0,
                               isLast: index == stepTitle.length - 1,
                               indicatorStyle: IndicatorStyle(
                                 width: 30, height: 30,
                                 color: isCompleted || isCurrent ? Colors.blue :  Colors.grey[300]!,
                                 indicator: Container(
                                   width: size.width * .2,
                                   height: size.height * .2,
                                   decoration: BoxDecoration(
                                     color: isCurrent || isCompleted ? Colors.blue : Colors.grey[300],
                                     shape: BoxShape.circle,
                                   ),
                                   child: Center(
                                     child: Icon(isCurrent || isCompleted ?  Icons.check : Icons.timelapse_sharp , color: isCurrent  || isCompleted? Colors.white : Colors.black,size: 20,),
                                   ),
                                 ),
                               ),
                               beforeLineStyle: LineStyle(
                                 color: index > 0 && (isCurrent || isCompleted) ? Colors.blue : Colors.grey[300]!,
                                 thickness: 10,
                               ),
                               afterLineStyle: LineStyle(
                                 color: isCompleted ? Colors.blue : Colors.grey[300]!,
                                 thickness: 10,
                               ),
                               endChild: Padding(
                                 padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 0),
                                 child: Card(
                                   elevation: 2,
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(15),
                                   ),
                                   child: ClipRRect(
                                     child:Container(
                                       width: size.width * .1,
                                       height: size.height * .1,
                                       decoration: BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.circular(15),
                                       ),
                                       child: Padding(
                                         padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
                                         child: Column(
                                           children: [
                                             Row(
                                               children: [
                                                 Image.asset(vectorAssets[index],width: size.width * .08,height: size.height * .06,),
                                                 SizedBox(width: size.width * .03,),
                                                 Column(
                                                   mainAxisSize: MainAxisSize.min,
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Text(stepTitle[index],style: GoogleFonts.lato(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                                     Text(stepDescription[index],style: GoogleFonts.lato(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w500),),
                                                   ],
                                                 )
                                               ],
                                             ),
                                           ],
                                         ),
                                       )
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           );
                         },
                       ),
                     ],
                   ),
                 ),
               );
             },
           );
         }
       );
    }
}
