import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Utils/bottom_nav_bar.dart';
import 'package:sairam_incubation/Utils/images.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? selectedTo;
  String? stayDuration = 'Evening stay';
  String? residenceType = 'Hosteler';
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
                    Navigator.pushReplacement(context,PageTransition(type: PageTransitionType.fade , child: BottomNavBar()));
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
                      readOnly: true,
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
                            onPressed: (){}, icon: Icon(CupertinoIcons.calendar)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * .03,),
            Expanded(
              child:Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(background),fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30) , topRight: Radius.circular(30)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(.9),
                          Colors.white.withOpacity(.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30) , topLeft: Radius.circular(30)),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 30 , vertical: 20),
                    child: Column(
                      children: [
                        SizedBox(height: size.height * .04,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description:",style: GoogleFonts.inter(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w500),),
                          ],
                        ),
                        SizedBox(height: size.height * .02,),
                        Card(
                          elevation: 15,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            height: size.height * .13,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                              controller: _descriptionController,
                              cursorColor: Colors.grey,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "Type here..",
                                hintStyle: GoogleFonts.inter(color: Colors.grey,fontSize: 12),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * .04,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Stay Duration:",style: GoogleFonts.inter(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                          ],
                        ),
                        SizedBox(height: size.height * .03,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildChoiceButton("Evening Stay", stayDuration == "Evening Stay", () => setState(() => stayDuration = "Evening Stay") , CupertinoIcons.sun_dust_fill ),
                            SizedBox(width: size.width * .04,),
                            _buildChoiceButton("Night Stay", stayDuration == "Night Stay", () => setState(() => stayDuration = "Night Stay"),CupertinoIcons.moon_stars_fill)
                          ],
                        ),
                        SizedBox(height: size.height * .06,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Text("Residence Type" , style: GoogleFonts.inter(fontSize:20,fontWeight: FontWeight.bold,color: Colors.black),),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * .03,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _residentButton("Hostler", residenceType == "Hostler", () => setState(() => residenceType = "Hostler")),
                            SizedBox(width: size.width * .04,),
                            _residentButton("Day Scholar", residenceType == "Day Scholar", () => setState(() => residenceType = "Day Scholar")),
                          ],
                        ),
                        SizedBox(height: size.height * .08,),
                        MaterialButton(
                          onPressed: (){

                          },
                          color: Color(0xFF2580C3),
                          minWidth: size.width * .8,
                          height: size.height * .05,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text("Submit",style: GoogleFonts.poppins(color: Colors.white , fontSize: 15,fontWeight: FontWeight.w500),),
                        ),
                        SizedBox(height: size.height * .02,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildChoiceButton(String text , bool isSelected , VoidCallback onTap , IconData icon){
    var size = MediaQuery.of(context).size;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? LinearGradient(
                colors:[
                  Colors.blue[600]!,
                  Colors.blue[300]!
                ]
            ) : LinearGradient(
                colors: [
                  Colors.grey[400]!,
                  Colors.grey[300]!,
                  Colors.grey[100]!,
                ]
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text , style: GoogleFonts.inter(color: isSelected ? Colors.white : Colors.black),),
              SizedBox(width:size.width * .02 ,),
              Icon(icon, color: isSelected ? Colors.white : Colors.black,),

            ],
          ),
        ),
      ),
    );
  }
  Widget _residentButton (String text  , bool isSelected , VoidCallback onTap){
    return Expanded(
      child: GestureDetector(
        onTap:onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            gradient: isSelected ? LinearGradient(
                colors:[
                  Colors.blue[600]!,
                  Colors.blue[300]!
                ]
            ) : LinearGradient(
                colors: [
                  Colors.grey[400]!,
                  Colors.grey[300]!,
                  Colors.grey[100]!,
                ]
            ),

            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(text , style: GoogleFonts.inter(color: isSelected ? Colors.white : Colors.black),),
          ),
        ),
      )
    );
  }
}
