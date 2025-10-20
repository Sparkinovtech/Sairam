class Request {
  final String id;
  final DateTime? createdAt;
  final String status;

  Request({
    required this.id,
    this.createdAt,
    this.status = 'pending',
  });

  factory Request.fromMap(Map<String, dynamic> data, String documentId) {
    return Request(
      id: documentId,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : null,
      status: data['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt?.toIso8601String(),
      'status': status,
    };
  }
}