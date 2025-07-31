import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
Future<bool> showProgress(BuildContext context) async {
    var size =  MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context){
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30 , vertical: 20),
                child: AnimatedContainer(
                    width: size.width * .5,
                    height: size.height * .3,
                    duration: Duration(seconds: 1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                        child: Column(
                            children: [
                                Text("Order Send Successfully",
                                    style: GoogleFonts.lato(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w800),),
                            ],
                        ),
                    ),
                ),

            ),
        );
    }).then( (value) => value ?? false);
}
