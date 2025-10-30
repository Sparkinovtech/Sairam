import 'dart:developer' as devtools;
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Profile/Model/scholar_type.dart';
import 'package:sairam_incubation/Profile/bloc/profile_event.dart';
import 'package:sairam_incubation/Utils/Constants/colors.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/bloc/night_stay_bloc.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/bloc/night_stay_event.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/bloc/night_stay_state.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/model/night_stay_student.dart';
import 'package:sairam_incubation/Profile/bloc/profile_bloc.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Utils/Calender/calender_page.dart';
import 'package:sairam_incubation/Utils/model/projects.dart';
import 'package:sairam_incubation/View/Components/Home/Components/notification_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late NightStayBloc _nightStayBloc;
  bool get isWithinAllowedTime {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 16);
    final end = DateTime(now.year, now.month, now.day, 18);
    return now.isAfter(start) && now.isBefore(end);
  }
  bool checked = false;
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
    _nightStayBloc = BlocProvider.of<NightStayBloc>(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool hasOptedIn = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<ProfileBloc, ProfileState>(
      
      listener: (context, state) {
        if (state is ProfileStatusState) {
          print("Has opted in: $hasOptedIn");
          
            hasOptedIn = (state as ProfileStatusState).hasOpted;
          
        }
        if (state is NightStayBtnClickState) {
          // Handle the night stay button click event
          if (!isWithinAllowedTime) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Night Stay requests can only be made between 4 PM and 6 PM.',
                ),
              ),
            );
            return;
          }
          if (state.nightStayStudent == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Insufficient profile information to proceed with Night Stay request.',
                ),
              ),
            );
            return;
          }
          showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                title: Text('Night Stay Request'),
                content: Text(
                  hasOptedIn
                      ? 'Are you sure you want to cancel your night stay request?'
                      : 'Are you sure you want to opt in for night stay?',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _nightStayBloc.add(
                        SaveNightStayEvent(
                          state.nightStayStudent!,
                          hasOptedIn ? 'No' : 'Yes',
                        ),
                      );

                      Navigator.of(context).pop();
                      setState(() {
                        hasOptedIn = !hasOptedIn;
                      });
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
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
        
        if (nightStayStudent != null && checked == false) {
          print(
            "Dispatching CheckNightStayStatusEvent for studentId: ${nightStayStudent.studentId}",
          );
          context.read<ProfileBloc>().add(
            CheckNightStayStatusProfileEvent(nightStayStudent.studentId),
          );
          checked = true;
        }
        devtools.log("From home page : The profile is $profile");
        devtools.log(
          "From home page : The Night stay student is : $nightStayStudent",
        );

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Profile Header =====
                  Stack(
                    children: [
                      // Centered Home text
                      Center(
                        child: Text(
                          "Home",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Right-aligned icons
                      Positioned(
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  CupertinoIcons.bell,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.grey.shade200,
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
                                      size: 28,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * .03),

                  // // ===== Activity Title =====
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   child: Text(
                  //     "Your Activity",
                  //     style: GoogleFonts.inter(
                  //       color: Colors.black,
                  //       fontSize: 24,
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  // ),

                  // SizedBox(height: size.height * .05),

                  // // ===== Activity Cards =====
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       _activityCard(
                  //         onTap: () {
                  //           // Navigator.push(
                  //           //   context,
                  //           //   PageTransition(
                  //           //     type: PageTransitionType.fade,
                  //           //     child: ProjectCard(
                  //           //       projects: ongoingProjects,
                  //           //       title: "Ongoing Project",
                  //           //     ),
                  //           //   ),
                  //           // );
                  //         },
                  //         title: "Ongoing",
                  //         value: "${ongoingProjects.length}",
                  //         label: "Projects",
                  //         icon: CupertinoIcons.cube,
                  //         context: context,
                  //       ),
                  //       SizedBox(width: size.width * .07),
                  //       _activityCard(
                  //         onTap: () {
                  //           // Navigator.push(
                  //           //   context,
                  //           //   PageTransition(
                  //           //     type: PageTransitionType.fade,
                  //           //     child: ProjectCard(
                  //           //       projects: completedProjects,
                  //           //       title: "Completed Project",
                  //           //     ),
                  //           //   ),
                  //           // );
                  //         },
                  //         title: "Completed",
                  //         value: "${completedProjects.length}",
                  //         label: "Projects",
                  //         icon: CupertinoIcons.moon_stars_fill,
                  //         context: context,
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // SizedBox(height: size.height * .06),
                  // ===== Display profile =====
                  RichText(
                    text: TextSpan(
                      text: 'Hello, ',
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '$displayName!',
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Welcome back to Sairam Incubation!',
                    style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: size.height * .03),

                  // ===== Night Stay =====
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: bg_light,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.moon,
                                color: Colors.black,
                                size: 24,
                              ),
                              SizedBox(width: size.width * .02),
                              Text(
                                "Night Stay Facility",
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * .01),
                          Text(
                            "Register for late-night lab access to continue your projects.",
                            style: GoogleFonts.lato(
                              color: Colors.grey.shade800,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: size.height * .02),
                          InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   PageTransition(
                              //     type: PageTransitionType.fade,
                              //     child: BlocProvider(
                              //       create: (context) =>
                              //           NightStayBloc(NightStayProvider()),
                              //       child: NightStayOptInScreen(
                              //         nightStayStudent: nightStayStudent,
                              //       ),
                              //     ),
                              //   ),
                              // );
                              context.read<ProfileBloc>().add(
                                NightStayBtnClickEvent(
                                  nightStayStudent: nightStayStudent,
                                ),
                              );
                            },

                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: hasOptedIn ? Colors.red : bg,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  hasOptedIn
                                      ? "Cancel Night Stay"
                                      : "Opt for Night Stay",
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * .03),

                  // ===== Schedule =====
                  Text(
                    "Schedule",
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  SizedBox(height: size.height * .01),
                  _buildCalendarCard(size),

                  SizedBox(height: size.height * .03),

                  // ====== Meetings =====
                  // Text(
                  //   "Upcoming Meetings",
                  //   style: GoogleFonts.lato(
                  //     color: Colors.black,
                  //     fontSize: 22,
                  //     fontWeight: FontWeight.w800,
                  //   ),
                  // ),
                  // ===== Report Issue =====
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: bg_light,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.bug_report_outlined,
                                color: Colors.black,
                                size: 24,
                              ),
                              SizedBox(width: size.width * .02),
                              Text(
                                "Report App Issue",
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * .01),
                          Text(
                            "App in testing. Found a bug or issue? Let us know.",
                            style: GoogleFonts.lato(
                              color: Colors.grey.shade800,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: size.height * .02),
                          InkWell(
                            onTap: () async {
                              String?
                              issueDescription = await showDialog<String>(
                                context: context,
                                builder: (context) {
                                  final TextEditingController controller =
                                      TextEditingController();
                                  return AlertDialog(
                                    title: Text('Report an Issue'),
                                    content: TextField(
                                      controller: controller,
                                      minLines: 3,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                        hintText:
                                            "Explain the issue you faced...",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      ElevatedButton(
                                        child: Text("Report"),
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pop(controller.text.trim());
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (issueDescription != null &&
                                  issueDescription.isNotEmpty) {
                                // Call your method to send the issue, e.g.:
                                await sendIssueReport(issueDescription);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Issue reported. Thank you!"),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "Report Issue",
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * .01),
                  // ListTile(
                  //   title: Text(
                  //     "Mentor Meeting",
                  //     style: GoogleFonts.lato(
                  //       color: Colors.black,
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     "Today, 3:00 PM - 4:00 PM",
                  //     style: GoogleFonts.lato(
                  //       color: Colors.grey,
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  //   trailing: Icon(
                  //     CupertinoIcons.right_chevron,
                  //     color: Colors.grey,
                  //   ),
                  //   onTap: () {
                  //     // Navigate to meeting details or join meeting
                  //   },
                  // ),
                  // SizedBox(height: 1),
                  // ListTile(
                  //   title: Text(
                  //     "Mentor Meeting",
                  //     style: GoogleFonts.lato(
                  //       color: Colors.black,
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     "Today, 3:00 PM - 4:00 PM",
                  //     style: GoogleFonts.lato(
                  //       color: Colors.grey,
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  //   trailing: Icon(
                  //     CupertinoIcons.right_chevron,
                  //     color: Colors.grey,
                  //   ),
                  //   onTap: () {
                  //     // Navigate to meeting details or join meeting
                  //   },
                  // ),
                  // ===== Components Grid =====
                  // SizedBox(
                  //   height: size.height * .4,
                  //   child: GridView.count(
                  //     childAspectRatio: 1.2,
                  //     crossAxisCount: 2,
                  //     mainAxisSpacing: 7,
                  //     crossAxisSpacing: 7,
                  //     shrinkWrap: true,
                  //     physics: ScrollPhysics(),
                  //     children: [
                  //       _componentCard(
                  //         title: "Progress",
                  //         icon: CupertinoIcons.chart_bar_alt_fill,
                  //         onTap: () {},
                  //       ),
                  //       _componentCard(
                  //         title: "Components",
                  //         icon: CupertinoIcons.settings,
                  //         onTap: () {
                  //           Navigator.push(
                  //             context,
                  //             PageTransition(
                  //               type: PageTransitionType.fade,
                  //               child: ComponentsForm(),
                  //               curve: Curves.easeInOut,
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //       _componentCard(
                  //         title: "Night Stay",
                  //         icon: CupertinoIcons.moon_stars_fill,
                  //         onTap: () {
                  //           Navigator.push(
                  //             context,
                  //             PageTransition(
                  //               type: PageTransitionType.fade,
                  //               child: BlocProvider(
                  //                 create: (context) =>
                  //                     NightStayBloc(NightStayProvider()),
                  //                 child: NightStayOptInScreen(
                  //                   nightStayStudent: nightStayStudent,
                  //                 ),
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //       _componentCard(
                  //         title: "OD",
                  //         icon: CupertinoIcons.square_list_fill,
                  //         onTap: () {},
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> sendIssueReport(String message) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'simonjohn42004.sparkit@gmail.com', // Change to your support email
      query: 'subject=App Issue&body=${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  Widget _buildCalendarCard(Size size) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
