import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Utils/bottom_nav_bar.dart';
import '../Auth/forget_page.dart';
import '../Auth/signup_page.dart';
class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController  _id = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isPasswordVisible  = false;
  final GlobalKey<FormState> _key  = GlobalKey<FormState>();

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _key,
          child: Column(
            children: [
              _buildTextField(controller: _id, hintText: "Enter Student ID", icon: CupertinoIcons.creditcard,keyboard: TextInputType.text
                  ,validator: (v) => v == null || v.isEmpty ? "Enter the Student ID " : null ),
              SizedBox(height: size.height * .03,),
              _buildPasswordField(controller: _password, hintText: "Enter Password",icon: CupertinoIcons.lock ,isVisible: _isPasswordVisible,
                  toggleVisible: () => setState(() => _isPasswordVisible = !_isPasswordVisible ),
                  validator: (v) => v == null || v.isEmpty ? "Enter the Password" : null ),
              SizedBox(height: size.height * .02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade , child: ForgetPage()));
                    },
                    child: Text("Forget Password ?"),
                  ),
                ],
              ),
              SizedBox(height: size.height * .05,),
              MaterialButton(
                onPressed: (){
                  if(_key.currentState!.validate()){
                    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade , child: BottomNavBar()));

                  }
                },
                color: Colors.blue,
                minWidth: size.width * .67,
                height: size.height * .06,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text("LOG IN",style: GoogleFonts.poppins(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),
              ),
              SizedBox(height: size.height * .03,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account ?",style: GoogleFonts.poppins(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),),
                  SizedBox(width: size.width * .02,),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context,PageTransition(type: PageTransitionType.fade , child: SignupPage()));
                    },
                    child: Text("Sign up now",style: GoogleFonts.poppins(color: Colors.blue,fontSize: 14,fontWeight: FontWeight.w400),),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTextField({required TextEditingController controller  , required String hintText ,required String? Function(String?) validator,
    required IconData icon , TextInputType keyboard = TextInputType.text  }){
    return TextFormField(
      validator: validator,
      autofocus: false,
      cursorColor: Colors.grey,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w500),
        filled: true,
        fillColor: Colors.grey.withOpacity(.2),
        contentPadding: EdgeInsets.all(10),
        prefixIcon: Icon(icon , color: Colors.grey,),
      ),
    );
  }
  Widget _buildPasswordField({required TextEditingController controller ,required String hintText , required bool isVisible ,required IconData icon,
    required VoidCallback  toggleVisible , required String? Function(String?) validator } ){
    return TextFormField(
      autofocus: false,
      validator: validator,
      cursorColor: Colors.grey,
      obscureText: isVisible,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 16),
        fillColor: Colors.grey.withOpacity(.2),
        filled: true,
        prefixIcon: Icon(icon , color: Colors.grey,),
        contentPadding: EdgeInsets.all(10),
        suffixIcon: IconButton(onPressed: toggleVisible, icon: Icon
          (isVisible ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,color: isVisible ? Colors.grey :Colors.grey.withOpacity(.4),),
        ),
      ),
    );
  }
}
