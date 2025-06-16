import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/View/home_page.dart';
class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final TextEditingController _dataController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(.4),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(onPressed: (){
                    Navigator.pushReplacement(context,PageTransition(type: PageTransitionType.fade , child: HomePage()));
                    }, icon: Icon(Icons.arrow_back_ios)),
                ],
              ),
            ),
            Center(
              child: Text("Stay Request",style: GoogleFonts.inter(fontSize: 26,fontWeight: FontWeight.bold,color: Colors.black),),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30 , vertical: 20),
              child: Form(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      items: ["The HOD", "The Principal",""].map((String name){
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Text(name),
                        );
                      }).toList(),
                      onChanged: (value){},
                      decoration: InputDecoration(
                        labelText: "TO",
                        labelStyle: GoogleFonts.inter(fontSize: 13 , fontWeight: FontWeight.w500,color: Colors.black),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: size.height * .03,),
                    TextFormField(
                      controller: _dataController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Date",
                        labelStyle: GoogleFonts.inter(fontSize: 13 , fontWeight: FontWeight.w500,color: Colors.black),
                        suffixIcon: IconButton(
                            onPressed: (){

                            }, icon: Icon(CupertinoIcons.calendar)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
