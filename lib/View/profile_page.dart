import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sairam_incubation/Utils/profile_list.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  File? _imageFile;
  Future<void> requestPermission() async {
    await [Permission.camera, Permission.photos, Permission.storage].request();
  }

  // Future<void> _openCamera() async{
  //   await requestPermission();
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);
  //   if(pickedFile != null){
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.04),
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                      color: Colors.white,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : NetworkImage(
                                    "https://t3.ftcdn.net/jpg/03/02/88/46/360_F_302884605_actpipOdPOQHDTnFtp4zg4RtlWzhOASp.jpg",
                                  )
                                  as ImageProvider,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: size.width * .032,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(10),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.photo_camera_solid,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * .02),
                Text(
                  "JOHN PATRIC",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * .015),
                Text(
                  "CSE A SEC22CS23",
                  style: GoogleFonts.inter(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Expanded(child: ListView(children: [ProfileList()])),
          ],
        ),
      ),
    );
  }
}
