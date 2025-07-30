import 'dart:io';

class MediaItems {
  final String title;
  final String? description;
  final File file;

  MediaItems({required this.title, this.description, required this.file});

  // Convert MediaItems instance to JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'filePath': file.path, // Store file path as string
    };
  }

  // Create MediaItems instance from JSON (Map)
  factory MediaItems.fromJson(Map<String, dynamic> json) {
    return MediaItems(
      title: json['title'] as String,
      description: json['description'] as String?,
      file: File(
        json['filePath'] as String,
      ), // Reconstruct File from filePath string
    );
  }
}
