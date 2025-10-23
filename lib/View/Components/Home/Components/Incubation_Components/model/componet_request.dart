class ComponetRequest {
  final String id;
  final DateTime? createdAt;
  final String status;

  ComponetRequest({required this.id, this.createdAt, this.status = 'pending'});

  factory ComponetRequest.fromMap(Map<String, dynamic> data, String documentId) {
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
