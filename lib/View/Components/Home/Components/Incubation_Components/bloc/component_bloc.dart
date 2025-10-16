import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'component_event.dart';
part 'component_state.dart';

class ComponentBloc extends Bloc<ComponentEvent, ComponentState> {
  ComponentBloc() : super(ComponentInitial()) {
    on<LoadComponentEvent>((event, emit) {
      // Handle loading components
      emit(ComponentLoading());
      // Simulate loading
      final components = <String>['Component1', 'Component2']; // Example data
      emit(ComponentLoaded(components));
    });

    on<NavigateToAddComponentEvent>((event, emit) {
      emit(NavigateToAddComponent());
    });

    on<AddComponent>((event, emit) {
      // Handle adding component logic here
      emit(AddComponentState(event.component));
    });

    on<RemoveComponent>((event, emit) {
      // Handle removing component logic here
      emit(ComponentRemoved(event.component));
    });

    on<clickViewCart>((event, emit) {
      emit(NavigateToCart(event.cartItems));
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
