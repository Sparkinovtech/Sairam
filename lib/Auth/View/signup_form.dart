import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sairam_incubation/Auth/bloc/auth_bloc.dart';
import 'package:sairam_incubation/Auth/bloc/auth_event.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _user = TextEditingController();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _user.dispose();
    _id.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _key,
          child: Column(
            children: [
              _buildTextField(
                controller: _user,
                hintText: "Enter  Name",
                icon: CupertinoIcons.person,
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter the Name" : null,
              ),
              SizedBox(height: size.height * .03),
              _buildTextField(
                controller: _id,
                hintText: "Enter Student ID ",
                icon: CupertinoIcons.creditcard,
                validator: (v) => v == null || v.isEmpty
                    ? "Enter the Student ID"
                    : v.length != 10
                    ? "Enter the valid STUDENT ID"
                    : null,
              ),
              SizedBox(height: size.height * .03),
              _buildTextField(
                controller: _email,
                hintText: "Enter Email Address",
                icon: CupertinoIcons.mail,
                keyboard: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter the Email Address";
                  if (!v.contains("@")) return "Invalid Email Address";
                  if (v.length < 5) return "The email must contain 5 letters";
                  if (!v.endsWith("@sairam.edu.in")) {
                    return "Only SEC/SIT emails allowed";
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height * .03),
              _buildPasswordField(
                controller: _password,
                hintText: "Enter Password",
                isVisible: _isPasswordVisible,
                toggleVisible: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter Password" : null,
              ),
              SizedBox(height: size.height * .03),
              _buildPasswordField(
                controller: _confirmPassword,
                hintText: "Enter Confirm Password",
                isVisible: _isConfirmPasswordVisible,
                toggleVisible: () => setState(
                  () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Enter the Confirm Password";
                  }
                  if (v != _password.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height * .05),
              MaterialButton(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    if (_password.text != _confirmPassword.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Passwords do not match"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                  }
                  context.read<AuthBloc>().add(
                    AuthUserRegisterEvent(
                      email: _email.text,
                      password: _password.text,
                    ),
                  );
                },
                color: Colors.blueGrey,
                minWidth: size.width * .65,
                height: size.height * .05,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "SIGN UP",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: size.height * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "have an account already ?",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: size.width * .02),
                  InkWell(
                    onTap: () {
                      context.read<AuthBloc>().add((AuthUserLogOutEvent()));
                    },
                    child: Text(
                      "Log in",
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      validator: validator,
      autofocus: false,
      keyboardType: keyboard,
      controller: controller,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: .2),
        prefixIcon: Icon(icon, color: Colors.grey),
        contentPadding: EdgeInsets.all(10),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback toggleVisible,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      validator: validator,
      autofocus: false,
      obscureText: !isVisible,
      cursorColor: Colors.grey,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.grey.withValues(alpha: .2),
        filled: true,
        suffixIcon: IconButton(
          onPressed: toggleVisible,
          icon: Icon(
            isVisible ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill,
            color: isVisible ? Colors.grey : Colors.grey.withValues(alpha: .5),
          ),
        ),
        contentPadding: EdgeInsets.all(10),
      ),
    );
  }
}
