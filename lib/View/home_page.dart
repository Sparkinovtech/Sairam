import 'dart:developer' as devtools;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Night_Stay/bloc/night_stay_bloc.dart';
import 'package:sairam_incubation/Night_Stay/model/night_stay_student.dart';
import 'package:sairam_incubation/Night_Stay/service/night_stay_provider.dart';
import 'package:sairam_incubation/Profile/Model/scholar_type.dart';
import 'package:sairam_incubation/Profile/bloc/profile_bloc.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Utils/calender_page.dart';
import 'package:sairam_incubation/Utils/components_form.dart';
import 'package:sairam_incubation/Utils/model/projects.dart';
import 'package:sairam_incubation/Utils/notification_page.dart';
import 'package:sairam_incubation/Utils/project_card.dart';
import 'package:sairam_incubation/Night_Stay/views/night_stay_opt_in_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String name = "Sujin Danial";
  DateTime? _dateTime;
  DateTime _focusedDay = DateTime.now();
  late final ScrollController _controller;
  final List<Projects> ongoingProjects = [
    Projects(name: "Rover", mentor: "Sam", category: "Hardware", imagePath: ""),
    Projects(
      name: "Telepresence robot",
      mentor: "Jayantha",
      category: "Hardware",
      imagePath: "",
    ),
    Projects(
      name: "Child Safety",
      mentor: "Jayantha",
      category: "Software",
      imagePath: "",
    ),
    Projects(
      name: "GamifyX",
      mentor: "Sam",
      category: "Software",
      imagePath: "",
    ),
  ];
  final List<Projects> completedProjects = [
    Projects(
      name: "Skoolinq",
      mentor: "Juno Bella",
      category: "Software",
      imagePath: "",
    ),
  ];
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        NightStayStudent? nightStayStudent;
        final profile = state.profile;
        if (profile != null &&
            (profile.name?.isNotEmpty ?? false) &&
            (profile.id?.isNotEmpty ?? false) &&
            profile.scholarType != null) {
          nightStayStudent = NightStayStudent(
            studentId: profile.id!,
            studentName: profile.name!,
            scholarType: profile.scholarType!.displayName,
          );
        }

        devtools.log("From home page : The profile is $profile");

        devtools.log(
          "From home page : The Night stay student is : $nightStayStudent",
        );
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * .025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.withValues(alpha: .1),
                            radius: 24,
                            backgroundImage: NetworkImage(
                              "https://imgcdn.stablediffusionweb.com/2024/11/1/f9199f4e-2f29-4b5c-8b51-5a3633edb18b.jpg",
                            ),
                          ),
                          SizedBox(width: size.width * .02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome",
                                style: GoogleFonts.inter(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                name,
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: NotificationPage(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.withValues(alpha: .2),
                          radius: 20,
                          child: Icon(CupertinoIcons.bell, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * .06),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Activity",
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .05),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _activityCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: ProjectCard(
                                  projects: ongoingProjects,
                                  title: "Ongoing Project",
                                ),
                              ),
                            );
                          },
                          title: "Ongoing",
                          value: "${ongoingProjects.length}",
                          label: "Projects",
                          icon: CupertinoIcons.cube,
                          context: context,
                        ),
                        SizedBox(width: size.width * .07),
                        _activityCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: ProjectCard(
                                  projects: completedProjects,
                                  title: "Completed Project",
                                ),
                              ),
                            );
                          },
                          title: "Completed",
                          value: "${completedProjects.length}",
                          label: "Night Stay",
                          icon: CupertinoIcons.moon_stars_fill,
                          context: context,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .06),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Schedule",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .01),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                    child: Card(
                      elevation: 3,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "${_focusedDay.month == 1
                                      ? "January"
                                      : _focusedDay.month == 2
                                      ? "February"
                                      : _focusedDay.month == 3
                                      ? "March"
                                      : _focusedDay.month == 4
                                      ? "April"
                                      : _focusedDay.month == 5
                                      ? "May"
                                      : _focusedDay.month == 6
                                      ? "June"
                                      : _focusedDay.month == 7
                                      ? "July"
                                      : _focusedDay.month == 8
                                      ? "August"
                                      : _focusedDay.month == 9
                                      ? "September"
                                      : _focusedDay.month == 10
                                      ? "October"
                                      : _focusedDay.month == 11
                                      ? "November"
                                      : "December"} ${_focusedDay.year}",
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: CalenderPage(),
                                      ),
                                    );
                                  },
                                  icon: Icon(CupertinoIcons.calendar),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * .02),

                          TableCalendar(
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) =>
                                isSameDay(_dateTime, day),
                            calendarFormat: CalendarFormat.week,
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _dateTime = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            headerVisible: false,
                            availableGestures: AvailableGestures.none,
                            daysOfWeekVisible: true,
                            calendarStyle: CalendarStyle(
                              isTodayHighlighted: true,
                              selectedDecoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              outsideDaysVisible: false,
                            ),
                          ),
                          SizedBox(height: size.height * .04),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * .05),
                  SizedBox(
                    height: size.height * .4,
                    child: GridView.count(
                      childAspectRatio: 1.2,
                      crossAxisCount: 2,
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 7,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        _componentCard(
                          title: "Progress",
                          icon: CupertinoIcons.chart_bar_alt_fill,
                          onTap: () {},
                        ),
                        _componentCard(
                          title: "Components",
                          icon: CupertinoIcons.settings,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: ComponentsForm(),
                                curve: Curves.easeInOut,
                              ),
                            );
                          },
                        ),
                        _componentCard(
                          title: "Night Stay",
                          icon: CupertinoIcons.moon_stars_fill,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: BlocProvider(
                                  create: (context) =>
                                      NightStayBloc(NightStayProvider()),
                                  child: NightStayOptInScreen(nightStayStudent: nightStayStudent,),
                                ),
                              ),
                            );
                          },
                        ),
                        _componentCard(
                          title: "OD",
                          icon: CupertinoIcons.square_list_fill,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _activityCard({
    required String title,
    required String value,
    required String label,
    required IconData icon,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size.width * .4,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Icon(icon, color: Colors.grey),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Project",
                        style: GoogleFonts.lato(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: size.width * .01),
                      Text(
                        "Projects",
                        style: GoogleFonts.lato(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _componentCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: AnimatedContainer(
            curve: Curves.easeInOutCubic,
            duration: Duration(seconds: 1),
            child: Container(
              width: size.width * .18,
              height: size.height * .008,
              padding: EdgeInsets.symmetric(horizontal: 00),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Icon(icon, color: Colors.white, size: 60)),
                  SizedBox(height: size.height * .01),
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
