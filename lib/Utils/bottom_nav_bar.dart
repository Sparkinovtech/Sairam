import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sairam_incubation/Profile/Model/profile.dart';
import 'package:sairam_incubation/View/home_page.dart';
import 'package:sairam_incubation/View/profile_page.dart';
import 'package:sairam_incubation/View/teams_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'model/projects.dart';

class BottomNavBar extends StatefulWidget {

  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  // final List<Projects> myTeams = [
  //   Projects(
  //       name: "Rover",
  //       mentor: "Sam",
  //       category: "Hardware",
  //       imagePath: ""
  //   ),
  //   Projects(
  //       name: "Telepresence robot",
  //       mentor: "Jayantha",
  //       category: "Hardware",
  //       imagePath: ""
  //   ),
  //   Projects(
  //     name: "Child Safety",
  //     mentor: "Jayantha",
  //     category: "Software",
  //     imagePath: "",
  //   ),
  //   Projects(
  //     name: "GamifyX",
  //     mentor:"Sam",
  //     category: "Software",
  //     imagePath: "",
  //   ),
  // ];
  @override
  void initState() {
    super.initState();
    _pages = [HomePage(), ProfilePage()];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(seconds: 3),
        curve: Curves.easeInOut,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: GNav(
          gap: 10,
          selectedIndex: _selectedIndex,
          onTabChange: (index) => setState(() => _selectedIndex = index),
          tabBorderRadius: 30,
          tabBackgroundGradient: LinearGradient(
            colors: [Color(0xFF52A0FD), Color(0xFF00D6FF)],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          activeColor: Colors.white,
          tabs: [
            GButton(icon: CupertinoIcons.home, text: "Home"),
            GButton(icon: CupertinoIcons.person, text: "Profile"),
          ],
        ),
      ),
    );
  }
}
