part of 'component_bloc.dart';

sealed class ComponentEvent extends Equatable {
  const ComponentEvent();

  @override
  List<Object> get props => [];
}

final class LoadComponentEvent extends ComponentEvent {}

// Events for Component Page

final class FetchComponentsEvent extends ComponentEvent {}

final class NavigateToAddComponentEvent extends ComponentEvent {}

// Events for Component Add Page

final class NavigateToComponentPageEvent extends ComponentEvent {
  const NavigateToComponentPageEvent();
}

final class AddComponent extends ComponentEvent {}

final class RemoveComponent extends ComponentEvent {
  final int removeIndex;

  const RemoveComponent(this.removeIndex);

  @override
  List<Object> get props => [removeIndex];
}

final class NavigateToViewComponentEvent extends ComponentEvent {
  const NavigateToViewComponentEvent(this.controllers);

  final List<ComponentControllers> controllers;

  @override
  List<Object> get props => [controllers];
}

// Events for Component View Page

final class IncreaseComponentQuantity extends ComponentEvent {
  final int componentIndex;

  const IncreaseComponentQuantity(this.componentIndex);

  @override
  List<Object> get props => [componentIndex];
}

final class DecreaseComponentQuantity extends ComponentEvent {
  final int componentIndex;

  const DecreaseComponentQuantity(this.componentIndex);

  @override
  List<Object> get props => [componentIndex];
}

final class DeleteComponentFromCart extends ComponentEvent {
  final int componentIndex;

  const DeleteComponentFromCart(this.componentIndex);

  @override
  List<Object> get props => [componentIndex];
}

final class SendRequest extends ComponentEvent {
  final List<Component> components;

  const SendRequest({required this.components});

  @override
  List<Object> get props => [components];
}

class NavigateBackToAddComponentEvent extends ComponentEvent {
  final List<Component> components;

  const NavigateBackToAddComponentEvent(this.components);

  @override
  List<Object> get props => [components];
}
