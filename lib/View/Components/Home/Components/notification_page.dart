import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back_ios_new, color: Colors.black,),),
                    SizedBox(width:  size.width * .03,),
                    Text("Notification",style: GoogleFonts.lato(color: Colors.black,fontSize: 24,fontWeight: FontWeight.w500),),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
