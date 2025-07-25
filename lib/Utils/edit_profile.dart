import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sairam_incubation/Profile/Model/department.dart';
import 'package:sairam_incubation/Profile/bloc/profile_bloc.dart';
import 'package:sairam_incubation/Profile/bloc/profile_event.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Utils/Loader/loading_screen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _initialized = false;

  File? _file;
  Future<void> requestPermission() async {
    await [Permission.camera, Permission.photos, Permission.storage].request();
  }

  Future<void> _openPhoneStorage() async {
    requestPermission();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });
    }
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _dob = TextEditingController();

  Department? _selected;

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

        if (state is ProfileInformationDoneState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final profile = state.profile;

        if (!_initialized && profile != null) {
          _name.text = profile.name ?? "";
          _email.text = profile.emailAddresss ?? "";
          _phone.text = profile.phoneNumber ?? "";
          _dob.text = profile.dateOfBirth ?? "";
          _selected = profile.department;
          _initialized = true;
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 30,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                              ),
                            ),
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
                            backgroundImage: _file != null
                                ? FileImage(_file!)
                                : NetworkImage(
                                        "https://imgcdn.stablediffusionweb.com/2024/11/1/f9199f4e-2f29-4b5c-8b51-5a3633edb18b.jpg",
                                      )
                                      as ImageProvider,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * .04),
                      InkWell(
                        onTap: () {
                          _openPhoneStorage();
                        },
                        child: Text(
                          "Change Profile Picture",
                          style: GoogleFonts.inter(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * .02),
                  Form(
                    key: _key,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _name,
                            text: "Full Name",
                            validator: (v) => v == null || v.isEmpty
                                ? "Enter your name"
                                : null,
                            key: TextInputType.name,
                          ),
                          SizedBox(height: size.height * .03),
                          _buildTextField(
                            controller: _email,
                            text: profile?.emailAddresss ?? "Email Address",
                            key: TextInputType.emailAddress,
                            validator: (v) => v == null || v.isEmpty
                                ? "Enter the Email Address"
                                : !v.contains('@')
                                ? "Invalid Email Address "
                                : null,
                          ),
                          SizedBox(height: size.height * .03),
                          _buildTextField(
                            controller: _phone,
                            text: profile?.phoneNumber ?? "Phone Number",
                            key: TextInputType.phone,
                            validator: (v) => v == null || v.isEmpty
                                ? "Enter the Phone Number"
                                : v.length < 10
                                ? "Enter the valid Phone Number"
                                : null,
                          ),
                          SizedBox(height: size.height * .03),
                          _dropField<Department>(
                            selectedValue: _selected,
                            options: Department.values,
                            onChange: (val) => setState(() => _selected = val),
                            hintText: 'Select your department',
                            itemLabelBuilder: (dept) => dept.departmentName,
                          ),
                          SizedBox(height: size.height * .03),
                          _buildTextField(
                            controller: _dob,
                            text: profile?.dateOfBirth ?? "Date Of Birth",
                            key: TextInputType.number,
                            validator: (v) =>
                                v == null || v.isEmpty ? "Enter the DOB" : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: MaterialButton(
                  elevation: 0,
                  onPressed: () {},
                  minWidth: size.width * .3,
                  height: size.height * .05,
                  color: Colors.grey[100]!,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: MaterialButton(
                  elevation: 0,
                  onPressed: () {
                    if (_name.text.isEmpty ||
                        _email.text.isEmpty ||
                        _phone.text.isEmpty ||
                        _dob.text.isEmpty ||
                        _selected == null) {
                      // Show error message using a SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please fill in all required fields."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    // If all validations pass, dispatch the event
                    context.read<ProfileBloc>().add(
                      RegisterProfileInformationEvent(
                        profilePic: _file?.path, // Optional
                        fullName: _name.text,
                        emailAddress: _email.text,
                        phoneNumber: _phone.text,
                        department: _selected!,
                        dateOfBirth: _dob.text,
                      ),
                    );
                  },
                  minWidth: size.width * .5,
                  height: size.height * .05,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  splashColor: Colors.white.withValues(alpha: .4),
                  child: Text(
                    "Save Changes",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String text,
    required TextInputType key,
    required String? Function(String?) validator,
  }) {
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
        fillColor: Colors.grey.withValues(alpha: .1),
        hintText: text,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.all(13),
      ),
    );
  }

  Widget _dropField<T>({
    required String hintText,
    required T? selectedValue,
    required List<T> options,
    required ValueChanged<T?> onChange,
    required String Function(T) itemLabelBuilder,
  }) {
    return DropdownButtonFormField<T>(
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
        fillColor: Colors.grey.withValues(alpha: 0.1),
        contentPadding: EdgeInsets.all(13),
      ),
      icon: Icon(Icons.keyboard_arrow_down),
      items: options.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemLabelBuilder(item), overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }
}
