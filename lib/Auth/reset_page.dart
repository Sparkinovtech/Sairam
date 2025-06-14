import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Auth/login_page.dart';
import 'package:sairam_incubation/Utils/images.dart';
class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController  = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final GlobalKey<FormState> _key  = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          RepaintBoundary(
            child : Positioned.fill(
                child: Image.asset(background,fit: BoxFit.cover,),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(.9),
                  // Colors.white.withOpacity(.8),
                  Colors.white.withOpacity(.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: size.height * .06,
            left: 20,
            child: IconButton(
              onPressed: (){
                Navigator.pushReplacement(context,PageTransition(type: PageTransitionType.fade , child: LoginPage()));
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30 , vertical: 50),
              child:Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * .1,),
                      Text("Reset Your Password",style: GoogleFonts.inter(color: Colors.black,fontSize: 27,fontWeight: FontWeight.w700),),
                    ],
                  ),
                  SizedBox(height: size.height * .04,),
                  Form(
                    key: _key,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildPasswordField(controller: _passwordController, hintText: "Enter the Password", isVisible: _isPasswordVisible,
                              icon: CupertinoIcons.lock, toggleVisible: () => setState(() => _isPasswordVisible = !_isPasswordVisible ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return "Enter the Password";
                                return null;
                              } ),
                          SizedBox(height: size.height * .07,),
                          _buildPasswordField(controller: _confirmPasswordController, hintText:"Enter Confirm Password", isVisible: _isConfirmPasswordVisible,
                              icon: CupertinoIcons.lock, toggleVisible: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return "Enter the Confirm Password";
                                if (v != _passwordController.text) return "Passwords do not match";
                                return null;
                              }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * .08,),
                  MaterialButton(
                    onPressed: (){
                      if(_key.currentState!.validate()) {
                        Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade , child: LoginPage()));
                      }
                    },
                    color: Color(0xFF2580C3),
                    minWidth: size.width * .7,
                    height: size.height * .056,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text("Submit",style: GoogleFonts.inter(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),),

                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPasswordField({required TextEditingController controller , required String hintText ,
  required bool isVisible , required IconData icon  , required VoidCallback toggleVisible , required String? Function(String?) validator  }){
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      cursorColor: Colors.grey,
      autofocus: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey[700]!, fontSize: 16,fontWeight: FontWeight.w700),
        hintText: hintText,
        suffixIcon: IconButton(onPressed: toggleVisible, icon: Icon(isVisible ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
          color: isVisible ? Colors.grey : Colors.black,)),
        prefixIcon: Icon(icon ,color: Colors.grey,),
        contentPadding: EdgeInsets.all(10),
        fillColor: Colors.grey.withOpacity(.3),
        filled: true,
      ),
    );
  }
}
