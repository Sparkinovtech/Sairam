import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageProvider {
  final SupabaseClient supabase;
  final String bucketName;

  SupabaseStorageProvider({required this.supabase, this.bucketName = 'files'});

  /// Upload a file with overwrite enabled and optional MIME type.
  Future<String?> uploadFile(String folderName, File file) async {
    try {
      final fileName = file.path.split('/').last;
      final storagePath = '$folderName/$fileName';

      await supabase.storage
          .from(bucketName)
          .upload(storagePath, file, fileOptions: FileOptions(upsert: true));

      return storagePath;
    } catch (e) {
      // print('Exception uploading file: $e');
      // print(stackTrace);
      return null;
    }
  }

  /// Get a public URL (bucket must be public).
  String getPublicUrl(String filePath) {
    return supabase.storage.from(bucketName).getPublicUrl(filePath);
  }

  /// Delete a file from the bucket.
  Future<bool> deleteFile(String filePath) async {
    final response = await supabase.storage.from(bucketName).remove([filePath]);
    return response.isEmpty;
  }
}
