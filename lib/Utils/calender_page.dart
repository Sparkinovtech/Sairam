import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sairam_incubation/Utils/monthy_calender.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Tasks",style: GoogleFonts.lato(color: Colors.black,fontSize: 21,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            // _taskManager(title: "", tasks: "", icon: Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,)),
          ],
        ),
      ),
    );
  }
  Widget _taskManager({required String title ,required String tasks  , required IconData icon}){
    return Card(
      elevation: 10,
      color: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(title, style: GoogleFonts.lato(color: Colors.black,fontSize: 1),)
        ],
      ),
    );
  }
}
