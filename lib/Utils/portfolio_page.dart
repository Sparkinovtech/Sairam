import 'dart:io';
import 'dart:ui';
import 'dart:developer' as devtools; // import developer for logs
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sairam_incubation/Profile/Model/media_items.dart';
import 'package:sairam_incubation/Profile/bloc/profile_bloc.dart';
import 'package:sairam_incubation/Profile/bloc/profile_event.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Utils/Loader/loading_screen.dart';
import 'package:sairam_incubation/Utils/add_media.dart';
import 'package:sairam_incubation/Profile/Model/link.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> requestPermission() async {
    devtools.log(
      "Requesting permissions for camera, photos, mediaLibrary, storage",
    );
    await [
      Permission.camera,
      Permission.photos,
      Permission.mediaLibrary,
      Permission.storage,
    ].request();
    devtools.log("Permission request completed");
  }

  Future<void> _openPhoneStorage(BuildContext context) async {
    await requestPermission();
    devtools.log("Opening gallery for image picking...");
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File selectedFile = File(pickedFile.path);
      devtools.log("Picked image from gallery: ${pickedFile.path}");
      // TODO: Dispatch action to open AddMedia, await result, then dispatch AddMedia event on success
      final result = await Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: AddMedia(file: selectedFile),
        ),
      );
      devtools.log("Returned from AddMedia page with result: $result");
      if (result != null) {
        devtools.log("Dispatching AddPortfolioMediaEvent with new media item");
        // e.g. context.read<ProfileBloc>().add(AddPortfolioMediaEvent(result));
      }
    } else {
      devtools.log("No image picked from gallery");
    }
  }

  Future<Link?> _showAddLinkSheet(
    BuildContext context,
    double sizeHeight,
    double sizeWidth,
  ) async {
    devtools.log("Opening Add Link bottom sheet");
    final TextEditingController title = TextEditingController();
    final TextEditingController links = TextEditingController();

    final result = await showModalBottomSheet<Link>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: Colors.grey.withOpacity(0.2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              height: sizeHeight * .4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Add Links",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            devtools.log(
                              "Add Link sheet - Closed without saving",
                            );
                            Navigator.pop(
                              context,
                              null,
                            ); // Return null on close
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sizeHeight * .03),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _textField(
                            controller: title,
                            hintText: "Title",
                            validator: (v) =>
                                null, // TODO: Validation if desired
                          ),
                          SizedBox(height: sizeHeight * .015),
                          _textField(
                            controller: links,
                            hintText: "Links",
                            validator: (v) =>
                                null, // TODO: Validation if desired
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: sizeHeight * .03),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: MaterialButton(
                          onPressed: () {
                            devtools.log(
                              "Add Link sheet - Cancel button pressed",
                            );
                            Navigator.pop(
                              context,
                              null,
                            ); // Return null on cancel
                          },
                          elevation: 0,
                          color: Colors.grey[100]!,
                          minWidth: sizeWidth * .3,
                          height: sizeHeight * .05,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              devtools.log(
                                "Add Link sheet - Save changes pressed",
                              );
                              devtools.log(
                                "Adding link: Title='${title.text}', Links='${links.text}'",
                              );
                              final link = Link(
                                linkName: title.text,
                                link: links.text,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Added Link")),
                              );
                              Navigator.pop(
                                context,
                                link,
                              ); // Return the created link
                            }
                          },
                          color: Colors.blue,
                          minWidth: sizeWidth * .45,
                          height: sizeHeight * .05,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Save changes",
                            style: GoogleFonts.lato(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        devtools.log("ProfileBloc state changed: ${state.runtimeType}");
        if (state.isLoading) {
          devtools.log("LoadingScreen showing...");
          LoadingScreen().show(context: context, text: "Loading...");
        } else {
          devtools.log("LoadingScreen hiding...");
          LoadingScreen().hide();
        }
        if (state is PortfolioDoneState) {
          devtools.log("Portfolio saved successfully, popping PortfolioPage");
          Navigator.of(context).pop();
        }
        // TODO: handle other state changes as needed (show snackbar for error, etc)
      },
      builder: (context, state) {
        final profile = state.profile;
        final List<Link> linkList = profile?.links ?? [];
        final List<MediaItems> mediaList = profile?.mediaList ?? [];

        devtools.log(
          "Building PortfolioPage UI with ${linkList.length} links and ${mediaList.length} media items",
        );

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            devtools.log(
                              "Back button pressed, popping PortfolioPage",
                            );
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Text(
                          "Portfolio",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .03),
                  // Add link button + link list
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        MaterialButton(
                          onPressed: () async {
                            devtools.log("Add Link button pressed");
                            final newLink = await _showAddLinkSheet(
                              context,
                              size.height,
                              size.width,
                            );
                            devtools.log(
                              "Return from the method has the link $newLink",
                            );

                            if (newLink != null) {
                              devtools.log("Dispatching AddPortfolioLinkEvent");
                              context.read<ProfileBloc>().add(
                                AddPortfolioLinkEvent(link: newLink),
                              );
                            } else {
                              devtools.log("No link was added from the sheet");
                            }
                          },
                          color: Colors.white,
                          minWidth: size.width * .3,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.blue),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.add, color: Colors.blue),
                              Text(
                                "Add Link",
                                style: GoogleFonts.lato(
                                  color: Colors.blue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // List of existing links
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      children: linkList
                          .map((link) => _linkTile(context, link))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: size.height * .02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Media",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .02),
                  // Media preview cards
                  ...mediaList.map(
                    (item) => _mediaData(
                      context,
                      item,
                      () async {
                        devtools.log(
                          "Edit media button pressed for: ${item.title}",
                        );
                        final image = ImagePicker();
                        final picker = await image.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (picker != null) {
                          final File sourcePath = File(picker.path);
                          devtools.log(
                            "Picked new image for edit at: ${picker.path}",
                          );
                          final result = await Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: AddMedia(file: sourcePath),
                            ),
                          );
                          devtools.log(
                            "Returned from AddMedia page for edit with result: $result",
                          );
                          if (result != null) {
                            devtools.log(
                              "Dispatching event to update media item",
                            );
                            // TODO: Dispatch UpdatePortfolioMediaEvent with 'result'
                          }
                        } else {
                          devtools.log("No image picked for media edit");
                        }
                      },
                      () {
                        devtools.log(
                          "Delete media button pressed for: ${item.title}",
                        );
                        // TODO: Dispatch DeletePortfolioMediaEvent with 'item'
                      },
                    ),
                  ),
                  SizedBox(height: size.height * .03),
                  // Add media button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        MaterialButton(
                          onPressed: () {
                            devtools.log("Add Media button pressed");
                            _openPhoneStorage(context);
                          },
                          color: Colors.white,
                          minWidth: size.width * .3,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.blue),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.add, color: Colors.blue),
                              Text(
                                "Add Media",
                                style: GoogleFonts.lato(
                                  color: Colors.blue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .04),
                  // Save button: triggers portfolio registration/update
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: MaterialButton(
                      elevation: 0,
                      onPressed: () {
                        devtools.log(
                          "Save portfolio button pressed. Dispatching RegisterPortfolioEvent",
                        );
                        context.read<ProfileBloc>().add(
                          RegisterPortfolioEvent(
                            links: linkList,
                            mediaList: mediaList,
                          ),
                        );
                      },
                      height: size.height * .06,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Save",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
      ),
      validator: validator,
    );
  }

  Widget _linkTile(BuildContext context, Link link) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          final Uri uri = Uri.tryParse(link.link) ?? Uri();
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            devtools.log("Could not launch URL: ${link.link}");
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Could not open link")));
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      link.linkName,
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      link.link,
                      style: GoogleFonts.inter(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.grey),
                onPressed: () {
                  devtools.log(
                    "Delete link button pressed for link: ${link.linkName}",
                  );
                  context.read<ProfileBloc>().add(
                    DeletePortfolioLinkEvent(link: link),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mediaData(
    BuildContext context,
    MediaItems item,
    VoidCallback onEdit,
    VoidCallback onDelete,
  ) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        child: Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            children: [
              SizedBox(width: size.width * .04),
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  item.file,
                  width: size.width * .25,
                  height: size.height * .1,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: size.width * .03),
              Expanded(
                child: Text(
                  item.title.isNotEmpty ? item.title : "Untitled",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, color: Colors.grey),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.grey,
                    ), // Changed icon here
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
