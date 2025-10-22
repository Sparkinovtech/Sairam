import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sairam_incubation/Utils/Constants/colors.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/bloc/component_bloc.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/component.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/componet_request.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/view/component_AddPage.dart';

class ComponentPage extends StatefulWidget {
  final List<Component>? components;
  const ComponentPage({super.key, this.components});

  @override
  State<ComponentPage> createState() => _ComponentPageState();
}

class _ComponentPageState extends State<ComponentPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComponentBloc, ComponentState>(
      listener: (context, state) {
        if (state is NavigateToAddComponentState) {
          print("Navigating to Add Component Page");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ComponentAddpage()),
          );
        }
      },
      builder: (context, state) {
        List<ComponetRequest> ComponentRequests = widget.components != null
            ? widget.components!
                  .map(
                    (comp) => ComponetRequest(
                      id: comp.name,
                      status: comp.status,
                      createdAt: DateTime.now(),
                    ),
                  )
                  .toList()
            : [];
        return Scaffold(
          backgroundColor: Colors.white,
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
                    itemCount: ComponentRequests.length,
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
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Requested ${ComponentRequests[index].id}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    ComponentRequests[index].createdAt != null
                                        ? DateFormat.yMMMd().format(
                                            ComponentRequests[index].createdAt!,
                                          )
                                        : 'No date',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        177,
                                        240,
                                        201,
                                        30,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      ComponentRequests[index].status,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 30),
                                  Icon(Icons.arrow_forward_ios),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // child: ListTile(
                        //   title: Text(
                        //     'Requested ${ComponentRequests[index].id}',
                        //     style: TextStyle(fontWeight: FontWeight.bold),
                        //   ),
                        //   subtitle: Text(
                        //     ComponentRequests[index].createdAt != null
                        //         ? DateFormat.yMMMd().format(ComponentRequests[index].createdAt!)
                        //         : 'No date',
                        //   ),
                        //   trailing: Icon(Icons.arrow_forward_ios),
                        //   onTap: () {
                        //     // Handle component tap
                        //   },
                        // ),
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ComponentAddpage()),
              // );
              context.read<ComponentBloc>().add(
                NavigateToAddComponentEvent(null),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
