import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sairam_incubation/Utils/model/teams.dart';

class TeamsPage extends StatefulWidget {
  // final List<Projects> projects;
  const TeamsPage({super.key});
  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Teams> availableTeams =[
    Teams(name: "Skoolinq", mentor: "Juno Bella", category: "Software", imagePath: ""),
    Teams(name: "Telepresence Robot", mentor: "Jayantha", category: "Hardware", imagePath: ""),
  ];
  final List<Teams> myTeam = [];
  void _showTeamPicker() async{
    final Teams? selected = await showModalBottomSheet<Teams>(context: context, builder: (_) {
       return ListView(
         children: availableTeams.map((team) => Card(
           child: Card(
             elevation: 10,
             color: Colors.blue,
             child: Container(
               decoration:BoxDecoration(
                 gradient: LinearGradient(
                   colors: [
                     Colors.blue[100]!,
                     Colors.blue[200]!,
                     Colors.blue[300]!,
                   ],
                 ),
               ),
             ),
           ),
         )).toList(),
       );
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Your Teams", style: GoogleFonts.lato(color: Colors.black ,fontSize: 24,fontWeight: FontWeight.w800),),
                  CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(.2),
                    child: IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.add_circled , color: Colors.grey,)),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * .01,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(10),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(.1),
                  hintText: "Search  your teams",
                  hintStyle: GoogleFonts.lato(color: Colors.grey , fontSize: 15,fontWeight: FontWeight.w800),
                  suffixIcon: Icon(Icons.search,color: Colors.grey,),
                ),
              ),
            ),
            SizedBox(height: size.height  * .02,),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 30),
                itemBuilder: (context , index){
                  // final item =  widget.projects[index];
                  return Card(
                    elevation: 10,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        height: size.height * .15,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue[100]!,
                              Colors.blue[100]!,
                              Colors.blue[200]!,
                            ],
                            begin: Alignment.topLeft,
                            end:Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20 , horizontal: 20),
                              child: CircleAvatar(radius: 40,backgroundColor: Colors.white,),
                            ),
                            SizedBox(height: size.height * .01,),
                          ],
                        ),
                      ),
                    ),
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
