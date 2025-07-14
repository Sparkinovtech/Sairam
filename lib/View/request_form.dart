import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Profile/Model/profile.dart';
import 'package:sairam_incubation/Utils/bottom_nav_bar.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final List<String> _list = [
    "The Principal",
    "The Head of the Department",
    "The Dean Innovation",
    "The Trusty",
  ];
  final List<String> _stay = ["Evening Stay", "Night Stay"];

  String? type;
  bool _isToggled = false;
  String? selected;
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: BottomNavBar(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Request Form",
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * .04),
              Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      _dropField(
                        hintText: "To",
                        selectedValue: selected,
                        list: _list,
                        onChange: (val) {
                          setState(() {
                            selected = val;
                          });
                        },
                      ),
                      SizedBox(height: size.height * .03),
                      _textField(
                        controller: _dataController,
                        hintText: "Date",
                        text: TextInputType.text,
                      ),
                      SizedBox(height: size.height * .03),
                      _textField(
                        controller: _reasonController,
                        hintText: "Reason",
                        text: TextInputType.text,
                      ),
                      SizedBox(height: size.height * .04),

                      _dropField(
                        hintText: "Type of Stay",
                        selectedValue: type,
                        list: _stay,
                        onChange: (val) {
                          setState(() {
                            type = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * .04),
              Column(
                children: [
                  SizedBox(height: size.height * .03),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hosteler",
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _toggleButton(
                          isToggled: _isToggled,
                          onChange: (val) {
                            setState(() {
                              _isToggled = val;
                            });
                          },
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
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: MaterialButton(
          elevation: 0,
          onPressed: () {},
          color: Colors.blue,
          minWidth: double.infinity,
          height: size.height * .05,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "Submit",
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropField({
    required String hintText,
    required String? selectedValue,
    required List<String> list,
    required ValueChanged<String?> onChange,
  }) {
    return DropdownButtonFormField<String>(
      onChanged: onChange,
      value: list.contains(selectedValue) ? selectedValue : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: Colors.grey,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.all(14),
        fillColor: Colors.grey.withValues(alpha: .1),
        filled: true,
      ),
      items: list.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: text,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: GoogleFonts.inter(
          color: Colors.grey,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        hintText: hintText,
        contentPadding: EdgeInsets.all(14),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: .1),
      ),
    );
  }

  Widget _toggleButton({
    required bool isToggled,
    required ValueChanged<bool> onChange,
  }) {
    return Switch(
      value: isToggled,
      onChanged: onChange,
      activeColor: Colors.blue,
      inactiveThumbColor: Colors.blue,
      inactiveTrackColor: Colors.white,
    );
  }
}
