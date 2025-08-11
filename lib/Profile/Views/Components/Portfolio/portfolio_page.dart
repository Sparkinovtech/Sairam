import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

import 'package:sairam_incubation/Profile/Model/media_items.dart';
import 'package:sairam_incubation/Profile/bloc/profile_bloc.dart';
import 'package:sairam_incubation/Profile/bloc/profile_event.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Utils/Loader/loading_screen.dart';
import 'package:sairam_incubation/Profile/Views/Components/Portfolio/add_media.dart';
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
    await [
      Permission.camera,
      Permission.photos,
      Permission.mediaLibrary,
      Permission.storage,
    ].request();
  }

  Future<void> _openPhoneStorage(BuildContext context) async {
    await requestPermission();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File selectedFile = File(pickedFile.path);
      if (!context.mounted) return;
      final result = await Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: AddMedia(file: selectedFile),
        ),
      );
      if (result != null && result is MediaItems) {
        if (!context.mounted) return;
        context.read<ProfileBloc>().add(
          AddPortfolioMediaEvent(mediaItem: result),
        );
      }
    }
  }

  Future<Link?> _showAddLinkSheet(
    BuildContext context,
    double sizeHeight,
    double sizeWidth,
  ) async {
    final TextEditingController title = TextEditingController();
    final TextEditingController links = TextEditingController();

    final result = await showModalBottomSheet<Link>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: Colors.grey.withValues(alpha: 0.2),
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
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: sizeHeight * .4,
              decoration: const BoxDecoration(
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
                            Navigator.pop(context, null);
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
                            validator: null,
                          ),
                          SizedBox(height: sizeHeight * .015),
                          _textField(
                            controller: links,
                            hintText: "Links",
                            validator: null,
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
                            Navigator.pop(context, null);
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
                            if ((_formKey.currentState?.validate() ?? true)) {
                              final link = Link(
                                linkName: title.text,
                                link: links.text,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Added Link")),
                              );
                              Navigator.pop(context, link);
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
        if (state is PortfolioDoneState) {
          if (mounted) Navigator.of(context).pop();
        }
        if (state is ProfileErrorState) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        }
      },
      builder: (context, state) {
        final profile = state.profile;
        final List<Link> linkList = profile?.links ?? [];
        final List<MediaItems> mediaList = profile?.mediaList ?? [];

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
                          onPressed: () => Navigator.pop(context),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        MaterialButton(
                          onPressed: () async {
                            final newLink = await _showAddLinkSheet(
                              context,
                              size.height,
                              size.width,
                            );
                            if (newLink != null) {
                              if (!context.mounted) return;
                              context.read<ProfileBloc>().add(
                                AddPortfolioLinkEvent(link: newLink),
                              );
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
                      children: const [
                        Text(
                          "Media",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .02),
                  ...mediaList.map(
                    (item) => _mediaData(
                      context,
                      item,
                      () async {
                        final image = ImagePicker();
                        final picker = await image.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (picker != null) {
                          final File sourcePath = File(picker.path);
                          if (!context.mounted) return;
                          final result = await Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: AddMedia(file: sourcePath),
                            ),
                          );
                          if (result != null && result is MediaItems) {
                            if (!context.mounted) return;
                            context.read<ProfileBloc>().add(
                              UpdatePortfolioMediaEvent(mediaItem: result),
                            );
                          }
                        }
                      },
                      () {
                        context.read<ProfileBloc>().add(
                          DeletePortfolioMediaEvent(mediaItem: item),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: size.height * .03),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        MaterialButton(
                          onPressed: () => _openPhoneStorage(context),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: MaterialButton(
                      elevation: 0,
                      onPressed: () {
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
                  SizedBox(height: size.height * .04),
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
    String? Function(String?)? validator,
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
        fillColor: Colors.grey.withValues(alpha: 0.1),
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
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Could not open link")),
            );
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

    final imagePath = item.file.path;

    final bool isNetwork = imagePath.startsWith('http');
    ImageProvider displayImage = isNetwork
        ? NetworkImage(imagePath)
        : FileImage(File(imagePath));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: GestureDetector(
        onTap: () async {
          if (isNetwork) {
            await _downloadAndOpenFile(imagePath);
          } else {
            await OpenFilex.open(imagePath);
          }
        },
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
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
                  child: Image(
                    image: displayImage,
                    width: size.width * .25,
                    height: size.height * .1,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: size.width * .25,
                      height: size.height * .1,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
