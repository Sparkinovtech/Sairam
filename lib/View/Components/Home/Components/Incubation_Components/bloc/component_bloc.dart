import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:sairam_incubation/Profile/Model/profile.dart';
import 'package:sairam_incubation/Profile/service/profile_cloud_firestore_provider.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/component.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/componet_request.dart';
// Note: Do not import view files into bloc to keep layering clean.

part 'component_event.dart';
part 'component_state.dart';

class ComponentBloc extends Bloc<ComponentEvent, ComponentState> {
  final ProfileCloudFirestoreProvider profileProvider;

  ComponentBloc(this.profileProvider) : super(ComponentInitial()) {
    on<LoadComponentEvent>((event, emit) {
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
        emit(
          ComponentLoaded([], [], List<ComponetRequest>.from(state.requests)),
        );
      }
    });

    /// ----------  Component Page Events -----------

    // Navigate to Add Component Page
    on<NavigateToAddComponentEvent>((event, emit) {
      List<ComponentControllers> controllers = [
        ComponentControllers(
          nameController: TextEditingController(),
          quantityController: TextEditingController(),
        ),
      ];

      List<ComponetRequest> request = List<ComponetRequest>.from(
        state.requests,
      );

      emit(NavigateToAddComponentState(controllers, request));
    });

    on<FetchComponentsEvent>((event, emit) {
      // Fetch components logic here
      List<ComponetRequest> request = [
        ComponetRequest(
          id: 'req_1',
          createdAt: DateTime.now(),
          status: 'pending',
          components: [
            Component(name: 'Component A', quantity: '2'),
          Component(name: 'Component B', quantity: '5'),
        ],
        profile: null,
      )];

      emit(
        ComponentLoaded(
          List<Component>.from(state.components),
          List<ComponentControllers>.from(state.controllers),
          List<ComponetRequest>.from([request]),
        ),
      );
    });

    /// -------- End of Component Page Events -----------

    /// ------- Component Add Page Events -------

    // Navigate back to Component Page
    on<NavigateToComponentPageEvent>((event, emit) {
      emit(
        NavigateToComponentPageState(
          List<ComponetRequest>.from(state.requests),
        ),
      );
    });

    // Add Component
    on<AddComponent>((event, emit) {
      // Handle adding component logic here

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

    // Remove Component
    on<RemoveComponent>((event, emit) {
      // Handle removing component logic here
      final current = state as ComponentLoaded;
      final newComponents = current.components.toList();
      final newControllers = current.controllers.toList();
      newControllers.removeAt(event.removeIndex - 1);
      emit(
        ComponentLoaded(
          newComponents,
          newControllers,
          List<ComponetRequest>.from(current.requests),
        ),
      );
    });

    // Navigate to View Component Page
    on<NavigateToViewComponentEvent>((event, emit) {
      List<Component> components = event.controllers
          .map(
            (controller) => Component(
              name: controller.nameController.text,
              quantity: controller.quantityController.text,
            ),
          )
          .toList();

      emit(
        ComponentLoaded(
          components,
          event.controllers,
          List<ComponetRequest>.from(state.requests),
        ),
      );

      emit(
        NavigateToViewComponentState(
          components,
          List<ComponetRequest>.from(state.requests),
        ),
      );
    });

    /// -------- End of Component Add page Events -----------

    /// ------- Component View Page Events -------

    // Increase Component Quantity
    on<IncreaseComponentQuantity>((event, emit) {
      final newComponents = List<Component>.from(state.components);
      newComponents[event.componentIndex].quantity =
          (int.parse(newComponents[event.componentIndex].quantity) + 1)
              .toString();

      emit(
        ComponentLoaded(
          newComponents,
          List<ComponentControllers>.from(state.controllers),
          List<ComponetRequest>.from(state.requests),
        ),
      );
    });

    // Decrease Component Quantity
    on<DecreaseComponentQuantity>((event, emit) {
      // Handle decreasing quantity logic here

      final newComponents = List<Component>.from(state.components);
      newComponents[event.componentIndex].quantity =
          (int.parse(newComponents[event.componentIndex].quantity) - 1)
              .toString();

      emit(
        ComponentLoaded(
          newComponents,
          List<ComponentControllers>.from(state.controllers),
          List<ComponetRequest>.from(state.requests),
        ),
      );
    });

    // Delete Component from Cart
    on<DeleteComponentFromCart>((event, emit) {
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
    // Send Component Request
    on<SendRequest>((event, emit) {
      // Get existing requests from state
      final currentRequests = List<ComponetRequest>.from(state.requests);

      // Create new request
      final request = ComponetRequest(
        profile: profileProvider.profile,
        id: 'req_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        status: 'pending',
        components: List<Component>.from(event.components),
      );

      currentRequests.add(request);
      emit(
        ComponentRequestAdded(
          requests: currentRequests,
          components: List<Component>.from(state.components),
          controllers: List<ComponentControllers>.from(state.controllers),
        ),
      );
    });

    // Navigate back to Add Component Page
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

  /// -------- End of Component View Page Events --------
}
