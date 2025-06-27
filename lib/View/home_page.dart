import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/stay_request_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String name = "John Doe";
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                  CircleAvatar(
                    backgroundColor: Colors.grey.withValues(alpha: .2),
                    radius: 20,
                    child: Icon(CupertinoIcons.bell, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: size.height * .06),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
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
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "See more",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1,
                          decorationColor: Colors.grey,
                        ),
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
                      value: "10",
                      label: "Projects",
                      icon: CupertinoIcons.cube,
                      context: context,
                    ),
                    _activityCard(
                      value: "17",
                      label: "Night Stay",
                      icon: CupertinoIcons.moon_stars_fill,
                      context: context,
                    ),
                    _activityCard(
                      value: "20",
                      label: "Evening Stay",
                      icon: CupertinoIcons.sun_dust_fill,
                      context: context,
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * .06),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Stay Request",
                  style: GoogleFonts.inter(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: size.height * .03),
              StayRequestContainer(size: size),
              SizedBox(height: size.height * .05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Achievements",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(onTap: () {}, child: Text("Add +")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activityCard({
    required String value,
    required String label,
    required IconData icon,
    required BuildContext context,
  }) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * .4,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blueGrey.withValues(alpha: .6),
                      radius: 25,
                      child: Icon(icon, size: 24, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: size.height * .03),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.grey,
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
    );
  }
}
