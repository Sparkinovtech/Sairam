class Component {
  final String name;
  String quantity;
  String status;
  Component({
    required this.name,
    required this.quantity,
    this.status = 'Pending',
  });
}
