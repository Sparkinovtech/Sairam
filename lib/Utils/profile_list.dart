import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Auth/View/login_page.dart';
import 'package:sairam_incubation/Auth/View/signup_page.dart';

class ProfileList extends StatefulWidget {
  const ProfileList({super.key});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _opacity = Tween<double>(
      begin: 1.0,
      end: 0.2,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        children: [
          _buildList(icon: Icons.edit, text: "Edit Profile", onTap: () {}),
          SizedBox(height: size.height * .025),
          _buildList(
            icon: CupertinoIcons.lock,
            text: "Change Password",
            onTap: () {},
          ),
          SizedBox(height: size.height * .025),
          _buildList(
            icon: CupertinoIcons.location_solid,
            text: "Change Location",
            onTap: () {},
          ),
          SizedBox(height: size.height * .025),
          _buildList(
            icon: CupertinoIcons.person_2_alt,
            text: "Clubs and Cells",
            onTap: () {},
          ),
          SizedBox(height: size.height * .025),
          _buildList(
            icon: CupertinoIcons.person_3_fill,
            text: "Other Activities",
            onTap: () {},
          ),
          SizedBox(height: size.height * .025),
          _buildList(
            icon: Icons.logout,
            text: "Log out",
            onTap: () {
              showCupertinoDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _opacity,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _opacity.value,
                                  child: child,
                                );
                              },
                              child: Icon(
                                Icons.warning,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * .01),

                        Text(
                          "Are you sure want to log out ?",
                          style: GoogleFonts.inder(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: size.height * .01),
                      ],
                    ),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              duration: Duration(seconds: 1),
                              child: LoginPage(),
                            ),
                          );
                        },
                        child: Text("OK"),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("CANCEL"),
                      ),
                    ],
                  );
                },
              );
            },
            iconColor: Colors.red,
          ),
          SizedBox(height: size.height * .025),
          _buildList(
            icon: CupertinoIcons.delete_solid,
            text: "Delete Account",
            onTap: () {
              showCupertinoDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _opacity,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _opacity.value,
                                  child: child,
                                );
                              },
                              child: Icon(
                                Icons.delete_sharp,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * .025),
                        Text(
                          "Are you sure want to delete account",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: size.height * .025),
                        Text(
                          "Deleting the account may permanently lose the data !",
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              duration: Duration(seconds: 1),
                              child: SignupPage(),
                            ),
                          );
                        },
                        child: Text(
                          "OK",
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "CANCEL",
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            iconColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildList({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color iconColor = Colors.black,
    Color textColor = Colors.black,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      margin: EdgeInsets.symmetric(vertical: 2),
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: iconColor),
          title: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: iconColor),
        ),
      ),
    );
  }
}
