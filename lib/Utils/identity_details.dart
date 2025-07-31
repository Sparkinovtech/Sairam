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

class IdentityDetails extends StatefulWidget {
  const IdentityDetails({super.key});

  @override
  State<IdentityDetails> createState() => _IdentityDetailsState();
}

class _IdentityDetailsState extends State<IdentityDetails> {
  Department? _selected;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _year = TextEditingController();
  final TextEditingController _graduation = TextEditingController();
  final TextEditingController _mentorName = TextEditingController();
  bool _initialized = false;

  File? _file;
  String? _currentIdCardUrl; // stores the current URL if from cloud

  Future<void> requestPermission() async {
    await [
      Permission.phone,
      Permission.storage,
      Permission.photos,
      Permission.camera,
    ].request();
  }

  Future<void> _openPhoneStorage() async {
    await requestPermission();
    final picker = ImagePicker();
    final pickedSource = await picker.pickImage(source: ImageSource.gallery);
    if (pickedSource != null) {
      setState(() {
        _file = File(pickedSource.path);
        _currentIdCardUrl = null; // Use the newly picked local file for preview
      });
    }
  }

  @override
  void dispose() {
    _id.dispose();
    _year.dispose();
    _graduation.dispose();
    _mentorName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: "Loading...");
        } else {
          LoadingScreen().hide();
        }
        if (state is IdentityDetailsDoneState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final profile = state.profile;
        if (!_initialized && profile != null) {
          _selected = profile.department;
          _id.text = profile.id ?? "";
          _year.text = profile.currentYear?.toString() ?? "";
          _graduation.text = profile.yearOfGraduation?.toString() ?? "";
          _mentorName.text = profile.currentMentor ?? "";
          _currentIdCardUrl = profile.collegeIdPhoto;
          _initialized = true;
        }

        Widget labelledField(String label, Widget child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              child,
            ],
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .01),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Identity Details",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * .03),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          labelledField(
                            "Student Id",
                            TextFormField(
                              controller: _id,
                              keyboardType: TextInputType.text,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? "Enter the Student Id"
                                  : null,
                              decoration: InputDecoration(
                                hintText: "Student Id",
                                hintStyle: GoogleFonts.lato(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                              cursorColor: Colors.grey,
                            ),
                          ),
                          SizedBox(height: size.height * .03),
                          labelledField(
                            "Department",
                            DropdownButtonFormField<Department>(
                              value: Department.values.contains(_selected)
                                  ? _selected
                                  : null,
                              validator: (val) => val == null
                                  ? "Please Select a Department"
                                  : null,
                              onChanged: (val) =>
                                  setState(() => _selected = val),
                              isExpanded: true,
                              decoration: InputDecoration(
                                hintText: "Select Department",
                                hintStyle: GoogleFonts.lato(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: Department.values
                                  .map(
                                    (dept) => DropdownMenuItem<Department>(
                                      value: dept,
                                      child: Text(
                                        dept.departmentName,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: size.height * .03),
                          labelledField(
                            "Current Year",
                            TextFormField(
                              controller: _year,
                              keyboardType: TextInputType.number,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? "Enter the Current Year"
                                  : null,
                              decoration: InputDecoration(
                                hintText: "Current Year",
                                hintStyle: GoogleFonts.lato(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                              cursorColor: Colors.grey,
                            ),
                          ),
                          SizedBox(height: size.height * .03),
                          labelledField(
                            "Year of Graduation",
                            TextFormField(
                              controller: _graduation,
                              keyboardType: TextInputType.number,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? "Enter the Year of Graduation"
                                  : null,
                              decoration: InputDecoration(
                                hintText: "Year of Graduation",
                                hintStyle: GoogleFonts.lato(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                              cursorColor: Colors.grey,
                            ),
                          ),
                          SizedBox(height: size.height * .03),
                          labelledField(
                            "Mentor Name",
                            TextFormField(
                              controller: _mentorName,
                              keyboardType: TextInputType.name,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? "Enter the Mentor Name"
                                  : null,
                              decoration: InputDecoration(
                                hintText: "Mentor Name",
                                hintStyle: GoogleFonts.lato(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                              cursorColor: Colors.grey,
                            ),
                          ),
                          SizedBox(height: size.height * .03),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Id Proof",
                              style: GoogleFonts.lato(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * .03),

                          // Updated preview logic: show file image if picked, else the current URL if available
                          if (_file != null)
                            Card(
                              color: Colors.white,
                              margin: const EdgeInsets.only(bottom: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _file!,
                                  width: double.infinity,
                                  height: size.height * .35,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          else if (_currentIdCardUrl != null &&
                              _currentIdCardUrl!.isNotEmpty)
                            Card(
                              color: Colors.white,
                              margin: const EdgeInsets.only(bottom: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  _currentIdCardUrl!,
                                  width: double.infinity,
                                  height: size.height * .35,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        color: Colors.grey[300],
                                        height: size.height * .35,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Could not load image',
                                          style: GoogleFonts.lato(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ),

                          MaterialButton(
                            elevation: 0,
                            onPressed: _openPhoneStorage,
                            minWidth: double.infinity,
                            height: size.height * .05,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.blue),
                            ),
                            child: Text(
                              _file != null ||
                                      (_currentIdCardUrl != null &&
                                          _currentIdCardUrl!.isNotEmpty)
                                  ? "Replace ID Card"
                                  : "Upload ID (PDF/JPG)",
                              style: GoogleFonts.lato(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  elevation: 0,
                  onPressed: () => Navigator.pop(context),
                  minWidth: size.width * .31,
                  height: size.height * .045,
                  color: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                MaterialButton(
                  elevation: 0,
                  onPressed: () {
                    if (!_formKey.currentState!.validate() ||
                        _selected == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill in all required fields."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    context.read<ProfileBloc>().add(
                      RegisterIdentityDetailsEvent(
                        studentId: _id.text.trim(),
                        department: _selected!,
                        currentYear: int.parse(_year.text.trim()),
                        yearOfGraduation: int.parse(_graduation.text.trim()),
                        mentorName: _mentorName.text.trim(),
                        idCardPhoto: _file?.path ?? (_currentIdCardUrl ?? ""),
                      ),
                    );
                  },
                  minWidth: size.width * .5,
                  height: size.height * .05,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    "Save changes",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
