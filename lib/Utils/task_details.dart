import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'model/task.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  const TaskDetailsPage({super.key, required this.task});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  void _toggleSteps(int index) {
    setState(() {
      if(widget.task.completedSteps.contains(index)){
        widget.task.completedSteps.remove(index);
      }else{
        widget.task.completedSteps.add(index);
      }
      final completedCount = widget.task.completedSteps.length;
      final totalSteps = widget.task.steps.length;
      widget.task.progress = ((completedCount / totalSteps) * 100).round();
    });
  }

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
                padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back_ios_new ,color: Colors.black,)),
                    SizedBox(width: size.width * .03,),
                    Text("Task Details",style: GoogleFonts.lato(color: Colors.black,fontSize: 24,fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
              SizedBox(height: size.height * .01,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 0),
                child: Card(
                  color: Colors.white,
                  elevation: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: size.width * .9,
                      height: size.height * .4,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                         Padding(
                           padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
                           child: Column(
                             children: [
                               Row(
                                 children: [
                                   Text(widget.task.title ,
                                     style: GoogleFonts.lato(color: Colors.black , fontSize: 23 ,fontWeight: FontWeight.w700),),
                                 ],
                               ),
                              SizedBox(height: size.height * .03,),
                              Text(widget.task.description,style: GoogleFonts.tillana(color: Colors.black),),
                               SizedBox(height: size.height * .04,),

                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text("Progress",style: GoogleFonts.lato(color: Colors.black ,fontSize: 14,fontWeight: FontWeight.w700),),
                                   Text("${widget.task.progress}%",style: GoogleFonts.lato(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),),
                                 ],
                               ),
                               SizedBox(height: size.height * .03,),
                               TweenAnimationBuilder(tween: Tween<double>(begin: 0 , end: widget.task.progress / 100),
                                   duration: Duration(seconds: 1), builder:(context , value , child){
                                       return LinearProgressIndicator(
                                         borderRadius: BorderRadius.circular(20),
                                         minHeight: size.height * .01,
                                         backgroundColor: Colors.grey[300]!,
                                         color: Colors.blue[400]!,
                                         value: value,
                                       );
                                   },
                               ),
                             ],
                           ),
                         ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * .01,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30 , vertical:20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Progress",style: GoogleFonts.lato(color: Colors.black,fontSize: 21,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: size.height * .03,),
                    Card(
                      color: Colors.white,
                      elevation: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.infinity,
                          height: size.height * .45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: ListView.builder(
                            itemCount: widget.task.steps.length,
                              itemBuilder: (context ,index)
                              {
                                final steps = widget.task.steps[index];
                                final isChecked = widget.task.completedSteps.contains(index);
                                return CheckboxListTile(
                                  value: isChecked,
                                  title: Text(steps , style:GoogleFonts.lato(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w500),),
                                  onChanged: (_) => _toggleSteps(index),
                                );
                              }
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30 , vertical: 10),
        child: MaterialButton(
          onPressed: (){
            Navigator.pop(context);
          },
          color: Colors.blue[300]!,
          minWidth: size.width * .5,
          height: size.height * .06,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text("Set As Done",style: GoogleFonts.lato(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w800),),
        ),
      ),
    );
  }
}
