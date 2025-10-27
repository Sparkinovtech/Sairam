import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/component.dart';

class ComponetRequest {
  final String? stu_id;
  final String id;
  final DateTime? createdAt;
  final String status;
  final List<Component> components;

  ComponetRequest({
    required this.id,
    this.createdAt,
    this.status = 'pending',
    this.components = const [],
    this.stu_id,
  });

  factory ComponetRequest.fromMap(
    Map<String, dynamic> data,
    String documentId,
  ) {
    // Deserialize components list from Firestore
    List<Component> componentsList = [];
    if (data['components'] != null) {
      componentsList = (data['components'] as List)
          .map((item) => Component.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return ComponetRequest(
      id: documentId,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : null,
      status: data['status'] ?? 'pending',
      components: componentsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt?.toIso8601String(),
      'status': status,
      'components': components.map((c) => c.toJson()).toList(),
    };
  }
}
