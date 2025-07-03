import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sairam_incubation/Auth/Model/media_items.dart';
class AddMedia extends StatefulWidget {
  const AddMedia({ super.key ,  required this.file });
  final File file;

  @override
  State<AddMedia> createState() => _AddMediaState();
}

class _AddMediaState extends State<AddMedia> {
  final TextEditingController _title =  TextEditingController();
  final TextEditingController _description =  TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isImage = widget.file.path.endsWith('.jpg') || widget.file.path.endsWith('.png');
    return Scaffold(
    backgroundColor: Colors.white,
      body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
              Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
                child: Row(
                children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
                  ],
                ),
              ),
            SizedBox(height: size.height * .01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
              child: Row(
                children: [
                  Text("Add Media",style: GoogleFonts.lato(color: Colors.black,fontSize: 27,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            SizedBox(height: size.height * .03,),
            _mediaPreviewContainer(widget.file , context),
            SizedBox(height: size.height * .04,),
            Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    _textField(controller: _title, hintText: "Title", validator: (v) => v == null || v.isEmpty ? "Enter the title" : null ,  type: TextInputType.text),
                    SizedBox(height: size.height *.02,),
                    _textField(controller: _description, hintText: "Description", validator: (v) => v == null || v.isEmpty ?  "Enter the description": null, type: TextInputType.text),

                  ],
                ),
              ),
            )
          ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30  , vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MaterialButton(
              elevation: 0,
              onPressed: (){
                Navigator.pop(context);
              },
              color: Colors.grey[100],
              minWidth: size.width * .4,
              height: size.height * .06,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("Cancel",style: GoogleFonts.lato(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w700),),
            ),
            SizedBox(width: size.width * .04,),
            MaterialButton(
              elevation: 0,
              onPressed: (){
                if(_key.currentState!.validate()) {
                  final mediaItems = MediaItems(title: _title.text, file: widget.file);
                  Navigator.pop(context, mediaItems);
                }

              },
              color: Colors.blue,
              minWidth: size.width * .4,
              height: size.height * .06,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("Save Changes",style: GoogleFonts.lato(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w700),),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mediaPreviewContainer(File? file ,BuildContext context){
    var size =  MediaQuery.of(context).size;
    return Card(
      elevation: 10,
      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      child: Container(
        width: double.infinity,
        height: size.height * .3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.black,width: 1),
        ),
        child: file != null && !file!.path.endsWith('.jpg') || !file!.path.endsWith('.png') ? ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Image.file(file , width: double.infinity ,fit: BoxFit.cover,),
        ) : Center(
          child: Text("The Preview Image is not found  or Image not Supported",
            style: GoogleFonts.lato(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
        ),
      ),
    );
  }

  Widget _textField({required TextEditingController controller,
    required String hintText , required String? Function(String?) validator ,required TextInputType type}){
    return TextFormField(
      cursorColor: Colors.grey,
      keyboardType: type,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.withOpacity(.1),
        hintText: hintText,
        hintStyle: GoogleFonts.lato(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w600),
      ),
    );
  }
}
