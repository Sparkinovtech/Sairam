import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SkillSet extends StatefulWidget {
  const SkillSet({super.key});

  @override
  State<SkillSet> createState() => _SkillSetState();
}

class _SkillSetState extends State<SkillSet> {
  bool _isExpanded = false;
  List<String> _selectedSkills = [];
  final List<String> _options = [
    "Graphics Designer",
    "UI/UX Designer",
    "Web Developer",
    "Mobile Application Developer",
    "Architecture Designer",
    "Machine Learning",
    "Prompt Engineer",
    "3D Model Development",
    "ARVR Development",
    "Marketing Management",
    "Ruby On Rails Developer",
    "Others",
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 22),
                    child: Row(
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30 , vertical: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Skill Set",style: GoogleFonts.lato(color: Colors.black,fontSize: 27,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Add your Skills",style: GoogleFonts.lato(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                      Icon(_isExpanded ?  Icons.keyboard_arrow_up:  Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
              if(_isExpanded)
                Container(
                  margin: EdgeInsets.fromLTRB(30, 25, 20, 30),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ListView.builder(
                    shrinkWrap:true,
                    itemCount: _options.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context , index){
                      final option  = _options[index];
                      final selected = _selectedSkills.contains(option);
                      return ListTile(
                        title: Text(option,style: GoogleFonts.lato(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),),
                        trailing: selected ? Icon(Icons.check , color: Colors.green,) : null,
                        onTap: (){
                          setState(() {
                            if(selected){
                              _selectedSkills.remove(option);
                            }else{
                              _selectedSkills.add(option);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),

              // clip tags
              if(_selectedSkills.isNotEmpty)...[
                SizedBox(height: size.height * .03,),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedSkills.map((pref) => Chip(
                    label: Text(pref,style: GoogleFonts.lato(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w500),),
                    deleteIcon:Icon(Icons.close,color: Colors.black,),
                    onDeleted: () => setState(() => _selectedSkills.remove(pref)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.white,
                  )).toList(),
                ),
              ],

              SizedBox(height: size.height * .04,),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Text("Resume",style: GoogleFonts.inter(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30 , vertical: 25),
                    child: MaterialButton(
                        onPressed: (){},
                      minWidth: double.infinity,
                      height: size.height * .05,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      splashColor: Colors.white.withOpacity(.7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.file_upload_outlined,color: Colors.white,),
                          SizedBox(width: size.width * .02,),
                          Text("Upload Resume (pdf/.jpeg)",style: GoogleFonts.lato( color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30 , vertical: 30),
        child: MaterialButton(
          onPressed: (){
            Navigator.pop( context , _selectedSkills);
          },
          minWidth: double.infinity,
          height: size.height * .05,
          color: Colors.blue.withOpacity(.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          splashColor: Colors.white.withOpacity(.6),
          child: Text("Save",style: GoogleFonts.inter(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),),
        ),
      ),
    );
  }
}
