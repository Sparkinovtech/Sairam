import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/component.dart';

class ComponetRequest {
  final String id;
  final DateTime? createdAt;
  final String status;
  final List<Component> components;

  ComponetRequest({
    required this.id,
    this.createdAt,
    this.status = 'pending',
    this.components = const [],
  });

  factory ComponetRequest.fromMap(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return ComponetRequest(
      id: documentId,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : null,
      status: data['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {'createdAt': createdAt?.toIso8601String(), 'status': status};
  }
}
