import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sairam_incubation/Utils/Constants/colors.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/view/component_Viewpage.dart';

class ComponentAddpage extends StatefulWidget {
  const ComponentAddpage({super.key});

  @override
  State<ComponentAddpage> createState() => _ComponentAddpageState();
}

class _ComponentAddpageState extends State<ComponentAddpage> {
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
                        "Add Component",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.notifications),

                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                        onPressed: () {
                          // Handle back button press
                          Navigator.pop(context);
                        },
                        icon: Icon(CupertinoIcons.back),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [ComponentAdd()],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle save action
                },
                child: Text("add Component"),
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ComponentViewpage(),
            ),
          );
        },
        child: Text("View Components"),
      ),
    );
  }
}

class ComponentAdd extends StatelessWidget {
  const ComponentAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Component Name"),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: "Enter component name",
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Handle scan action
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          SizedBox(height: 20),

          Text("Component Quantity"),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter component quantity",
            ),
          ),
        ],
      ),
    );
  }
}
