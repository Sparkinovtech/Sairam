import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/model/component.dart';

class ComponetRequest {
  final String id;
  final String stud_id;
  final String stud_name;
  final DateTime? createdAt;
  final String status;
  final List<Component> components;

  ComponetRequest({
    required this.id,
    this.createdAt,
    this.status = 'pending',
    this.components = const [],
    this.stud_id = '',
    this.stud_name = '',
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
      stud_id: data['stud_id'] ?? '',
      stud_name: data['stud_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'status': status,
      'components': components.map((c) => c.toJson()).toList(),
      'stud_id': stud_id,
      'stud_name': stud_name,
    };
  }
}
