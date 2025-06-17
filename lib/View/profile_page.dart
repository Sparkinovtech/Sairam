import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  File? _imageFile;
  Future<void> requestPermission() async{
    await [
      Permission.camera,
      Permission.photos,
      Permission.storage,
    ].request();
  }

  Future<void> _openCamera() async{
    await requestPermission();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var size  = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * .1,),
            Stack(
              children: [
                   Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children : [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(85),
                          ),
                          elevation: 10,
                          child: CircleAvatar(radius: 85,backgroundColor: Colors.white,backgroundImage: _imageFile != null ? FileImage(_imageFile!) :
                          NetworkImage("https://t3.ftcdn.net/jpg/03/02/88/46/360_F_302884605_actpipOdPOQHDTnFtp4zg4RtlWzhOASp.jpg")  as ImageProvider,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(10),
                            child: IconButton(onPressed: (){
                              _openCamera();
                            }, icon:Icon( CupertinoIcons.camera_fill),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: size.height * .03,),
            Text("John Patric",style: GoogleFonts.inter(fontSize: 21 , fontWeight: FontWeight.bold,color: Colors.black),),
            SizedBox(height: size.height * .01,),
            Text("CSE A SEC22CS102",style: GoogleFonts.inter(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.grey),),
            SizedBox(height: size.height * .03,),
            ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 20 , horizontal: 20),
              children: [
                _buildList(icon: Icons.edit, text:"Edit Profile", onTap: () {
                }),
                SizedBox(height: size.height * .025,),
                _buildList(icon:Icons.password, text: "Change Password", onTap: (){}),
                SizedBox(height: size.height * .025,),
                _buildList(icon: CupertinoIcons.location_fill, text: "Change Location", onTap:(){}),
                SizedBox(height: size.height * .025,),
                _buildList(icon: CupertinoIcons.person_2_alt, text: "Clubs and Cells ", onTap:(){}),
                SizedBox(height: size.height * .025,),
                _buildList(icon: CupertinoIcons.person_3, text: "Other Activities", onTap:(){}),
                SizedBox(height: size.height * .025,),
                _buildList(icon: Icons.logout, text: "Log Out", onTap: (){} ,iconColor: Colors.red),
                SizedBox(height: size.height * .025,),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList({required IconData icon , required String text , required VoidCallback onTap , Color iconColor = Colors.black ,Color textColor = Colors.black}){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      margin: EdgeInsets.symmetric(vertical: 2),
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: Icon(icon, color: iconColor,),
          title: Text(text,style: GoogleFonts.inter(fontSize: 16,fontWeight: FontWeight.w500,color: textColor),),
          trailing: Icon(Icons.arrow_forward_ios_rounded,color: iconColor),
        ),
      ),
    );
  }
}
