import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class IdentityDetails extends StatefulWidget {
  const IdentityDetails({super.key});

  @override
  State<IdentityDetails> createState() => _IdentityDetailsState();
}

class _IdentityDetailsState extends State<IdentityDetails> {
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
                padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back_ios_new)),
                  ],
                ),
              ),
              SizedBox(height: size.height * .01,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40 , vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Identity Details",style: GoogleFonts.lato(color: Colors.black,fontSize: 27,fontWeight: FontWeight.w700),),
                  ],
                ),
              ),
              SizedBox(height: size.height * .03,),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 20),
            child: MaterialButton(
              elevation: 0,
              onPressed: (){},
              minWidth: size.width * .31,
              height: size.height * .045,
              color: Colors.grey[200]!,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text("Cancel",style: GoogleFonts.lato(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w500),),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 20),
            child: MaterialButton(
              elevation: 0,
              onPressed: (){},
              minWidth: size.width * .5,
              height: size.height * .05,
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text("Save changes",style: GoogleFonts.lato(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w700),),
            ),
          )
        ],
      )
    );
  }
}
