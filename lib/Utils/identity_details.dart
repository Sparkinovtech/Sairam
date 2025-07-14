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

File? file;

class _IdentityDetailsState extends State<IdentityDetails> {
  Department? _selected;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _year = TextEditingController();
  final TextEditingController _graduation = TextEditingController();
  final TextEditingController _mentorName = TextEditingController();
  bool _initialized = false;

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
        file = File(pickedSource.path);
      });
    }
  }

  @override
  void dispose() {
    _id.dispose();
    _year.dispose();
    _graduation.dispose();
    _mentorName.dispose();
    file = null;

    super.dispose();
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

        if (state is IdentityDetailsDoneState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final profile = state.profile;
        if (!_initialized && profile != null) {
          _selected = profile.department;
          _id.text = profile.id ?? "";
          _year.text = profile.currentYear == null
              ? ""
              : profile.currentYear.toString();
          _graduation.text = profile.yearOfGraduation == null
              ? ""
              : profile.yearOfGraduation.toString();
          _mentorName.text = profile.currentMentor ?? "";
          _initialized = true;
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .01),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Identity Details",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .03),
                  Form(
                    key: _key,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          _textField(
                            controller: _id,
                            hintText: "Student Id",
                            validator: (v) => v == null || v.isEmpty
                                ? "Enter the Student Id"
                                : null,
                            type: TextInputType.text,
                          ),
                          SizedBox(height: size.height * .03),
                          _dropDownButtonField<Department>(
                            hintText: "Department",
                            selectedValue: _selected,
                            options: Department.values.toList(),
                            validator: (val) => val == null
                                ? "Please Select a Department"
                                : null,
                            onChange: (val) => setState(() => _selected = val),
                            itemLabelBuilder: (department) =>
                                department.departmentName,
                          ),
                          SizedBox(height: size.height * .03),
                          _textField(
                            controller: _year,
                            hintText: "Current Year",
                            validator: (v) => v == null || v.isEmpty
                                ? "Enter the Current Year"
                                : null,
                            type: TextInputType.number,
                          ),
                          SizedBox(height: size.height * .03),
                          _textField(
                            controller: _graduation,
                            hintText: "Year of Graduation",
                            validator: (v) => v == null || v.isEmpty
                                ? "Enter the Graduation"
                                : null,
                            type: TextInputType.number,
                          ),
                          SizedBox(height: size.height * .03),
                          _textField(
                            controller: _mentorName,
                            hintText: "Mentor Name",
                            validator: (v) => v == null || v.isEmpty
                                ? "Enter the Mentor Name"
                                : null,
                            type: TextInputType.name,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * .03),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: Row(
                      children: [
                        Text(
                          "Id Proof",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .03),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (file != null) ...[
                          Card(
                            color: Colors.white,
                            margin: EdgeInsets.only(bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                file!,
                                width: double.infinity,
                                height: size.height * .35,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                        MaterialButton(
                          elevation: 0,
                          onPressed: () {
                            _openPhoneStorage();
                          },
                          minWidth: double.infinity,
                          height: size.height * .05,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.blue),
                          ),
                          child: Text(
                            file != null
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
                ],
              ),
            ),
          ),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: MaterialButton(
                  elevation: 0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  minWidth: size.width * .31,
                  height: size.height * .045,
                  color: Colors.grey[200]!,
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
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: MaterialButton(
                  elevation: 0,
                  onPressed: () {
                    if (_id.text.isEmpty ||
                        _graduation.text.isEmpty ||
                        _year.text.isEmpty ||
                        _mentorName.text.isEmpty ||
                        _selected == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please fill in all required fields."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    context.read<ProfileBloc>().add(
                      RegisterIdentityDetailsEvent(
                        studentId: _id.text,
                        department: _selected!,
                        currentYear: int.parse(_year.text),
                        yearOfGraduation: int.parse(_graduation.text),
                        mentorName: _mentorName.text,
                        idCardPhoto: "",
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    required TextInputType type,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.grey.withValues(alpha: .1),
        filled: true,
      ),
    );
  }

  Widget _dropDownButtonField<T>({
    required String hintText,
    required T? selectedValue,
    required List<T> options,
    required String? Function(T?) validator,
    required ValueChanged<T?> onChange,
    required String Function(T) itemLabelBuilder,
  }) {
    return DropdownButtonFormField<T>(
      value: options.contains(selectedValue) ? selectedValue : null,
      isExpanded: true,
      validator: validator,
      onChanged: onChange,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.all(12),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.1),
      ),
      items: options.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemLabelBuilder(item), overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }
}
