import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sairam_incubation/Utils/Constants/colors.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/bloc/component_bloc.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/component.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/view/component_Viewpage.dart';

class ComponentAddpage extends StatefulWidget {
  const ComponentAddpage({super.key});

  @override
  State<ComponentAddpage> createState() => _ComponentAddpageState();
}

class _ComponentAddpageState extends State<ComponentAddpage> {
  // Manage components in state, not in build method
  List<ComponentControllers> _componentControllers = [];
  List<Component> component = [];

  @override
  void initState() {
    super.initState();
    // Add first component by default
    _addNewComponent();
  }

  void _addNewComponent() {
    setState(() {
      _componentControllers.add(
        ComponentControllers(
          nameController: TextEditingController(),
          quantityController: TextEditingController(),
        ),
      );
    });
  }

  void _removeComponent(int index) {
    if (_componentControllers.length > 1) {
      setState(() {
        _componentControllers[index].nameController.dispose();
        _componentControllers[index].quantityController.dispose();
        _componentControllers.removeAt(index);
      });
    }
  }

  List<Component> _getComponentsList() {
    return _componentControllers
        .map(
          (c) => Component(
            name: c.nameController.text.trim(),
            quantity: c.quantityController.text.trim(),
          ),
        )
        .where((c) => c.name.isNotEmpty && c.quantity.isNotEmpty)
        .toList();
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _componentControllers) {
      controller.nameController.dispose();
      controller.quantityController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ComponentBloc, ComponentState>(
        listener: (context, state) async {
          if (state is NavigateToViewComponentState) {
            List<Component> updatedComponent = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ComponentViewpage(components: _getComponentsList()),
              ),
            );
          }
        },
        builder: (context, state) {
          component = state.components;
          _componentControllers = component
              .map(
                (c) => ComponentControllers(
                  nameController: TextEditingController(text: c.name),
                  quantityController: TextEditingController(text: c.quantity),
                ),
              )
              .toList();
          
          return SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Stack(
                    children: [
                      // Centered title
                      Center(
                        child: Text(
                          "Add Component",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      // Back button
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(CupertinoIcons.back),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ),
                      // Notification button
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: IconButton(
                          onPressed: () {
                            // Handle notification
                          },
                          icon: Icon(CupertinoIcons.bell),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),

                // Component List
                Expanded(
                  child: ListView.builder(
                    itemCount: _componentControllers.length,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      return ComponentAdd(
                        controllers: _componentControllers[index],
                        onDelete: _componentControllers.length > 1
                            ? () => _removeComponent(index)
                            : null,
                        index: index + 1,
                      );
                    },
                  ),
                ),

                // Add Component Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _addNewComponent();
                    },
                    icon: Icon(Icons.add),
                    label: Text("Add Another Component"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: bg,
                      side: BorderSide(color: bg),
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            final components = _getComponentsList();
            if (components.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please add at least one component")),
              );
              return;
            }
            context.read<ComponentBloc>().add(
              NavigateToViewComponentEvent(components),
            );
          },
          child: Text("View Components", style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

// Helper class to hold controllers
class ComponentControllers {
  final TextEditingController nameController;
  final TextEditingController quantityController;

  ComponentControllers({
    required this.nameController,
    required this.quantityController,
  });
}

class ComponentAdd extends StatelessWidget {
  final ComponentControllers controllers;
  final VoidCallback? onDelete;
  final int index;

  const ComponentAdd({
    super.key,
    required this.controllers,
    this.onDelete,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with delete button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Component #$index",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline),
                  color: Colors.red,
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
          SizedBox(height: 16),

          // Component Name
          Text(
            "Component Name",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controllers.nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: bg, width: 2),
              ),
              hintText: "Enter component name",
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 16),

          // Component Quantity
          Text(
            "Component Quantity",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controllers.quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: bg, width: 2),
              ),
              hintText: "Enter quantity",
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
