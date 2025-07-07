import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sairam_incubation/Auth/Model/auth_user.dart';
import 'package:sairam_incubation/Profile/Model/profile.dart';

class ProfileCloudFirestoreProvider {
  static final shared = ProfileCloudFirestoreProvider._();
  ProfileCloudFirestoreProvider._();
  factory ProfileCloudFirestoreProvider() => shared;

  final students = FirebaseFirestore.instance.collection("students");

  Future<Profile> createNewProfile({required AuthUser user}) async {
    final String studentId = user.email.split("@").first.toUpperCase();
    Profile studentProfile = Profile(id: studentId, emailAddresss: user.email);
    final studentMap = studentProfile.toJson();
    await students.add(studentMap);

    return studentProfile;
  }
}
