import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sairam_incubation/Utils/Constants/colors.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/view/component_page.dart';
import 'package:sairam_incubation/View/Components/Home/home_page.dart';
import 'package:sairam_incubation/View/Components/profile_page.dart';


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
    _pages = [HomePage(), ComponentPage(), Placeholder() , ProfilePage() ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(seconds: 3),
        curve: Curves.easeInOut,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Container(
          width: double.infinity,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _selectedIndex == 0
                  ? Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: bg_light,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.home_outlined, color: bg),
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                      ),
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.home,
                        color: _selectedIndex == 0
                            ? Colors.blue
                            : Colors.grey[400],
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                    ),
              _selectedIndex == 1
                  ? Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: bg_light,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.architecture_outlined, color: bg),
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                      ),
                    )
                  : IconButton(
                      icon: Icon(Icons.architecture_outlined, color: Colors.grey[400]),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                    ),
             _selectedIndex == 2
                  ? Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: bg_light,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.article_outlined, color: bg),
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                      ),
                    )
                  : IconButton(
                      icon: Icon(Icons.article_outlined, color: Colors.grey[400]),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                    ),
              _selectedIndex == 3 ? Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: bg_light,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.person_2_outlined, color: bg),
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 3;
                          });
                        },
                      ),
                    )
                  : IconButton(
                      icon: Icon(Icons.person_2_outlined, color: Colors.grey[400]),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 3;
                        });
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
