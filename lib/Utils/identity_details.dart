import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IdentityDetails extends StatefulWidget {
  const IdentityDetails({super.key});

  @override
  State<IdentityDetails> createState() => _IdentityDetailsState();
}

class _IdentityDetailsState extends State<IdentityDetails> {
  String? _selected;

  final List<String> _option = [
    "Computer Science and Engineering",
    "Information Technology",
    "Internet Of Things(IOT)",
    "Artificial Intelligence And Data Science",
    "Artificial Intelligence And Machine Learning",
    "Cyber Security",
    "Computer Science And Business Systems",
    "Computer Science And Communication Engineering",
    "Electronics And Communication Engineering",
    "Electrical And Electronics Engineering",
    "Mechanical Engineering",
  ];

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _year = TextEditingController();
  final TextEditingController _graduation = TextEditingController();
  final TextEditingController _mentorName = TextEditingController();

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
              SizedBox(height: size.height * .01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Identity Details",
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * .03),
              Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      _textField(
                        controller: _id,
                        hintText: "Student Id",
                        validator: (v) => v == null || v.isEmpty
                            ? "Enter the Student Id"
                            : null,
                        type: TextInputType.text,
                      ),
                      SizedBox(height: size.height * .03),
                      _dropDownButtonField(
                        hintText: "Department",
                        selectedValue: _selected,
                        options: _option,
                        onChange: (val) => setState(() => _selected = val),
                      ),
                      SizedBox(height: size.height * .03),
                      _textField(
                        controller: _year,
                        hintText: "Current Year",
                        validator: (v) => v == null || v.isEmpty
                            ? "Enter the Current Year"
                            : null,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: size.height * .03),
                      _textField(
                        controller: _graduation,
                        hintText: "Year of Graduation",
                        validator: (v) => v == null || v.isEmpty
                            ? "Enter the Graduation"
                            : null,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: size.height * .03),
                      _textField(
                        controller: _mentorName,
                        hintText: "Mentor Name",
                        validator: (v) => v == null || v.isEmpty
                            ? "Enter the Mentor Name"
                            : null,
                        type: TextInputType.name,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * .03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  children: [
                    Text(
                      "Id Proof",
                      style: GoogleFonts.lato(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * .03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: MaterialButton(
                  elevation: 0,
                  onPressed: () {},
                  minWidth: double.infinity,
                  height: size.height * .05,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.blue),
                  ),
                  child: Text(
                    "Upload ID (PDF/JPG)",
                    style: GoogleFonts.lato(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: MaterialButton(
              elevation: 0,
              onPressed: () {},
              minWidth: size.width * .31,
              height: size.height * .045,
              color: Colors.grey[200]!,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                "Cancel",
                style: GoogleFonts.lato(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: MaterialButton(
              elevation: 0,
              onPressed: () {},
              minWidth: size.width * .5,
              height: size.height * .05,
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                "Save changes",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    required TextInputType type,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.grey.withValues(alpha: .1),
        filled: true,
      ),
    );
  }

  Widget _dropDownButtonField({
    required String hintText,
    required String? selectedValue,
    required List<String> options,
    required ValueChanged<String?> onChange,
  }) {
    return DropdownButtonFormField<String>(
      value: options.contains(selectedValue) ? selectedValue : null,
      isExpanded: true,
      onChanged: onChange,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.all(12),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: .1),
      ),
      items: options.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }
}
