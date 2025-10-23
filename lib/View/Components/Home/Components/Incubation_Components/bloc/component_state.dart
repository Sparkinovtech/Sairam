part of 'component_bloc.dart';

sealed class ComponentState extends Equatable {
  final Profile? profile;
  final List<Component> components;
  final List<ComponentControllers> controllers;
  const ComponentState({
    this.profile,
    this.components = const [],
    this.controllers = const [],
  });

  @override
  List<Object?> get props => [profile, components, controllers];
}

final class ComponentInitial extends ComponentState {
  const ComponentInitial({required super.profile});
}

final class ComponentLoading extends ComponentState {}

final class ComponentLoaded extends ComponentState {
  const ComponentLoaded(
    List<Component> components,
    List<ComponentControllers> controllers,
  ) : super(components: components, controllers: controllers);
}

final class ComponentError extends ComponentState {
  final String message;
  const ComponentError(this.message);

  @override
  List<Object> get props => [message];
}

final class NavigateToAddComponentState extends ComponentState {
  final List<ComponentControllers> controllers;

  const NavigateToAddComponentState(this.controllers)
    : super(controllers: controllers);

  @override
  List<Object> get props => [controllers];
}

final class AddComponentState extends ComponentState {
  const AddComponentState(List<ComponentControllers> controllers)
    : super(controllers: controllers);
}

final class NavigateToViewComponentState extends ComponentState {
  final List<Component> components;

  const NavigateToViewComponentState(this.components);

  @override
  List<Object> get props => [components];
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

// Lightweight holder for TextEditingControllers so bloc/state can manage them
class ComponentControllers {
  final TextEditingController nameController;
  final TextEditingController quantityController;

  ComponentControllers({
    required this.nameController,
    required this.quantityController,
  });
}

class NavigateToComponentPageState extends ComponentState {}
