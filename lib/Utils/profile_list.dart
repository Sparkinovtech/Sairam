import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sairam_incubation/Auth/View/identity_details.dart';
import 'package:sairam_incubation/Auth/View/skill_set.dart';
import 'package:sairam_incubation/Auth/View/work_preference_edit.dart';

class ProfileList extends StatefulWidget {
  const ProfileList({super.key});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList>
    with SingleTickerProviderStateMixin {
  final List<String> _workPreferences = [];
  final List<String> _skillSet = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildList(
            icon: Icons.arrow_forward_ios_rounded,
            text: "Identity details",
            subText: "Basic personal and academic information",
            onTap: () {
              Navigator.push(context, PageTransition(type: PageTransitionType.fade , child:IdentityDetails()));
            },
          ),
          SizedBox(height: size.height * 0.06),
          _buildListWidget(
            icon: Icons.edit_outlined,
            text: "Work Preference",
            subText: "Your desired roles and availability",
            tags: _workPreferences,
            onTap: () async {
              final update = await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const WorkpreferenceEdit(),
                ),
              );
              if (update != null && update is List<String>) {
                setState(() {
                  _workPreferences.clear();
                  _workPreferences.addAll(update);
                });
              }
            },
          ),
          SizedBox(height: size.height * 0.04),
          _buildListWidget(
            icon: Icons.edit_outlined,
            text: "Skill Set",
            subText: "Highlight your tools and capability",
            tags: _skillSet,
            onTap: () async {
              final update = await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const SkillSet(),
                ),
              );
              if (update != null && update is List<String>) {
                setState(() {
                  _skillSet.clear();
                  _skillSet.addAll(update);
                });
              }
            },
          ),
          SizedBox(height: size.height * 0.04),
          _buildList(
            icon: Icons.arrow_forward_ios_rounded,
            text: "Portfolio",
            subText: "Showcase your best design work",
            onTap: () {},
          ),
          SizedBox(height: size.height * 0.04),
          _buildList(
            icon: Icons.arrow_forward_ios_rounded,
            text: "Earned Certificates",
            subText: "Proof of learning and achievement",
            onTap: () {},
          ),
          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }

  Widget _buildList({
    required IconData icon,
    required String text,
    required String subText,
    required VoidCallback onTap,
  }) {
    var size = MediaQuery.of(context).size;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    subText,
                    style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onTap,
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListWidget({
    required IconData icon,
    required String text,
    required String subText,
    required List<String> tags,
    required VoidCallback onTap,
  }) {
    var size = MediaQuery.of(context).size;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subText,
                      style: GoogleFonts.lato(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: onTap,
                  icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            tags.isEmpty
                ? const Text("No Preference is Selected")
                : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) => _buildTags(tag)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTags(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
