import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../Auth/login_page.dart';
import '../View/home_page.dart';
class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

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
        child:Form(
          key: _key,
          child: Column(
            children: [
              _buildTextField(controller: _user, hintText: "Enter  Name", icon: CupertinoIcons.person ,
                  validator:  (v) => v == null || v.isEmpty ?"Enter the Name" : null),
              SizedBox(height: size.height * .03,),
              _buildTextField(controller: _id, hintText: "Enter Student ID ", icon: CupertinoIcons.creditcard , validator: (v) => v == null || v.isEmpty ?"Enter the Student ID" : null),
              SizedBox(height: size.height * .03,),
              _buildTextField(controller:_email , hintText: "Enter Email Address", icon: CupertinoIcons.mail,keyboard: TextInputType.emailAddress ,
                  validator: (v) => v == null || v.isEmpty ? "Enter the Email Address" : !v.contains("@") ? "Invalid Email Address" :
                  v.length < 5 ? "The email must contain 5 letters" : null ),
              SizedBox(height: size.height * .03,),
              _buildPasswordField(controller: _password, hintText: "Enter Password", isVisible:_isPasswordVisible ,
                  toggleVisible: () => setState(() => _isPasswordVisible = !_isPasswordVisible ),
                  validator: (v) => v == null || v.isEmpty ? "Enter Password" : null),
              SizedBox(height: size.height * .05,),
              _buildPasswordField(controller:_confirmPassword , hintText: "Enter Confirm Password", isVisible: _isConfirmPasswordVisible,
                  toggleVisible: () => setState(()  => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  validator: (v) => v == null || v.isEmpty ? "Enter the Confirm Password" : null),
              SizedBox(height: size.height * .05,),
              MaterialButton(
                onPressed: (){
                  if(_key.currentState!.validate()){
                    Navigator.pushReplacement(context,PageTransition(type: PageTransitionType.fade ,child: HomePage()) );
                  }
                },
                color: Colors.blue,
                minWidth: size.width * .65,
                height: size.height * .05,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text("SIGN UP",style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
              ),
              SizedBox(height: size.height * .02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("have an account already ?",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                  SizedBox(width: size.width * .02,),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade , child: LoginPage()));
                    },
                    child: Text("Log in",style: GoogleFonts.poppins(color: Colors.blue,fontSize: 14,fontWeight: FontWeight.w400),),

                  )
                ],
              )
            ],
          ),
        ) ,
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller , required String hintText ,required String? Function(String?) validator,
    required IconData icon ,TextInputType keyboard  = TextInputType.text }){
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
        hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 16,),
        filled: true,
        fillColor: Colors.grey.withOpacity(.2),
        prefixIcon: Icon(icon , color: Colors.grey,),
        contentPadding: EdgeInsets.all(10),
      ),
    );
  }
  Widget _buildPasswordField({required TextEditingController controller ,
    required String hintText , required bool isVisible ,
    required VoidCallback toggleVisible ,
    required String? Function(String?) validator}){
    return TextFormField(
      validator: validator,
      autofocus: false,
      obscureText: isVisible,
      cursorColor: Colors.grey,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w500),
        fillColor: Colors.grey.withOpacity(.2),
        filled: true,
        suffixIcon: IconButton(onPressed: toggleVisible, icon: Icon(isVisible ?  CupertinoIcons.eye_slash_fill :CupertinoIcons.eye_fill ,
          color: isVisible ? Colors.grey : Colors.grey.withOpacity(.5) ,)),
        contentPadding: EdgeInsets.all(10),
      ),
    );
  }
}
