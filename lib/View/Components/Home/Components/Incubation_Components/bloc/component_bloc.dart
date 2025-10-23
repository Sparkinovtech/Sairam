import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sairam_incubation/Profile/Model/profile.dart';
import 'package:sairam_incubation/Profile/service/profile_cloud_firestore_provider.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/component.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/componet_request.dart';
// Note: Do not import view files into bloc to keep layering clean.

part 'component_event.dart';
part 'component_state.dart';

class ComponentBloc extends Bloc<ComponentEvent, ComponentState> {
  final ProfileCloudFirestoreProvider profileProvider;

  ComponentBloc(this.profileProvider)
    : super(ComponentInitial(profile: profileProvider.profile)) {
    on<LoadComponentEvent>((event, emit) {
      // Handle loading components
      emit(ComponentLoading());
      // Simulate loading
      final components = [];
      // create matching controllers
      final controllers = components
          .map(
            (_) => ComponentControllers(
              nameController: TextEditingController(),
              quantityController: TextEditingController(),
            ),
          )
          .toList();
      print("Loaded components: $components");
      emit(ComponentLoaded(List.from(components), List.from(controllers)));
    });

    on<NavigateToAddComponentEvent>((event, emit) {
      List<ComponentControllers> controllers = [];
      if (event.components != null) {
        controllers = event.components!
            .map(
              (controller) => ComponentControllers(
                nameController: TextEditingController(text: controller.name),
                quantityController: TextEditingController(
                  text: controller.quantity,
                ),
              ),
            )
            .toList();
      }
      emit(NavigateToAddComponentState(controllers));
    });
    on<NavigateToComponentPageEvent>((event, emit) {
      emit(NavigateToComponentPageState());
    });
    on<AddComponent>((event, emit) {
      // Handle adding component logic here
      print("Adding component");
      // Only operate when we have a loaded state
      if (state is ComponentLoaded) {
        final current = state as ComponentLoaded;
        final newComponents = state.components.toList();
        final newControllers = state.controllers.toList();
        newComponents.add(Component(name: 'NewComponent', quantity: '0'));
        newControllers.add(
          ComponentControllers(
            nameController: TextEditingController(),
            quantityController: TextEditingController(),
          ),
        );

        emit(ComponentLoaded(newComponents, newControllers));
      }
    });

    on<RemoveComponent>((event, emit) {
      // Handle removing component logic here
      emit(ComponentRemoved(event.component));
    });

    on<NavigateToViewComponentEvent>((event, emit) {
      List<Component> components = event.controllers
          .map(
            (controller) => Component(
              name: controller.nameController.text,
              quantity: controller.quantityController.text,
            ),
          )
          .toList();
      emit(NavigateToViewComponentState(components));
    });

    on<IncreaseComponentQuantity>((event, emit) {
      // Handle increasing quantity logic here
      final newQuantity = 1; // Example logic
      emit(ComponentQuantityUpdated(event.component, newQuantity));
    });

    on<DecreaseComponentQuantity>((event, emit) {
      // Handle decreasing quantity logic here
      final newQuantity = 0; // Example logic
      emit(ComponentQuantityUpdated(event.component, newQuantity));
    });

    on<DeleteComponentFromCart>((event, emit) {
      // Handle deleting component from cart logic here
      emit(ComponentRemoved(event.component));
    });
    List<ComponetRequest> requests = [];
    on<SendRequest>((event, emit) {
      // Handle sending request logic here
      final request = ComponetRequest(
        id: 'req_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        status: 'pending',
        components: event.components,
      );
      requests.add(request);
      emit(ComponentRequestAdded(requests));
    });
    on<NavigateBackToAddComponentEvent>((event, emit) {
      List<ComponentControllers> controllers = event.components
          .map(
            (controller) => ComponentControllers(
              nameController: TextEditingController(text: controller.name),
              quantityController: TextEditingController(
                text: controller.quantity,
              ),
            ),
          )
          .toList();
      emit(NavigateBackToAddComponentState(controllers));
    });
  }
}
