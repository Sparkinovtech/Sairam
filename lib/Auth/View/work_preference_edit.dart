import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sairam_incubation/Utils/WorkPreference_dorp_down_field.dart';
class WorkpreferenceEdit extends StatefulWidget {
  const WorkpreferenceEdit({super.key});

  @override
  State<WorkpreferenceEdit> createState() => _WorkpreferenceEditState();
}

class _WorkpreferenceEditState extends State<WorkpreferenceEdit> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 20),
                child: Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon:Icon(Icons.arrow_back_ios_new)),
                  ],
                ),
              ),
              SizedBox(height: size.height * .01,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30 ,),
                child: Row(
                  children: [
                    Text("Work Preferences",style: GoogleFonts.lato(color: Colors.black,fontSize: 27,fontWeight: FontWeight.w700),),
                  ],
                ),
              ),
              SizedBox(height: size.height * .03,),
              WorkpreferenceDorpDownField(),
            ],
          ),
        ),
      ),
    );
  }
}
