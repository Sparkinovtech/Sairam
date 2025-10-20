part of 'component_bloc.dart';

sealed class ComponentState extends Equatable {
  final Profile? profile;
  const ComponentState({this.profile});

  @override
  List<Object> get props => [];
}

final class ComponentInitial extends ComponentState {
  const ComponentInitial({required super.profile});
}

final class ComponentLoading extends ComponentState {}

final class ComponentLoaded extends ComponentState {
  final List<String> components; // Example data, replace with actual model

  const ComponentLoaded(this.components);

  @override
  List<Object> get props => [components];
}

final class ComponentError extends ComponentState {
  final String message;
  const ComponentError(this.message);

  @override
  List<Object> get props => [message];
}

final class NavigateToAddComponent extends ComponentState {}

final class AddComponentState extends ComponentState {
  final String component; // Example data, replace with actual model

  const AddComponentState(this.component);

  @override
  List<Object> get props => [component];
}

final class NavigateToCart extends ComponentState {
  final List<String> cartItems; // Example data, replace with actual model

  const NavigateToCart(this.cartItems);

  @override
  List<Object> get props => [cartItems];
}

final class ComponentQuantityUpdated extends ComponentState {
  final String component; // Example data, replace with actual model
  final int quantity;

  const ComponentQuantityUpdated(this.component, this.quantity);

  @override
  List<Object> get props => [component, quantity];
}

final class ComponentRemoved extends ComponentState {
  final String component; // Example data, replace with actual model

  const ComponentRemoved(this.component);

  @override
  List<Object> get props => [component];
}

final class ComponentRequestAdded extends ComponentState {
  final String component; // Example data, replace with actual model

  const ComponentRequestAdded(this.component);

  @override
  List<Object> get props => [component];
}
