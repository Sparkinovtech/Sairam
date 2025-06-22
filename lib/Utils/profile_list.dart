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

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _showNewField = false;
  bool _isProcessing = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  void _showChangePasswordSheet(BuildContext context) {
    setState(() {
      _showNewField = false;
      _isProcessing = false;
      _isPasswordVisible = false;
      _isConfirmPasswordVisible = false;
      _isNewPasswordVisible = false;
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          var size = MediaQuery.of(context).size;
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                color: Colors.white,
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Reset the Password",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "To reset the password Please enter  the  current\n password then only we can process ",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * .03),
                      Form(
                        key: _key,
                        child: Column(
                          children: [
                            if (!_showNewField) ...[
                              SizedBox(height: size.height * .025),
                              _buildText(
                                controller: _currentPasswordController,
                                hintText: "Enter the Current Password",
                                validator: (v) => v == null || v.isEmpty
                                    ? "Enter the Current Password"
                                    : null,
                                icon: CupertinoIcons.lock,
                                isVisible: _isPasswordVisible,
                                toggle: () => setState(
                                  () =>
                                      _isPasswordVisible = !_isPasswordVisible,
                                ),
                              ),
                              SizedBox(height: size.height * .04),
                              MaterialButton(
                                onPressed: () async {
                                  if (_key.currentState!.validate()) {
                                    setState(() => _isProcessing = true);
                                    await Future.delayed(Duration(seconds: 10));
                                    setState(() {
                                      _isProcessing = false;
                                      _showNewField = true;
                                    });
                                  }
                                },
                                color: Colors.blue,
                                minWidth: size.width * .6,
                                height: size.height * .056,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: _isProcessing
                                    ? CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      )
                                    : Text(
                                        "Process",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ),
                            ] else ...[
                              SizedBox(height: size.height * .025),
                              _buildText(
                                controller: _newPasswordController,
                                hintText: "Enter the New Password",
                                validator: (v) => v == null || v.isEmpty
                                    ? "Enter the New Password"
                                    : null,
                                icon: CupertinoIcons.lock,
                                isVisible: _isNewPasswordVisible,
                                toggle: () => _isNewPasswordVisible =
                                    !_isNewPasswordVisible,
                              ),
                              SizedBox(height: size.height * .025),
                              _buildText(
                                controller: _confirmPasswordController,
                                hintText: "Enter the Confirm Password",
                                validator: (v) => v == null || v.isEmpty
                                    ? "Enter the Confirm Password"
                                    : null,
                                icon: CupertinoIcons.lock,
                                isVisible: _isConfirmPasswordVisible,
                                toggle: () => setState(
                                  () => _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible,
                                ),
                              ),
                              SizedBox(height: size.height * .027),
                              MaterialButton(
                                onPressed: () {
                                  if (_key.currentState!.validate()) {
                                    Navigator.pop(context);
                                  }
                                },
                                color: Colors.blue,
                                minWidth: size.width * .7,
                                height: size.height * .056,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Text(
                                  "Update Password",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
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
            onTap: () {
              _showChangePasswordSheet(context);
            },
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

  Widget _buildText({
    required TextEditingController controller,
    required String? hintText,
    required String? Function(String?) validator,
    required IconData icon,
    required bool isVisible,
    required VoidCallback toggle,
  }) {
    return TextFormField(
      cursorColor: Colors.grey,
      obscureText: isVisible,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: Colors.grey.withOpacity(.3),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.all(15),
        suffixIcon: IconButton(
          onPressed: toggle,
          icon: isVisible
              ? Icon(CupertinoIcons.eye_slash_fill)
              : Icon(CupertinoIcons.eye_fill),
          color: isVisible ? Colors.grey.withOpacity(.3) : Colors.black,
        ),
        filled: true,
        fillColor: Colors.grey.withOpacity(.1),
        prefixIcon: Icon(icon, color: Colors.black),
      ),
    );
  }
}
