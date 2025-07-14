import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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

File? file;

class _SkillSetState extends State<SkillSet> {
  bool _isExpanded = false;
  bool _initialized = false;
  List<Domains>? _selectedSkills;

  Future<void> requestPermission() async {
    await [
      Permission.camera,
      Permission.storage,
      Permission.photos,
      Permission.accessMediaLocation,
    ].request();
  }

  Future<void> _openPhoneStorage() async {
    await requestPermission();
    final picker = ImagePicker();
    final pickedStorage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedStorage != null) {
      setState(() {
        file = File(pickedStorage.path);
      });
    }
  }

  @override
  void dispose() {
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

        if (state is SkillSetDoneState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final profile = state.profile;
        if (!_initialized && profile != null) {
          _selectedSkills = profile.skillSet ?? List.empty();
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 22,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 0,
                        ),
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
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: .1),
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
                        selectedOptions: _selectedSkills!,
                        labelBuilder: (domain) => domain.domainName,
                        onSelectionChanged: (updated) => setState(() {
                          _selectedSkills = updated;
                        }),
                      ),
                    ),
                  const SizedBox(height: 30),
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
                            if (file != null) ...[
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
                              onPressed: _openPhoneStorage,
                              minWidth: double.infinity,
                              height: size.height * .05,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: Colors.blue),
                              ),
                              splashColor: Colors.white.withValues(alpha: .7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.file_upload_outlined,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: size.width * .02),
                                  Text(
                                    file != null
                                        ? "Replace Resume"
                                        : "Upload Resume (pdf/.jpeg)",
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: MaterialButton(
              onPressed: () {
                context.read<ProfileBloc>().add(
                  RegisterSkillSetEvent(
                    domains: _selectedSkills!,
                    resumeFile: "",
                  ),
                );
              },
              minWidth: double.infinity,
              height: size.height * .05,
              color: Colors.blue.withValues(alpha: .6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              splashColor: Colors.white.withValues(alpha: .6),
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
