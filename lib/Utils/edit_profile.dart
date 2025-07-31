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
  String? _profilePictureUrl;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  Department? _selected;

  Future<void> requestPermission() async {
    await [Permission.camera, Permission.photos, Permission.storage].request();
  }

  Future<void> _openPhoneStorage() async {
    await requestPermission();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
        _profilePictureUrl = null; // Ensures preview switches to local File
      });
    }
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
          _profilePictureUrl = profile.profilePicture;
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
                                : (_profilePictureUrl != null &&
                                      _profilePictureUrl!.isNotEmpty)
                                ? NetworkImage(_profilePictureUrl!)
                                // Optionally, set a fallback default image asset with AssetImage if profile image is null/empty:
                                : const AssetImage(
                                        'assets/images/default_profile.png',
                                      )
                                      as ImageProvider,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * .04),
                      InkWell(
                        onTap: _openPhoneStorage,
                        child: Text(
                          "Change Profile Picture",
                          style: GoogleFonts.inter(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * .02),
                      Form(
                        key: _key,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            children: [
                              _buildLabeledTextField(
                                "Full Name",
                                _name,
                                TextInputType.name,
                                (v) {
                                  if (v == null || v.isEmpty) {
                                    return "Enter your name";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: size.height * .03),
                              _buildLabeledTextField(
                                "Email Address",
                                _email,
                                TextInputType.emailAddress,
                                (v) {
                                  if (v == null || v.isEmpty) {
                                    return "Enter the Email Address";
                                  }
                                  if (!v.contains('@')) {
                                    return "Invalid Email Address";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: size.height * .03),
                              _buildLabeledTextField(
                                "Phone Number",
                                _phone,
                                TextInputType.phone,
                                (v) {
                                  if (v == null || v.isEmpty) {
                                    return "Enter the Phone Number";
                                  }
                                  if (v.length < 10) {
                                    return "Enter the valid Phone Number";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: size.height * .03),
                              _dropField<Department>(
                                selectedValue: _selected,
                                options: Department.values,
                                onChange: (val) =>
                                    setState(() => _selected = val),
                                hintText: 'Select your department',
                                itemLabelBuilder: (dept) => dept.departmentName,
                              ),
                              SizedBox(height: size.height * .03),
                              _buildLabelDatePicker(
                                "Date of Birth",
                                context,
                                _dob,
                                size,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: MaterialButton(
                  elevation: 0,
                  onPressed: () => Navigator.pop(context),
                  minWidth: size.width * .3,
                  height: size.height * .05,
                  color: Colors.grey[100],
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
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: MaterialButton(
                  elevation: 0,
                  onPressed: () {
                    if (!_key.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please fill all fields correctly."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (_selected == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select your department."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    context.read<ProfileBloc>().add(
                      RegisterProfileInformationEvent(
                        profilePic: _file?.path ?? _profilePictureUrl,
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
                  splashColor: Colors.white.withValues(alpha: 0.4),
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

  Widget _buildLabeledTextField(
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
    String? Function(String?)? validator,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            hintText: label,
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(13),
          ),
        ),
      ],
    );
  }

  Widget _dropField<T>({
    required T? selectedValue,
    required List<T> options,
    required ValueChanged<T?> onChange,
    required String hintText,
    required String Function(T) itemLabelBuilder,
  }) {
    return DropdownButtonFormField<T>(
      value: options.contains(selectedValue) ? selectedValue : null,
      onChanged: onChange,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      items: options
          .map(
            (e) => DropdownMenuItem<T>(
              value: e,
              child: Text(itemLabelBuilder(e), overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
    );
  }

  Widget _buildLabelDatePicker(
    String label,
    BuildContext context,
    TextEditingController controller,
    Size size,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            DateTime initialDate;
            try {
              initialDate = DateTime.parse(controller.text);
            } catch (_) {
              initialDate = DateTime(2000, 1, 1);
            }
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                controller.text =
                    "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
              });
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Select your date of birth',
                suffixIcon: const Icon(Icons.calendar_today),
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(13),
              ),
              validator: (v) => v == null || v.isEmpty
                  ? 'Please select your date of birth'
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
