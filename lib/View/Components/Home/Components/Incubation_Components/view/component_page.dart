import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sairam_incubation/Utils/Constants/colors.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/bloc/component_bloc.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/componet_request.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/view/component_AddPage.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/view/viewRequestPage.dart';

class ComponentPage extends StatefulWidget {
  const ComponentPage({super.key});

  @override
  State<ComponentPage> createState() => _ComponentPageState();
}

class _ComponentPageState extends State<ComponentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ComponentBloc>().add(FetchComponentsEvent());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<ComponentBloc, ComponentState>(
      listener: (context, state) {
        final isActiveRoute = ModalRoute.of(context)?.isCurrent ?? false;
        if (!isActiveRoute) return;
        if (state is NavigateToAddComponentState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => BlocProvider.value(
                value: context.read<ComponentBloc>(),
                child: ComponentAddpage(controllers: state.controllers),
              ),
            ),
          );
        }
      },

      builder: (context, state) {
        if (state is ComponentLoaded) {}
        List<ComponetRequest> ComponentRequests = state.requests;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * .05,
                vertical: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      // Centered title
                      Center(
                        child: Text(
                          "Components",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // List of Requested Components
                  SizedBox(height: size.height * .03),
                  Text(
                    "My Requests",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: size.height * .02),
                  ComponentRequests.isNotEmpty
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: ComponentRequests.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 0,
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
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Viewrequestpage(
                                        request: ComponentRequests[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Requested ${ComponentRequests[index].id.substring(0, 8)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),

                                          SizedBox(height: 4),
                                          Text(
                                            ComponentRequests[index]
                                                        .createdAt !=
                                                    null
                                                ? DateFormat.yMMMd().format(
                                                    ComponentRequests[index]
                                                        .createdAt!,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                              ),
                            );
                          },
                        )
                      : SizedBox(
                          height: 650,
                          child: Center(
                            child: Text(
                              "No Component Requests Found",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: bg,
            foregroundColor: Colors.white,
            onPressed: () {
              context.read<ComponentBloc>().add(NavigateToAddComponentEvent());
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
