import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _file;
  Future<void> requestPermission() async{
    await [Permission.camera , Permission.photos, Permission.storage].request();
  }
  Future<void> _openPhoneStorage() async{
    requestPermission();
    final picker = ImagePicker();
    final _pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(_pickedFile != null){
      setState(() {
        _file = File(_pickedFile.path);
      });
    }
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController  _phone = TextEditingController();
  final TextEditingController  _department = TextEditingController();
  final TextEditingController  _dob  =  TextEditingController();

  String? _selected;

  final List<String> _option = [
    "Computer Science and Engineering",
    "Information Technology",
    "Internet Of Things(IOT)",
    "Artificial Intelligence And Data Science",
    "Artificial Intelligence And Machine Learning",
    "Cyber Security",
    "Computer Science And Business Systems",
    "Computer Science And Communication Engineering",
    "Electronics And Communication Engineering",
    "Electrical And Electronics Engineering",
    "Mechanical Engineering"
  ];

  @override
  Widget build(BuildContext context) {
    var size =  MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child:Flex(
            direction: Axis.vertical,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,)),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        backgroundImage:  _file != null ? FileImage(_file!) :
                        NetworkImage("https://imgcdn.stablediffusionweb.com/2024/11/1/f9199f4e-2f29-4b5c-8b51-5a3633edb18b.jpg") as ImageProvider,
                      ),
                    )
                  ),
                  SizedBox(height:size.height * .04,),
                  InkWell(
                    onTap: (){
                      _openPhoneStorage();
                    },
                    child: Text("Change Profile Picture",style: GoogleFonts.inter(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.w500),),
                  )
                ],
              ),
              SizedBox(height: size.height * .02,),
              Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      _buildTextField(controller: _name, text: "Full name", validator: (v) => v == null || v.isEmpty ? "Enter your name" : null , key: TextInputType.name),
                      SizedBox(height:  size.height * .03,),
                      _buildTextField(controller: _email, text: "Email Address", key: TextInputType.emailAddress, validator: (v) => v == null || v.isEmpty ? "Enter the Email Address" :
                      !v.contains('@') ? "Invalid Email Address " : null) ,
                      SizedBox(height: size.height * .03,),
                      _buildTextField(controller: _phone,  text: "Phone  Number", key: TextInputType.phone, validator: (v) => v == null || v.isEmpty ?
                      "Enter the Phone Number" : v.length < 10 ? "Enter the valid Phone Number" : null ),
                      SizedBox(height: size.height * .03,),
                      _dropField( selectedValue: _selected, options: _option ,onChange: (val) => setState(() => _selected = val), hintText: 'Select your department'),
                      SizedBox(height: size.height * .03,),
                      _buildTextField(controller: _dob, text: "DOB", key: TextInputType.number, validator: (v) => v == null || v.isEmpty ? "Enter the DOB" : null),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 20),
            child: MaterialButton(
              elevation: 0,
              onPressed: (){},
              minWidth: size.width * .3,
              height:size.height * .05,
              color: Colors.grey[100]!,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text("Cancel",style: GoogleFonts.inter(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w500),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 20),
            child: MaterialButton(
              elevation: 0,
              onPressed: (){
                if(_key.currentState!.validate()){
                  Navigator.pop(context);
                }
              },
              minWidth: size.width* .5,
              height: size.height * .05,
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              splashColor: Colors.white.withOpacity(.4),
              child: Text("Save Changes", style: GoogleFonts.lato(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
            ),
          )
        ],
      ),
    );
  }
  Widget _buildTextField({required TextEditingController controller , required String text , required TextInputType key,
    required String? Function(String?) validator  }){
    return TextFormField(
      cursorColor: Colors.grey,
      controller: controller,
      keyboardType: key,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.withOpacity(.1),
        hintText: text,
        hintStyle: TextStyle(color: Colors.grey ,fontSize: 15,fontWeight: FontWeight.w500),
        contentPadding: EdgeInsets.all(13),
      ),
    );
  }
  Widget _dropField({
    required String hintText,
    required String? selectedValue, required List<String> options, required ValueChanged<String?> onChange,
  }) {
    return DropdownButtonFormField<String>(
      value: options.contains(selectedValue) ? selectedValue : null,
      onChanged: onChange,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(11),
        ),
        filled: true,
        fillColor: Colors.grey.withOpacity(.1),
        contentPadding: EdgeInsets.all(13),
      ),
      icon: Icon(Icons.keyboard_arrow_down),
      items: options.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
