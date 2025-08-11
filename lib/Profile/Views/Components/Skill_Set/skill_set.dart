import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sairam_incubation/Profile/Model/domains.dart';
import 'package:sairam_incubation/Profile/bloc/profile_bloc.dart';
import 'package:sairam_incubation/Profile/bloc/profile_event.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Utils/Loader/loading_screen.dart';
import 'package:sairam_incubation/Profile/Views/Components/Work_preference/work_preference_dorp_down_field.dart';

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
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _file = File(result.files.single.path!);
        _pickedFileExtension = result.files.single.extension?.toLowerCase();
        _resumeUrl = null;
      });
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
          const SnackBar(content: Text("Failed to download resume")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error opening resume: $e")));
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
                children: [
                  // Header
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
                    child: Text(
                      "Skill Set",
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Skills selector
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add your Skills",
                            style: GoogleFonts.lato(
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

                  // Resume section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Resume",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                        // Click to open local or remote resume
                        if (_file != null)
                          GestureDetector(
                            onTap: () => OpenFilex.open(_file!.path),
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                leading: Icon(
                                  _pickedFileExtension == 'pdf'
                                      ? Icons.picture_as_pdf
                                      : Icons.image,
                                  color: _pickedFileExtension == 'pdf'
                                      ? Colors.red
                                      : Colors.blue,
                                ),
                                title: Text(_file!.path.split('/').last),
                              ),
                            ),
                          )
                        else if (_resumeUrl != null && _resumeUrl!.isNotEmpty)
                          GestureDetector(
                            onTap: () => _downloadAndOpenFile(_resumeUrl!),
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                leading: const Icon(
                                  Icons.description,
                                  color: Colors.blue,
                                ),
                                title: const Text("View current resume"),
                              ),
                            ),
                          ),

                        // Upload/Replace button
                        MaterialButton(
                          onPressed: _pickResumeFile,
                          minWidth: double.infinity,
                          height: size.height * .05,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.blue),
                          ),
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
                                        (_resumeUrl?.isNotEmpty ?? false))
                                    ? "Replace Resume"
                                    : "Upload Resume (pdf/jpg/png)",
                                style: GoogleFonts.lato(
                                  color: Colors.blue,
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
            ),
          ),

          // Save button
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
              color: Colors.blue.withValues(alpha: .6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }
}
