part of 'component_bloc.dart';

sealed class ComponentEvent extends Equatable {
  const ComponentEvent();

  @override
  List<Object> get props => [];
}

final class LoadComponentEvent extends ComponentEvent {}

final class NavigateToAddComponentEvent extends ComponentEvent {
  const NavigateToAddComponentEvent();
}

final class AddComponent extends ComponentEvent {
  final String component; // Example data, replace with actual model

  const AddComponent(this.component);

  @override
  List<Object> get props => [component];
}

final class RemoveComponent extends ComponentEvent {
  final String component; // Example data, replace with actual model

  const RemoveComponent(this.component);

  @override
  List<Object> get props => [component];
}

final class clickViewCart extends ComponentEvent {
  const clickViewCart(this.cartItems);

  final List<String> cartItems;

  @override
  List<Object> get props => [cartItems];
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
  final List<String> cartItems; // Example data, replace with actual model

  const SendRequest(this.cartItems);

  @override
  List<Object> get props => [cartItems];
}
