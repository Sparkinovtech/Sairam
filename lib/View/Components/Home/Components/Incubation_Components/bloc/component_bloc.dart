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
      // Preserve existing components, controllers, AND requests
      if (state is ComponentLoaded) {
        final current = state as ComponentLoaded;
        emit(
          ComponentLoaded(
            List<Component>.from(current.components),
            List<ComponentControllers>.from(current.controllers),
            List<ComponetRequest>.from(current.requests),
          ),
        );
      } else {
        // Initial load - preserve requests from any previous state
        emit(
          ComponentLoaded([], [], List<ComponetRequest>.from(state.requests)),
        );
      }
    });

    on<NavigateToAddComponentEvent>((event, emit) {
      List<ComponentControllers> controllers = [
        ComponentControllers(
          nameController: TextEditingController(),
          quantityController: TextEditingController(),
        ),
      ];

      // Preserve requests from current state
      emit(
        NavigateToAddComponentState(
          controllers,
          List<ComponetRequest>.from(state.requests),
        ),
      );
    });
    on<NavigateToComponentPageEvent>((event, emit) {
      emit(
        NavigateToComponentPageState(
          List<ComponetRequest>.from(state.requests),
        ),
      );
    });
    on<AddComponent>((event, emit) {
      // Handle adding component logic here
      print("Adding component");
      // Only operate when we have a loaded state
      if (state is ComponentLoaded) {
        final current = state as ComponentLoaded;
        final newComponents = current.components.toList();
        final newControllers = current.controllers.toList();
        newComponents.add(Component(name: 'NewComponent', quantity: '0'));
        newControllers.add(
          ComponentControllers(
            nameController: TextEditingController(),
            quantityController: TextEditingController(),
          ),
        );

        emit(
          ComponentLoaded(
            newComponents,
            newControllers,
            List<ComponetRequest>.from(current.requests),
          ),
        );
      }
    });

    on<RemoveComponent>((event, emit) {
      // Handle removing component logic here
      final current = state as ComponentLoaded;
      final newComponents = current.components.toList();
      final newControllers = current.controllers.toList();
      newControllers.removeAt(event.removeIndex - 1);
      print("Removing component at index ${event.removeIndex}");
      emit(
        ComponentLoaded(
          newComponents,
          newControllers,
          List<ComponetRequest>.from(current.requests),
        ),
      );
    });

    on<NavigateToViewComponentEvent>((event, emit) {
      // Build components from controllers
      List<Component> components = event.controllers
          .map(
            (controller) => Component(
              name: controller.nameController.text,
              quantity: controller.quantityController.text,
            ),
          )
          .toList();

      // First emit loaded state with the components so they're in the state
      emit(
        ComponentLoaded(
          components,
          event.controllers,
          List<ComponetRequest>.from(state.requests),
        ),
      );

      // Then emit navigation state
      emit(
        NavigateToViewComponentState(
          components,
          List<ComponetRequest>.from(state.requests),
        ),
      );
    });

    on<IncreaseComponentQuantity>((event, emit) {
      // Handle increasing quantity logic here

      final newComponents = List<Component>.from(state.components);
      newComponents[event.componentIndex].quantity =
          (int.parse(newComponents[event.componentIndex].quantity) + 1)
              .toString();

      // Create new component instances instead of mutating

      emit(
        ComponentLoaded(
          newComponents,
          List<ComponentControllers>.from(state.controllers),
          List<ComponetRequest>.from(state.requests),
        ),
      );
    });

    on<DecreaseComponentQuantity>((event, emit) {
      print("DecreaseComponentQuantity: index=${event.componentIndex}");
      // Handle decreasing quantity logic here

      final newComponents = List<Component>.from(state.components);
      newComponents[event.componentIndex].quantity =
          (int.parse(newComponents[event.componentIndex].quantity) - 1)
              .toString();

      // Create new component instances instead of mutating

      emit(
        ComponentLoaded(
          newComponents,
          List<ComponentControllers>.from(state.controllers),
          List<ComponetRequest>.from(state.requests),
        ),
      );
    });

    on<DeleteComponentFromCart>((event, emit) {
      // Handle deleting component from cart logic here

      final newComponents = state.components.toList();
      newComponents.removeAt(event.componentIndex);
      emit(
        ComponentLoaded(
          newComponents,
          List<ComponentControllers>.from(state.controllers),
          List<ComponetRequest>.from(state.requests),
        ),
      );
    });

    on<SendRequest>((event, emit) {
      // Get existing requests from state
      final currentRequests = List<ComponetRequest>.from(state.requests);
      print("SendRequest: Current requests count = ${currentRequests.length}");

      // Create new request
      final request = ComponetRequest(
        id: 'req_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        status: 'pending',
        components: event.components,
      );

      // Add to list and emit
      currentRequests.add(request);
      print(
        "SendRequest: After adding, total requests = ${currentRequests.length}",
      );
      emit(ComponentRequestAdded(currentRequests));
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
      emit(
        NavigateBackToAddComponentState(
          controllers,
          List<ComponetRequest>.from(state.requests),
        ),
      );
    });
  }
}
