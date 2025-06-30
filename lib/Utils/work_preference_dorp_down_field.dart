// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class WorkpreferenceDorpDownField extends StatefulWidget {
//   const WorkpreferenceDorpDownField({super.key});
//
//   @override
//   State<WorkpreferenceDorpDownField> createState() =>
//       _WorkpreferenceDorpDownFieldState();
// }
//
// class _WorkpreferenceDorpDownFieldState
//     extends State<WorkpreferenceDorpDownField> {
//   bool _isExpanded = false;
//   String? _selected;
//   final List<String> _options = [
//     "Graphics Designer",
//     "UI/UX Designer",
//     "Web Developer",
//     "Mobile Application Developer",
//     "Architecture Designer",
//     "Machine Learning",
//     "Prompt Engineer",
//     "Others",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           children: [
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _isExpanded = !_isExpanded;
//                 });
//               },
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                 margin: const EdgeInsets.symmetric(horizontal: 30),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(7),
//                   border: Border.all(
//                     color: Colors.grey.withOpacity(0.5),
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       _selected ?? "Add Your Work Preference",
//                       style: GoogleFonts.lato(
//                         color: Colors.black,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Icon(
//                       _isExpanded
//                           ? Icons.keyboard_arrow_up_outlined
//                           : Icons.keyboard_arrow_down_outlined,
//                       color: Colors.black,
//                       size: 25,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (_isExpanded)
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 30),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: Colors.grey.shade500),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: _options.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(
//                         _options[index],
//                         style: GoogleFonts.inter(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       onTap: () {
//                         setState(() {
//                           _selected = _options[index];
//                           _isExpanded = false;
//                         });
//                       },
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
