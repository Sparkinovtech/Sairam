import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sairam_incubation/Profile/Model/domains.dart';
import 'package:sairam_incubation/Profile/bloc/profile_bloc.dart';
import 'package:sairam_incubation/Profile/bloc/profile_event.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Utils/Loader/loading_screen.dart';
import 'package:sairam_incubation/Utils/work_preference_dorp_down_field.dart';

class SkillSet extends StatefulWidget {
  const SkillSet({super.key});

  @override
  State<SkillSet> createState() => _SkillSetState();
}

class _SkillSetState extends State<SkillSet> {
  bool _isExpanded = false;
  bool _initialized = false;
  List<Domains> _selectedSkills = [];
  File? _file;
  String? _resumeUrl;
  String? _pickedFileExtension;

  Future<void> _pickResumeFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'], // extend if needed
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _file = File(result.files.single.path!);
        _pickedFileExtension = result.files.single.extension?.toLowerCase();
        _resumeUrl = null; // reset remote url if local file picked
      });
    }
  }

  @override
  void dispose() {
    _file = null;
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

        if (state is SkillSetDoneState) {
          // Close the screen after successful update
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final profile = state.profile;

        if (!_initialized && profile != null) {
          _selectedSkills = profile.skillSet ?? [];
          _resumeUrl = profile.resume;
          _initialized = true;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Header with back button and title
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 22,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Skill Set",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expandable skills selector
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add your Skills",
                            style: GoogleFonts.lato(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_isExpanded)
                    Container(
                      margin: const EdgeInsets.fromLTRB(30, 25, 20, 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: buildSelectableListWithChips<Domains>(
                        options: Domains.values,
                        selectedOptions: _selectedSkills,
                        labelBuilder: (domain) => domain.domainName,
                        onSelectionChanged: (updated) =>
                            setState(() => _selectedSkills = updated),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // Resume section
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Text(
                              "Resume",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 25,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Resume preview or filename for PDF
                            if (_file != null &&
                                _pickedFileExtension != null &&
                                [
                                  'jpg',
                                  'jpeg',
                                  'png',
                                ].contains(_pickedFileExtension)) ...[
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 4,
                                margin: const EdgeInsets.only(bottom: 20),
                                color: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _file!,
                                    width: double.infinity,
                                    height: size.height * .35,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ] else if (_file != null &&
                                _pickedFileExtension == 'pdf') ...[
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 4,
                                margin: const EdgeInsets.only(bottom: 20),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.picture_as_pdf,
                                        size: 32,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _file!.path.split('/').last,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ] else if ((_file == null) &&
                                _resumeUrl != null &&
                                _resumeUrl!.isNotEmpty) ...[
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                                margin: const EdgeInsets.only(bottom: 20),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.description,
                                        color: Colors.blue,
                                        size: 30,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          "View current resume",
                                          style: GoogleFonts.lato(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            MaterialButton(
                              elevation: 0,
                              onPressed: _pickResumeFile,
                              minWidth: double.infinity,
                              height: size.height * .05,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: Colors.blue),
                              ),
                              splashColor: Colors.white.withOpacity(.7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.file_upload_outlined,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: size.width * .02),
                                  Text(
                                    (_file != null ||
                                            (_resumeUrl != null &&
                                                _resumeUrl!.isNotEmpty))
                                        ? "Replace Resume"
                                        : "Upload Resume (pdf/.jpeg/.jpg/.png)",
                                    style: GoogleFonts.lato(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
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
                ],
              ),
            ),
          ),

          // Save button Bottom Bar
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: MaterialButton(
              onPressed: () {
                context.read<ProfileBloc>().add(
                  RegisterSkillSetEvent(
                    domains: _selectedSkills,
                    resumeFile: _file?.path ?? (_resumeUrl ?? ""),
                  ),
                );
              },
              minWidth: double.infinity,
              height: size.height * .05,
              color: Colors.blue.withOpacity(.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              splashColor: Colors.white.withOpacity(.6),
              child: Text(
                "Save",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
