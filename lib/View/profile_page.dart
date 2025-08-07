import 'dart:developer' as devtools;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sairam_incubation/Profile/bloc/profile_bloc.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Utils/Loader/loading_screen.dart';
import 'package:sairam_incubation/Utils/edit_profile.dart';
import 'package:sairam_incubation/Utils/profile_list.dart';
import '../Auth/bloc/auth_bloc.dart';
import '../Auth/bloc/auth_event.dart';
import '../Utils/dialogs/logout_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _initialized = false;
  File? _file;
  String? _profilePictureUrl;

  Future<void> requestPermission() async {
    await [Permission.camera, Permission.photos, Permission.storage].request();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: "Loading...");
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        final profile = state.profile;
        if (!_initialized && profile != null) {
          _profilePictureUrl = profile.profilePicture;
          _initialized = true;
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: size.height * 0.03),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Profile",
                              style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                final bool shouldLogOut =
                                    await showLogoutDialog(context);
                                devtools.log(shouldLogOut.toString());
                                if (!context.mounted) return;
                                if (shouldLogOut) {
                                  context.read<AuthBloc>().add(
                                    const AuthUserLogOutEvent(),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.logout_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * .02),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13),
                        child: Row(
                          children: [
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                backgroundImage: _file != null
                                    ? FileImage(_file!)
                                    : (_profilePictureUrl != null &&
                                          _profilePictureUrl!.isNotEmpty)
                                    ? NetworkImage(_profilePictureUrl!)
                                    : const AssetImage(
                                            'assets/images/default_profile.jpg',
                                          )
                                          as ImageProvider,
                              ),
                            ),
                            SizedBox(width: size.width * .03),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile?.name ?? "Student",
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      profile?.id ?? "SEC ID",
                                      style: GoogleFonts.inter(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * .01),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Material(
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child: EditProfile(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: size.height * .05,
                                          width: size.width * .48,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.blue[400]!,
                                                Colors.blue[600]!,
                                                Colors.blue[500]!,
                                                Colors.blue[400]!,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Edit Profile",
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: size.width * .03),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: size.height * .04,
                                        width: size.width * .08,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          border: Border.all(
                                            color: Colors.blue,
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.ios_share,
                                            size: 17,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * .04),
                  ProfileList(profile: profile),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
