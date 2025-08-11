import 'dart:developer' as devtools show log;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
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
  int? _currentYear;
  int? _graduationYear;
  final TextEditingController _mentorName = TextEditingController();
  bool _initialized = false;

  File? _file;
  String? _currentIdCardUrl;
  String? _pickedFileName;

  Future<void> requestPermission() async {
    await [
      Permission.phone,
      Permission.storage,
      Permission.photos,
      Permission.camera,
    ].request();
  }

  Future<void> _pickFile() async {
    await requestPermission();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _file = File(result.files.single.path!);
        _pickedFileName = result.files.single.name;
        _currentIdCardUrl = null;
      });
    }
  }

  void _calculateGraduationYear() {
    if (_currentYear != null) {
      int now = DateTime.now().year;
      int remainingYears = (5 - _currentYear!) + 1;
      _graduationYear = now + remainingYears - 1;
    }
  }

  @override
  void dispose() {
    _id.dispose();
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
          _currentYear = profile.currentYear;
          _graduationYear = profile.yearOfGraduation;
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
                              decoration: _inputDecoration("Student Id"),
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
                              decoration: _inputDecoration("Select Department"),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: Department.values
                                  .map(
                                    (dept) => DropdownMenuItem(
                                      value: dept,
                                      child: Text(dept.departmentName),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: size.height * .03),
                          labelledField(
                            "Current Year",
                            DropdownButtonFormField<int>(
                              value: _currentYear,
                              validator: (val) =>
                                  val == null ? "Select Current Year" : null,
                              onChanged: (val) {
                                setState(() {
                                  _currentYear = val;
                                  _calculateGraduationYear();
                                });
                              },
                              decoration: _inputDecoration("Select Year"),
                              items: List.generate(5, (index) => index + 1)
                                  .map(
                                    (year) => DropdownMenuItem(
                                      value: year,
                                      child: Text("$year"),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: size.height * .03),
                          labelledField(
                            "Year of Graduation",
                            DropdownButtonFormField<int>(
                              value: _graduationYear,
                              onChanged: null, // read-only
                              decoration: _inputDecoration("Graduation Year"),
                              items: _graduationYear != null
                                  ? [
                                      DropdownMenuItem(
                                        value: _graduationYear,
                                        child: Text("$_graduationYear"),
                                      ),
                                    ]
                                  : [],
                            ),
                          ),
                          SizedBox(height: size.height * .03),
                          labelledField(
                            "Mentor Name",
                            TextFormField(
                              controller: _mentorName,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? "Enter the Mentor Name"
                                  : null,
                              decoration: _inputDecoration("Mentor Name"),
                              cursorColor: Colors.grey,
                            ),
                          ),
                          SizedBox(height: size.height * .03),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Id Proof",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * .02),

                          // PREVIEW
                          if (_file != null)
                            _buildFilePreview(size, _file!.path),
                          if (_file == null &&
                              _currentIdCardUrl != null &&
                              _currentIdCardUrl!.isNotEmpty)
                            _buildNetworkFilePreview(size, _currentIdCardUrl!),

                          MaterialButton(
                            elevation: 0,
                            onPressed: _pickFile,
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
                                  ? "Replace ID Proof"
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
              children: [
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  color: Colors.grey[200],
                  minWidth: size.width * .3,
                  child: Text("Cancel"),
                ),
                SizedBox(width: 10),
                MaterialButton(
                  color: Colors.blue,
                  minWidth: size.width * .5,
                  onPressed: () {
                    if (!_formKey.currentState!.validate() ||
                        _selected == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all required fields."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    context.read<ProfileBloc>().add(
                      RegisterIdentityDetailsEvent(
                        studentId: _id.text.trim(),
                        department: _selected!,
                        currentYear: _currentYear!,
                        yearOfGraduation: _graduationYear!,
                        mentorName: _mentorName.text.trim(),
                        idCardPhoto: _file?.path ?? (_currentIdCardUrl ?? ""),
                      ),
                    );
                  },
                  child: Text(
                    "Save changes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.grey.withValues(alpha: 0.1),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.all(12),
  );

  Widget _buildFilePreview(Size size, String path) {
    if (path.toLowerCase().endsWith(".pdf")) {
      return GestureDetector(
        onTap: () => OpenFilex.open(path),
        child: Card(
          child: Container(
            height: size.height * .1,
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _pickedFileName ?? "PDF File",
                    style: GoogleFonts.lato(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => OpenFilex.open(path),
        child: Card(
          child: Image.file(
            File(path),
            height: size.height * .35,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  Future<void> _downloadAndOpenFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();

        final fileName = url.split('/').last;
        final file = File('${tempDir.path}/$fileName');

        await file.writeAsBytes(bytes);

        await OpenFilex.open(file.path);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to download file")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error opening file: $e")));
    }
  }

  Widget _buildNetworkFilePreview(Size size, String url) {
    devtools.log("Url for the id proof is : $url");
    if (url.toLowerCase().endsWith(".pdf")) {
      return GestureDetector(
        onTap: () => _downloadAndOpenFile(url), // call new helper
        child: Card(
          child: Container(
            height: size.height * .1,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "PDF File",
                    style: GoogleFonts.lato(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // For images
      return GestureDetector(
        onTap: () => _downloadAndOpenFile(url), // call new helper as well
        child: Card(
          child: Image.network(
            url,
            height: size.height * .35,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) =>
                Center(child: Text('Could not load image')),
          ),
        ),
      );
    }
  }
}
