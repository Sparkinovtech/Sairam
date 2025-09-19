import 'dart:developer' as devtools;
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Profile/Model/scholar_type.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/bloc/night_stay_bloc.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/model/night_stay_student.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/service/night_stay_provider.dart';
import 'package:sairam_incubation/Profile/bloc/profile_bloc.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Utils/Calender/calender_page.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/components_form.dart';
import 'package:sairam_incubation/Utils/model/projects.dart';
import 'package:sairam_incubation/View/Components/Home/Components/notification_page.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/views/night_stay_opt_in_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _file;
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        String displayName = profile?.name ?? "User";
        String? profilePictureUrl = profile?.profilePicture;

        NightStayStudent? nightStayStudent;
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

                  // ===== Profile Header =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage: _file != null
                                ? FileImage(_file!)
                                : (profilePictureUrl != null &&
                                      profilePictureUrl.isNotEmpty)
                                ? NetworkImage(profilePictureUrl)
                                : null,
                            child:
                                (_file == null &&
                                    (profilePictureUrl == null ||
                                        profilePictureUrl.isEmpty))
                                ? Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                : null,
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
                                displayName,
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

                  // ===== Activity Title =====
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Your Activity",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * .05),

                  // ===== Activity Cards =====
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _activityCard(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   PageTransition(
                            //     type: PageTransitionType.fade,
                            //     child: ProjectCard(
                            //       projects: ongoingProjects,
                            //       title: "Ongoing Project",
                            //     ),
                            //   ),
                            // );
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
                            // Navigator.push(
                            //   context,
                            //   PageTransition(
                            //     type: PageTransitionType.fade,
                            //     child: ProjectCard(
                            //       projects: completedProjects,
                            //       title: "Completed Project",
                            //     ),
                            //   ),
                            // );
                          },
                          title: "Completed",
                          value: "${completedProjects.length}",
                          label: "Projects",
                          icon: CupertinoIcons.moon_stars_fill,
                          context: context,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * .06),

                  // ===== Schedule =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Schedule",
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * .01),
                  _buildCalendarCard(size),

                  SizedBox(height: size.height * .05),

                  // ===== Components Grid =====
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
                                  child: NightStayOptInScreen(
                                    nightStayStudent: nightStayStudent,
                                  ),
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

  Widget _buildCalendarCard(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                children: [
                  Text(
                    "${_monthName(_focusedDay.month)} ${_focusedDay.year}",
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
              selectedDayPredicate: (day) => isSameDay(_dateTime, day),
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
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
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
                        label,
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
                        label,
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
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: AnimatedContainer(
            curve: Curves.easeInOutCubic,
            duration: Duration(seconds: 1),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 60),
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
