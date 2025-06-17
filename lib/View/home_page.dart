import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/stay_request_container.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String name = "John Patric";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * .025,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar( backgroundColor: Colors.grey.withOpacity(.1),radius: 24,backgroundImage: NetworkImage("https://t3.ftcdn.net/jpg/03/02/88/46/360_F_302884605_actpipOdPOQHDTnFtp4zg4RtlWzhOASp.jpg"),),
                      SizedBox(width: size.width * .02,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome",style: GoogleFonts.inter(color: Colors.grey, fontSize: 15,fontWeight: FontWeight.w500),),
                          Text(name ,style: GoogleFonts.inter(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w700),),
                        ],
                      )
                    ],
                  ),
                  CircleAvatar(backgroundColor: Colors.grey.withOpacity(.2) ,radius: 20 ,child: Icon(CupertinoIcons.bell,color: Colors.grey,),),
                ],
              ),
              SizedBox(height: size.height * .06,),
             Padding(
               padding: EdgeInsets.symmetric(horizontal: 15),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text("Your Activity",style: GoogleFonts.inter(color: Colors.black,fontSize: 24,fontWeight: FontWeight.w700),),
                   InkWell(
                     onTap: (){

                     },
                     child:Text("See more",style: GoogleFonts.inter(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w300 ,
                       decoration: TextDecoration.underline,decorationThickness: 1,decorationColor: Colors.grey) ,),
                   ),
                 ],
               ),
             ),
              SizedBox(height: size.height * .05,),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _activityCard(value: "10", label: "Projects", icon: CupertinoIcons.cube, context: context),
                    _activityCard(value: "17", label:"Night Stay", icon: CupertinoIcons.moon_stars_fill, context: context),
                    _activityCard(value: "20", label: "Evening Stay", icon: CupertinoIcons.sun_dust_fill, context: context)
                  ],
                ),
              ),
              SizedBox(height: size.height * .06,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Stay Request",style: GoogleFonts.inter(fontSize: 21,fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: size.height * .03,),
              StayRequestContainer(size: size),
              SizedBox(height: size.height * .05,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Achievements",style: GoogleFonts.inter(fontSize: 20 , fontWeight: FontWeight.w700,color: Colors.black),),
                    InkWell(
                      onTap: (){},
                      child: Text("Add +"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * .15,),
            ],
          ),
        ),
      )
    );
  }
  Widget _activityCard({required String value ,required String label  , required IconData  icon ,  required BuildContext context}){
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * .4,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.blueGrey.withOpacity(.6),radius: 25,child: Icon(icon , size: 24,color: Colors.white,),),
                    ],
                  ),
                  SizedBox(height: size.height * .03,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(value , style: GoogleFonts.inter(fontSize: 24,color: Colors.black,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Row(
                    children: [
                      Text(label , style: GoogleFonts.inter(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.w500),),
                    ],
                  ),
                ],
              ),
            ),
          )
        ),
    );
  }
}
