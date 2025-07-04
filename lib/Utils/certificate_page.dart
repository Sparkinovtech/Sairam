import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Utils/add_certificates.dart';
class CertificatePage extends StatefulWidget {
  const CertificatePage({super.key});

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 ,vertical: 10),
              child: Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
                ],
              ),
            ),
            SizedBox(height: size.height * .02,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Earned Certificates",style:
                      GoogleFonts.lato(color: Colors.black,fontSize: 27,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Add document or photos (.jpg / .pdf)",
                        style: GoogleFonts.lato(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                    ],
                  ),
                  SizedBox(height: size.height * .02,),
                  Row(
                    children: [
                      MaterialButton(
                        onPressed: (){
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade , child: AddCertificates(hintText: "mm/yyyy")));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                          side: BorderSide(color: Colors.blue , width: 1),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.add , color: Colors.blue,),
                            Text("Add Certificates",
                              style: GoogleFonts.lato(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.w500),),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
