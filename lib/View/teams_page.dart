// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  final List<String> tabs = ['Your Team', 'Add Team', 'Past Team'];
  // int _selectedTab = 0;
  // String _searchQuery = "";
  final List<Map<String, String>> recentTeams = [
    {"name": "Skoolinq", "mentor": "Juno Bella", "category": "Software"},
    {
      "name": "Telepresence robot",
      "mentor": "Jayantha",
      "category": "Hardware",
    },
    {"name": "Rover", "mentor": "Sam", "category": "Hardware"},
  ];
  final List<Map<String, String>> addableTeams = [
    {"name": "Child Safety", "mentor": "Jayantha", "category": "Hardware"},
    {"name": "GamifyX", "mentor": "Sundar", "category": "Software"},
    {"name": "Skoolinq", "mentor": "Juno Bella", "category": "Software"},
    {
      "name": "Telepresence robot",
      "mentor": "Jayantha",
      "category": "Hardware",
    },
  ];
  final List<Map<String, String>> pastTeams = [
    {"name": "Child Safety", "mentor": "Jayantha", "category": "Hardware"},
    {"name": "GamifyX", "mentor": "Sundar", "category": "Software"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,);
    // List<Map<String, String>> currentList = [];
    // switch (_selectedTab) {
    //   case 0:
    //     currentList = recentTeams;
    //     break;
    //   case 1:
    //     currentList = addableTeams;
    //     break;
    //   case 2:
    //     currentList = pastTeams;
    //     break;
    // }
    // final filteredTeams = currentList.where((team) {
    //   return team['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
    // });
    // var size = MediaQuery.of(context).size;
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SafeArea(
    //     child: Padding(
    //       padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             tabs[_selectedTab],
    //             style: GoogleFonts.inter(
    //               color: Colors.black,
    //               fontSize: 20,
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //           SizedBox(height: size.height * .04),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: List.generate(tabs.length, (index) {
    //               final isSelectedIndex = index == _selectedTab;
    //               return Expanded(
    //                 child: GestureDetector(
    //                   onTap: () {
    //                     setState(() {
    //                       _selectedTab = index;
    //                       _searchQuery = "";
    //                     });
    //                   },
    //                   child: Container(
    //                     margin: EdgeInsets.symmetric(horizontal: 4),
    //                     padding: EdgeInsets.symmetric(vertical: 20),
    //                     decoration: BoxDecoration(
    //                       gradient: LinearGradient(
    //                         colors: isSelectedIndex
    //                             ? [
    //                                 Colors.blue[700]!,
    //                                 Colors.blue[500]!,
    //                                 Colors.blue[300]!,
    //                               ]
    //                             : [
    //                                 Colors.grey[700]!,
    //                                 Colors.grey[500]!,
    //                                 Colors.grey[300]!,
    //                               ],
    //                         begin: Alignment.topLeft,
    //                         end: Alignment.bottomRight,
    //                       ),
    //                       borderRadius: BorderRadius.circular(15),
    //                     ),
    //                     alignment: Alignment.center,
    //                     child: Text(
    //                       tabs[index],
    //                       style: GoogleFonts.inter(
    //                         color: Colors.white,
    //                         fontSize: 15,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               );
    //             }),
    //           ),
    //           SizedBox(height: size.height * .03),
    //           TextFormField(
    //             onChanged: (value) => setState(() {
    //               _searchQuery = value;
    //             }),
    //             cursorColor: Colors.grey,
    //             keyboardType: TextInputType.name,
    //             decoration: InputDecoration(
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //                 borderSide: BorderSide.none,
    //               ),
    //               hintText: _selectedTab == 1
    //                   ? "Search New Team"
    //                   : _selectedTab == 2
    //                   ? "Search Past Team"
    //                   : "Search Your Team",
    //               prefixIcon: Icon(CupertinoIcons.search),
    //               contentPadding: EdgeInsets.all(14),
    //               fillColor: Colors.grey.withValues(alpha: .1),
    //               filled: true,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  // Widget _teamCard({
  //   required String teamName,
  //   required String mentor,
  //   required String category,
  //   required String image,
  // }) {
  //   return Container(
  //     padding: EdgeInsets.all(20),
  //     margin: EdgeInsets.only(bottom: 10),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [Color(0xFFD0ECFF), Color(0xFFF1FAFF)],
  //         begin: Alignment.topLeft,
  //         end: Alignment.center,
  //       ),
  //     ),
  //   );
  // }

}
