class Component {
  final String name;
  String quantity;
  String status;
  String type;
  Component({
    required this.name,
    required this.quantity,
    this.status = 'Pending',
    this.type = 'non-returnable',
  });

  // Serialization methods for Firestore
  Map<String, dynamic> toJson() {
    return {'name': name, 'quantity': quantity, 'status': status, 'type': type};
  }

  factory Component.fromJson(Map<String, dynamic> json) {
    return Component(
      name: json['name'] as String,
      quantity: json['quantity'] as String,
      status: json['status'] as String? ?? 'Pending',
      type: json['type'] as String? ?? 'non-returnable',
    );
  }
}
