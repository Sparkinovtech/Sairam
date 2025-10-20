import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sairam_incubation/Utils/Constants/colors.dart';

class ComponentViewpage extends StatefulWidget {
  const ComponentViewpage({super.key});

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
              // Add your component viewing UI here
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10, // Example item count
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
                        Text("Component ${index + 1}"),
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  // Handle edit action
                                },
                              ),
                              Text('5'),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                        IconButton(onPressed: (){}, icon: Icon(Icons.delete))
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
        },
        child: Text("Save Changes"),
      ),
    );
  }
}
