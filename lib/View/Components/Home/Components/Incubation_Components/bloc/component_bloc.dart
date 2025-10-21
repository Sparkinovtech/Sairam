import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sairam_incubation/Profile/Model/profile.dart';
import 'package:sairam_incubation/Profile/service/profile_cloud_firestore_provider.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/component.dart';

part 'component_event.dart';
part 'component_state.dart';

class ComponentBloc extends Bloc<ComponentEvent, ComponentState> {
  final ProfileCloudFirestoreProvider profileProvider;
  late List<Component> components;

  ComponentBloc(this.profileProvider, this.components)
    : super(ComponentInitial(profile: profileProvider.profile)) {
    on<LoadComponentEvent>((event, emit) {
      // Handle loading components
      emit(ComponentLoading());
      // Simulate loading
      components = [
        Component(name: 'Component1', quantity: '1'),
        Component(name: 'Component2', quantity: '2'),
      ];
      emit(ComponentLoaded(components));
    });

    on<NavigateToAddComponentEvent>((event, emit) {
      emit(NavigateToAddComponentState());
    });

    on<AddComponent>((event, emit) {
      // Handle adding component logic here
      emit(AddComponentState());
    });

    on<RemoveComponent>((event, emit) {
      // Handle removing component logic here
      emit(ComponentRemoved(event.component));
    });

    on<NavigateToViewComponentEvent>((event, emit) {
      emit(NavigateToViewComponentState(event.components));
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
    on<SendRequest>((event, emit) {
      // Handle sending request logic here
      emit(ComponentRequestAdded(event as String));
    });
  }
}
