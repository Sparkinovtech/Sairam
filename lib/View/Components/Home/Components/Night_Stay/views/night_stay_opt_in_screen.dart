import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/bloc/night_stay_bloc.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/bloc/night_stay_event.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/bloc/night_stay_state.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/model/night_stay_student.dart';

class NightStayOptInScreen extends StatefulWidget {
  final NightStayStudent? nightStayStudent;
  const NightStayOptInScreen({super.key, this.nightStayStudent});

  @override
  State<NightStayOptInScreen> createState() => _NightStayOptInScreenState();
}

class _NightStayOptInScreenState extends State<NightStayOptInScreen> {
  bool hasOptedIn = false;

  // Check if current time is between 4PM and 6PM
  bool get isWithinAllowedTime {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 16);
    final end = DateTime(now.year, now.month, now.day, 18);
    return now.isAfter(start) && now.isBefore(end);
  }

  bool get infoMissing => widget.nightStayStudent == null;

  @override
  void initState() {
    super.initState();
    // Dispatch event to check current night stay status from Firestore
    // if (widget.nightStayStudent != null) {
    //   context.read<NightStayBloc>().add(
    //     CheckNightStayStatusEvent(widget.nightStayStudent!.studentId),
    //   );
    // }
  }

  void _toggleNightStay() {
    if (widget.nightStayStudent == null) return;

    if (hasOptedIn) {
      // Cancel night stay request (No)
      context.read<NightStayBloc>().add(
        SaveNightStayEvent(widget.nightStayStudent!, 'No'),
      );
    } else {
      // Opt in for night stay (Yes)
      context.read<NightStayBloc>().add(
        SaveNightStayEvent(widget.nightStayStudent!, 'Yes'),
      );
    }
    // No need for setState here; react to bloc state changes
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // // If outside allowed time, you can optionally enable this block to show warning
    // if (!isWithinAllowedTime) {
    //   return Scaffold(
    //     backgroundColor: Colors.white,
    //     body: SafeArea(
    //       child: Container(
    //         margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    //         padding: const EdgeInsets.all(18),
    //         decoration: BoxDecoration(
    //           color: Colors.yellow[100],
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             const Icon(
    //               Icons.warning_amber_rounded,
    //               color: Colors.orange,
    //               size: 32,
    //             ),
    //             const SizedBox(width: 12),
    //             Expanded(
    //               child: Text(
    //                 'Night stay option is available only from 4PM to 6PM everyday.\n'
    //                 'Please try again during the allowed period.',
    //                 style: GoogleFonts.inter(
    //                   color: Colors.orange[900],
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }

    // Within allowed time, if profile incomplete show profile incomplete widget
    if (infoMissing) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Please complete your profile before opting for night stay.\n'
                    'Go to your profile page and ensure your Student ID, Name, and Scholar Type are filled.',
                    style: GoogleFonts.inter(
                      color: Colors.orange[900],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Within allowed time and profile complete: show the toggle button with related text
    return BlocListener<NightStayBloc, NightStayState>(
      listener: (context, state) {
        if (state is NightStayStatusState) {
          setState(() {
            hasOptedIn = state.hasOpted;
          });
        } else if (state is NightStaySuccess) {
          // Refresh night stay status after a successful toggle
          if (widget.nightStayStudent != null) {
            context.read<NightStayBloc>().add(
              CheckNightStayStatusEvent(widget.nightStayStudent!.studentId),
            );
          }
        } else if (state is NightStayFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Night Stay",
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * .10),
              Text(
                hasOptedIn
                    ? "You have opted for night stay."
                    : "Do you want to stay tonight?",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * .04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: MaterialButton(
                  elevation: 0,
                  onPressed: _toggleNightStay,
                  color: hasOptedIn ? Colors.red : Colors.blue,
                  minWidth: double.infinity,
                  height: size.height * .06,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    hasOptedIn ? "Cancel Stay" : "Stay Tonight",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
