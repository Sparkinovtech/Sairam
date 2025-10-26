part of 'component_bloc.dart';

sealed class ComponentEvent extends Equatable {
  const ComponentEvent();

  @override
  List<Object> get props => [];
}

final class LoadComponentEvent extends ComponentEvent {}

final class NavigateToComponentPageEvent extends ComponentEvent {
  const NavigateToComponentPageEvent();
}

final class NavigateToAddComponentEvent extends ComponentEvent {
  
}

final class AddComponent extends ComponentEvent {
  
}

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

final class IncreaseComponentQuantity extends ComponentEvent {
  final String component; // Example data, replace with actual model

  const IncreaseComponentQuantity(this.component);

  @override
  List<Object> get props => [component];
}

final class DecreaseComponentQuantity extends ComponentEvent {
  final String component; // Example data, replace with actual model

  const DecreaseComponentQuantity(this.component);

  @override
  List<Object> get props => [component];
}

final class DeleteComponentFromCart extends ComponentEvent {
  final String component; // Example data, replace with actual model

  const DeleteComponentFromCart(this.component);

  @override
  List<Object> get props => [component];
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
