import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Utils/model/task.dart';
import 'package:sairam_incubation/Utils/monthy_calender.dart';
import 'package:sairam_incubation/Utils/task_details.dart';
import 'package:table_calendar/table_calendar.dart';
class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  DateTime? _dateTime;
  DateTime _focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var size  = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20 , vertical: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
                        Text("Calender",style: GoogleFonts.lato(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w800),),
                      ],
                    ),
                    SizedBox(height: size.height * .01,),
                  ],
                ),
              ),
              SizedBox(height: size.height * .01,),
              MonthyCalender(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30 , vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Tasks",style: GoogleFonts.lato(color: Colors.black,fontSize: 21,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 0),
                child: Column(
                  children: [
                    _taskManager(onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.fade , child:
                      TaskDetailsPage(
                          task: Task(
                            title: "Login Page Completion",
                            description: "A Login Page Allow user to securely access the website or application by entering their  details.\nIt is the typically includes fields for username/email or password. ",
                            steps: [
                            "Design basic layout with input fields",
                            "Implemented front-end form validation",
                            "Styled  the form through responsive and accessibility",
                            "Integrated backend authentication logics",
                            "Testing login functionality and Error handling",
                            "Added 'Forget Password' features for better and user experiences",
                              "Connecting to Database"
                          ],
                          ),
                      )));
                    }, title: "Login Page Completion", deadline: "22/07",
                        color: Colors.blue[200]!, textColor: Colors.blue[700]!),
                    SizedBox(height: size.height * .02,),
                    _taskManager(onTap: (){}, title: "Home Page Completion", deadline: "25/07",
                        color: Colors.orange[200]!, textColor: Colors.orange[700]!),
                    SizedBox(height: size.height * .02,),
                    _taskManager(onTap: (){}, title: "Profile Page Completion", deadline: "29/07", color: Colors.pink[200]!, textColor: Colors.pink[700]!),
                    SizedBox(height: size.height * .07,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _taskManager({
    required VoidCallback onTap ,
    required String title ,
    required String deadline  ,
    required Color color ,
    required Color textColor}){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: size.height * .07,
          width: size.width * .9,
          padding: EdgeInsets.symmetric(horizontal: 20),
          
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.lato(color: textColor,fontSize: 15,fontWeight: FontWeight.w500),),
              Text(deadline , style: GoogleFonts.lato(color: textColor , fontSize: 15,fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
