import 'dart:developer' as devtools;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Auth/View/workPreference_edit.dart';
class ProfileList extends StatefulWidget {
  const ProfileList({super.key});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> with SingleTickerProviderStateMixin {
  // late AnimationController _animationController;
  // late Animation<double> _opacity;
  // @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: Duration(milliseconds: 700),
  //   )..repeat(reverse: true);
  //   _opacity = Tween<double>(
  //     begin: 1.0,
  //     end: 0.2,
  //   ).animate(_animationController);
  // }
  //
  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   super.dispose();
  // }
  //
  List<String> _workPreferences = [];
  List<String> _skillSet = [];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),

      child: Column(
        children: [
          _buildList(icon: Icons.arrow_forward_ios_rounded, text: "Identity details", subText: "Basic personal and academic information", onTap: (){}),
          SizedBox(height: size.height * .06,),
          _buildListWidget(icon: Icons.edit_outlined ,text: "Work Preference", subText: "Your desired roles and availability", tags: _workPreferences,
            onTap: () async{
            // final update = await Navigator.push(context, PageTransition(type: PageTransitionType.fade , child: WorkpreferenceEdit()));
              Navigator.push(context, PageTransition(type: PageTransitionType.fade , child: WorkpreferenceEdit()));
            }
          ),
          SizedBox(height: size.height * .04,),
          _buildListWidget(icon:Icons.edit_outlined, text: "Skill Set", subText: "Highlight your tools and capability", tags:_skillSet , onTap:(){}),
          SizedBox(height: size.height * .04,),
          _buildList(icon: Icons.arrow_forward_ios_rounded, text:"Portfolio", subText: "Showcase your best design work", onTap: (){}),
          SizedBox(height: size.height * .04,),
          _buildList(icon: Icons.arrow_forward_ios_rounded, text: "Earned Certificates", subText: "Proof of learning and achievement", onTap: (){}),
          SizedBox(height: size.height * .03,),

        ],
      ),
    );
  }
Widget _buildList({required IconData icon , required String text , required String subText ,  required VoidCallback onTap ,  }) {
  var size = MediaQuery
      .of(context)
      .size;
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(13),
    ),
    color: Colors.white,
    margin: EdgeInsets.symmetric(vertical: 1),
    child: Container(
      width: double.infinity,
      height: size.height * .107,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.grey.withOpacity(.2), width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text, style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),),
                    Text(subText, style: GoogleFonts.lato(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),),
                  ],
                ),
                IconButton(onPressed: onTap, icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 20,)),
              ],
            ),
          ),

        ],
      ),
    ),
  );
}

Widget _buildListWidget({required IconData icon , required String text , required String subText , required List<String> tags, required VoidCallback onTap, }){
    var size = MediaQuery.of(context).size;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      margin: EdgeInsets.symmetric(vertical: 1),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        height:size.height * .2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.grey.withOpacity(.2), width:1),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text , style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),
                      Text(subText , style: GoogleFonts.lato(color: Colors.grey.withOpacity(.5) , fontSize: 12,fontWeight: FontWeight.w400),),
                    ],
                  ),
                  IconButton(onPressed: onTap, icon: Icon(Icons.edit_outlined,color: Colors.grey,)),
                ],
              ),
            ),
            SizedBox(height: size.height * .03,),
           tags.isEmpty ? Text("No Preference is Selected") :  Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) => _buildTags(tag)).toList(),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTags(String text){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14,vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black,width: 1),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(text,style: GoogleFonts.openSans(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400),),
    );
  }
}
