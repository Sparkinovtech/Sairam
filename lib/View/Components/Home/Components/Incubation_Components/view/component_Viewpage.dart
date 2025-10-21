import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sairam_incubation/Utils/Constants/colors.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/bloc/component_bloc.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/component.dart';

class ComponentViewpage extends StatefulWidget {
  final List<Component> components;

  const ComponentViewpage({super.key, required this.components});

  @override
  State<ComponentViewpage> createState() => _ComponentViewpageState();
}

class _ComponentViewpageState extends State<ComponentViewpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "View Components",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                        onPressed: () {
                          // Handle back button press
                          Navigator.pop(context, widget.components);
                        },
                        icon: Icon(CupertinoIcons.back),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ),
              // Add your component viewing UI here
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.components.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.components[index].name),
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  // Handle edit action
                                  setState(() {
                                    if (int.parse(
                                          widget.components[index].quantity,
                                        ) >
                                        1) {
                                      widget.components[index].quantity =
                                          (int.parse(
                                                    widget
                                                        .components[index]
                                                        .quantity,
                                                  ) -
                                                  1)
                                              .toString();
                                    }
                                  });
                                },
                              ),
                              Text(widget.components[index].quantity),
                              IconButton(
                                onPressed: () {
                                  // Handle edit action
                                  setState(() {
                                    widget.components[index].quantity =
                                        (int.parse(
                                                  widget
                                                      .components[index]
                                                      .quantity,
                                                ) +
                                                1)
                                            .toString();
                                  });
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Handle delete action
                            setState(() {
                              widget.components.removeAt(index);
                            });
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          // Handle save action
          context.read<ComponentBloc>().add(
            SendRequest(components: widget.components),
          );
        },
        child: Text("Save Changes"),
      ),
    );
  }
}
