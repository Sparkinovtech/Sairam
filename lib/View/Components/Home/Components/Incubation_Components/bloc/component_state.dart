part of 'component_bloc.dart';

sealed class ComponentState extends Equatable {
  final Profile? profile;
  final List<Component> components;
  final List<ComponetRequest> requests;
  final List<ComponentControllers> controllers;
  const ComponentState({
    this.profile,
    this.components = const [],
    this.requests = const [],
    this.controllers = const [],
  });

  @override
  List<Object?> get props => [profile, components, controllers, requests];
}

final class ComponentInitial extends ComponentState {
  const ComponentInitial({required super.profile});
}

final class ComponentLoading extends ComponentState {}

final class ComponentLoaded extends ComponentState {
  const ComponentLoaded(
    List<Component> components,
    List<ComponentControllers> controllers,
    List<ComponetRequest> requests,
  ) : super(
        components: components,
        controllers: controllers,
        requests: requests,
      );
}

final class ComponentError extends ComponentState {
  final String message;
  const ComponentError(this.message);

  @override
  List<Object> get props => [message];
}

// State emitted when navigating to Add Component Page
final class NavigateToAddComponentState extends ComponentState {
  final List<ComponentControllers> controllers;

  const NavigateToAddComponentState(
    this.controllers, [
    List<ComponetRequest> requests = const [],
  ]) : super(controllers: controllers, requests: requests);

  @override
  List<Object> get props => [controllers, requests];
}

// State emitted when navigating Back to Component Page
class NavigateToComponentPageState extends ComponentState {
  const NavigateToComponentPageState([
    List<ComponetRequest> requests = const [],
  ]) : super(requests: requests);

  @override
  List<Object> get props => [requests];
}

// State emitted when navigating to View Component Page
final class NavigateToViewComponentState extends ComponentState {
  final List<Component> components;

  const NavigateToViewComponentState(
    this.components, [
    List<ComponetRequest> requests = const [],
  ]) : super(requests: requests);

  @override
  List<Object> get props => [components, requests];
}

// State emitted when navigating Back to Add Component Page
class NavigateBackToAddComponentState extends ComponentState {
  @override
  // ignore: overridden_fields
  final List<ComponentControllers> controllers;

  const NavigateBackToAddComponentState(
    this.controllers, [
    List<ComponetRequest> requests = const [],
  ]) : super(controllers: controllers, requests: requests);

  @override
  List<Object> get props => [controllers, requests];
}

// State emitted when a component request has been successfully added
final class ComponentRequestAdded extends ComponentState {
  final List<ComponetRequest> requests;

  const ComponentRequestAdded(this.requests) : super(requests: requests);
  @override
  List<Object> get props => [requests];
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
