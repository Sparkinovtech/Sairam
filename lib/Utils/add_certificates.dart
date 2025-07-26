import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import "package:intl/intl.dart";
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sairam_incubation/Profile/bloc/profile_bloc.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Utils/Loader/loading_screen.dart';
import 'package:sairam_incubation/Utils/certificate_page.dart';
class AddCertificates extends StatefulWidget {
  final String hintText;
  final Function(DateTime)? onDateSelected;
  const AddCertificates({
    super.key,
    required this.hintText,
    this.onDateSelected,
  });
  @override
  State<AddCertificates> createState() => _AddCertificatesState();
}

class _AddCertificatesState extends State<AddCertificates> {
  bool _initialized = false;
  DateTime? _selectedDate;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  File? file;
  Future<void> _pickMonthYear(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.blue,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.text = DateFormat("MM/yyyy").format(picked);
      });
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked);
      }
    }
  }

  Future<void> requestPermission() async {
    await [
      Permission.photos,
      Permission.storage,
      Permission.camera,
      Permission.accessMediaLocation,
    ].request();
  }

  Future<void> _openPhoneStorage() async {
    await requestPermission();
    final picker = ImagePicker();
    final pickerStorage = await picker.pickImage(source: ImageSource.gallery);

    if (pickerStorage != null) {
      setState(() {
        file = File(pickerStorage.path);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
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

        if (state is CertificateDoneState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final profile = state.profile;
        if (!_initialized && profile != null) {
          _initialized = true;
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Text(
                          "Add certificates",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 27,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _key,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * .03),

                          Row(
                            children: [
                              Text(
                                "Certificate Name",
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * .03),
                          _buildTextField(
                            controller: _nameController,
                            hintText: "Enter the Name of the Certificate",
                            validator: (v) => v == null || v.isEmpty
                                ? "Enter the Certificate Name"
                                : null,
                          ),
                          SizedBox(height: size.height * .05),
                          Row(
                            children: [
                              Text(
                                "Expiration Period",
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * .03),
                          _buildMonthYearField(
                            controller: _controller,
                            hintText: widget.hintText,
                            onTap: () => _pickMonthYear(context),
                            icon: Icons.date_range,
                            validator: (v) => v == null || v.isEmpty
                                ? "Select the Expiration Period"
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * .04),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (file != null) ...[
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.only(bottom: 20),
                            color: Colors.white,
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
                          onPressed: () {
                            _openPhoneStorage();
                          },
                          minWidth: size.width * .7,
                          height: size.height * .05,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.blue, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.upload, color: Colors.blue),
                              ),
                              Text(
                                "Upload certificate (.jpg / .pdf)",
                                style: GoogleFonts.lato(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.grey[100],
                  minWidth: size.width * .4,
                  height: size.height * .05,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: size.width * .03),
                MaterialButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: CertificatePage(),
                        ),
                      );
                    }
                  },
                  color: Colors.blue,
                  minWidth: size.width * .4,
                  height: size.height * .05,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Save Changes",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      cursorColor: Colors.grey,
      keyboardType: TextInputType.text,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.grey.withOpacity(.1),
        filled: true,
      ),
    );
  }

  Widget _buildMonthYearField({
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onTap,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.grey.withOpacity(.1),
        filled: true,
        suffixIcon: Icon(icon, color: Colors.grey),
      ),
    );
  }
}
