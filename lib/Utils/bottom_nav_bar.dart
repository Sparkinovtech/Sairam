import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sairam_incubation/View/home_page.dart';
import 'package:sairam_incubation/View/profile_page.dart';
import 'package:sairam_incubation/View/teams_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [HomePage(), TeamsPage(), ProfilePage()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
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
            GButton(icon: CupertinoIcons.group, text: "Teams"),
            GButton(icon: CupertinoIcons.person, text: "Profile"),
          ],
        ),
      ),
    );
  }
}
