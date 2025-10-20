import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sairam_incubation/Utils/Constants/colors.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/bloc/component_bloc.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/view/component_AddPage.dart';

class ComponentPage extends StatefulWidget {
  const ComponentPage({super.key});

  @override
  State<ComponentPage> createState() => _ComponentPageState();
}

class _ComponentPageState extends State<ComponentPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComponentBloc, ComponentState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Stack(
                      children: [
                        // Centered title
                        Center(
                          child: Text(
                            "Components",
                            style: GoogleFonts.lato(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // Right-aligned notification button
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                            onPressed: () {
                              // Handle notification button press
                            },
                            icon: Icon(CupertinoIcons.bell),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // List of Requested Components
                  SizedBox(height: 16),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3, // Replace with your actual item count
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            'Requested ${index + 1}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Sept 20, 2025'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Handle component tap
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: bg,
            foregroundColor: Colors.white,
            onPressed: () {
              // Action for FAB
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComponentAddpage()),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
