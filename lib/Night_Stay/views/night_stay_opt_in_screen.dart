import 'dart:developer' as devtools;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sairam_incubation/Night_Stay/bloc/night_stay_bloc.dart';
import 'package:sairam_incubation/Night_Stay/bloc/night_stay_event.dart';
import 'package:sairam_incubation/Night_Stay/bloc/night_stay_state.dart';
import 'package:sairam_incubation/Night_Stay/model/night_stay_student.dart';

class NightStayOptInScreen extends StatefulWidget {
  final NightStayStudent? nightStayStudent;
  const NightStayOptInScreen({super.key, this.nightStayStudent});

  @override
  State<NightStayOptInScreen> createState() => _NightStayOptInScreenState();
}

class _NightStayOptInScreenState extends State<NightStayOptInScreen> {
  String? nightStayChoice; // "Yes" or "No"

  bool get infoMissing => widget.nightStayStudent == null;

  @override
  Widget build(BuildContext context) {
    devtools.log("The Nigth stay student is ${widget.nightStayStudent}");
    devtools.log("the Infomissing is $infoMissing");
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
            infoMissing
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
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
                  )
                : Column(
                    children: [
                      Text(
                        "Do you want to stay tonight?",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.height * .04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _choiceButton(
                            label: "Yes",
                            isSelected: nightStayChoice == "Yes",
                            onTap: () =>
                                setState(() => nightStayChoice = "Yes"),
                            context: context,
                          ),
                          const SizedBox(width: 28),
                          _choiceButton(
                            label: "No",
                            isSelected: nightStayChoice == "No",
                            onTap: () => setState(() => nightStayChoice = "No"),
                            context: context,
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
      bottomNavigationBar: infoMissing
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: BlocConsumer<NightStayBloc, NightStayState>(
                listener: (context, state) {
                  if (state is NightStaySuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Your night stay choice has been saved."),
                      ),
                    );
                  } else if (state is NightStayFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to save: ${state.error}")),
                    );
                  }
                },
                builder: (context, state) {
                  bool isLoading = state is NightStayLoading;
                  bool canSubmit = nightStayChoice != null && !isLoading;
                  return MaterialButton(
                    elevation: 0,
                    onPressed: !canSubmit
                        ? null
                        : () {
                            if (nightStayChoice == "Yes") {
                              context.read<NightStayBloc>().add(
                                SaveNightStayEvent(widget.nightStayStudent!),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "You have opted out of Night Stay.",
                                  ),
                                ),
                              );
                            }
                          },
                    color: Colors.blue,
                    minWidth: double.infinity,
                    height: size.height * .05,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Submit",
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  );
                },
              ),
            ),
    );
  }

  Widget _choiceButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
