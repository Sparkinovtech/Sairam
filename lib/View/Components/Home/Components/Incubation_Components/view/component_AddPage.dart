import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sairam_incubation/Utils/Constants/colors.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/bloc/component_bloc.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/component.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/view/component_Viewpage.dart';
// import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/view/component_page.dart';
import 'package:sairam_incubation/View/bottom_nav_bar.dart';

class ComponentAddpage extends StatefulWidget {
  final List<ComponentControllers> controllers;

  ComponentAddpage({super.key, required this.controllers});

  @override
  State<ComponentAddpage> createState() => _ComponentAddpageState();
}

class _ComponentAddpageState extends State<ComponentAddpage> {
  // Manage components in state, not in build method

  List<Component> component = [];

  @override
  void initState() {
    super.initState();
    // Initialize with default component controller on page load
    context.read<ComponentBloc>().add(LoadComponentEvent());
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose controllers if needed
    for (var controller in widget.controllers) {
      controller.nameController.dispose();
      controller.quantityController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Make a mutable copy to avoid adding to an unmodifiable list
    List<ComponentControllers> controllersForNav = List.from(
      widget.controllers,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ComponentBloc, ComponentState>(
        listenWhen: (previous, current) =>
            current is NavigateToViewComponentState ||
            current is NavigateToComponentPageState,
        // allow building when the bloc emits ComponentLoaded (or AddComponentState)
        buildWhen: (previous, current) =>
            current is ComponentLoaded || current is ComponentLoading,
        listener: (context, state) async {
          final isActiveRoute = ModalRoute.of(context)?.isCurrent ?? false;
          if (!isActiveRoute) return;
          // Handle navigation or other side effects here if needed
          if (state is NavigateToViewComponentState) {
            component = state.components;
            
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (ctx) => BlocProvider.value(
                  value: context.read<ComponentBloc>(),
                  child: ComponentViewpage(components: component),
                ),
              ),
            );
          }
          if (state is NavigateToComponentPageState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => BlocProvider.value(
                  value: context.read<ComponentBloc>(),
                  child: BottomNavBar(index: 1),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          component = state.components;
          // create a fresh mutable list combining any passed controllers + bloc controllers
          final mergedControllers = List<ComponentControllers>.from(
            widget.controllers,
          )..addAll(state.controllers);
          // keep controllersForNav in sync for bottom nav action
          controllersForNav = List<ComponentControllers>.from(
            mergedControllers,
          );

          if (state is ComponentLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ComponentLoaded) {
            component = state.components;
            final List<ComponentControllers> componentControllers =
                mergedControllers;

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
                            onPressed: () => context.read<ComponentBloc>().add(
                              NavigateToComponentPageEvent(),
                            ),
                            icon: Icon(CupertinoIcons.back),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ),

                        // Notification button
                      ],
                    ),
                  ),
                  SizedBox(height: 8),

                  // Component List
                  Expanded(
                    child: ListView.builder(
                      itemCount: mergedControllers.length,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        return ComponentAdd(
                          controllers: mergedControllers[index],
                          index: index + 1,
                          onDelete: mergedControllers.length > 1
                              ? () {
                                  context.read<ComponentBloc>().add(
                                    RemoveComponent(index),
                                  );
                                }
                              : null,
                        );
                      },
                    ),
                  ),

                  // Add Component Button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<ComponentBloc>().add(AddComponent());
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
            // Replace with your widget
          } else {
            return Container(); // Replace with your widget
          }
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
            context.read<ComponentBloc>().add(
              NavigateToViewComponentEvent(controllersForNav),
            );
          },
          child: Text("View Components", style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
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
