import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sairam_incubation/Auth/Model/media_items.dart';
import 'package:sairam_incubation/Utils/add_media.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

File? file;

class _PortfolioPageState extends State<PortfolioPage> {
  final TextEditingController _linkedIn = TextEditingController();
  final TextEditingController _gitHub = TextEditingController();
  List<MediaItems> mediaList = [];
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  Future<void> requestPermission() async {
    await [
      Permission.camera,
      Permission.photos,
      Permission.mediaLibrary,
      Permission.storage,
    ].request();
  }

  Future<void> _openPhoneStorage() async {
    await requestPermission();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File selectedFile = File(pickedFile.path);
      if (!mounted) return;
      final result = await Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: AddMedia(file: selectedFile),
        ),
      );
      if (result != null && result is MediaItems) {
        setState(() {
          mediaList.add(result);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _textField(
                      controller: _linkedIn,
                      hintText: "Linked In",
                      validator: (v) => null,
                    ),
                    SizedBox(height: size.height * .03),
                    _textField(
                      controller: _gitHub,
                      hintText: "GitHub",
                      validator: (v) => null,
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
                      onPressed: () {
                        // Bottom Sheet
                        final TextEditingController _title =
                            TextEditingController();
                        final TextEditingController _links =
                            TextEditingController();
                        showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          isScrollControlled: true,
                          barrierColor: Colors.grey.withValues(alpha: .2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          builder: (_) => BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(
                                  context,
                                ).viewInsets.bottom,
                              ),
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  width: double.infinity,
                                  height: size.height * .4,
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
                                        padding: EdgeInsets.symmetric(
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
                                            Spacer(),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(Icons.close),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: size.height * .03),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Form(
                                          key: _key,
                                          child: Column(
                                            children: [
                                              _textField(
                                                controller: _title,
                                                hintText: "Title",
                                                validator: (v) => null,
                                              ),
                                              SizedBox(
                                                height: size.height * .015,
                                              ),
                                              _textField(
                                                controller: _links,
                                                hintText: "Links",
                                                validator: (v) => null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: size.height * .03),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10,),
                                            child: MaterialButton(
                                              onPressed: () {},
                                              elevation: 0,
                                              color: Colors.grey[100]!,
                                              minWidth: size.width * .3,
                                              height: size.height * .05,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text("Cancel"),
                                            ),
                                          ),
                                          SizedBox(height: size.height * .03),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: MaterialButton(
                                              onPressed: () {
                                                if (_key.currentState!.validate()) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              color: Colors.blue,
                                              minWidth: size.width * .45,
                                              height: size.height * .05,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Text(
                                                "Save changes",
                                                style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                ),
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
                      },
                      color: Colors.white,
                      minWidth: size.width * .3,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.blue),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.blue),
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
              SizedBox(height: size.height * .03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
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

              //Adding the preview card  of the Media Files
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
                      final result = await Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: AddMedia(file: sourcePath),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          final index = mediaList.indexOf(item);
                          mediaList[index] = result;
                        });
                      }
                    }
                  },
                  () {
                    setState(() {
                      mediaList.remove(item);
                    });
                  },
                ),
              ),
              SizedBox(height: size.height * .03),

              //Media Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        _openPhoneStorage();
                      },
                      color: Colors.white,
                      minWidth: size.width * .3,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.blue),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.blue),
                          Text(
                            "Add Media",
                            style: GoogleFonts.lato(
                              color: Colors.blue,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: size.height * .03),
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
        fillColor: Colors.grey.withValues(alpha: .1),
        filled: true,
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
          padding: EdgeInsets.all(15),
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
                    icon: Icon(Icons.edit, color: Colors.grey),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.close, color: Colors.grey),
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
