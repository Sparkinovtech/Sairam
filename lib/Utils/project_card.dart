import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sairam_incubation/Utils/model/projects.dart';
class ProjectCard extends StatefulWidget {
  final List<Projects> projects;
  final String title;
  const ProjectCard({super.key, required this.projects , required this.title});
  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back_ios_new ,color: Colors.black,)),

                  Text(widget.title,
                    style: GoogleFonts.lato(color: Colors.black , fontSize: 23,fontWeight: FontWeight.w400),),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.projects.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 30),
                itemBuilder: (context ,index){
                  final item =  widget.projects[index];
                  return Card(
                    elevation: 10,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.blue[100]!,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: double.infinity,
                        height: size.height *.17,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue[100]!,
                              Colors.blue[200]!,
                              Colors.blue[300]!
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 40,
                              ),
                            ),
                            SizedBox(width: size.width * .03,),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name ,style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),),
                                  Text("Mentor:${item.mentor}",style: GoogleFonts.lato(color: Colors.grey , fontSize: 16,fontWeight: FontWeight.w400),),
                                  Text("Category:${item.category}",style: GoogleFonts.lato(color: Colors.grey ,fontSize: 16,fontWeight: FontWeight.w400),),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
