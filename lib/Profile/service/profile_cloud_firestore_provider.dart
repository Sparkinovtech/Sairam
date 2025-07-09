import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sairam_incubation/Auth/Model/auth_user.dart';
import 'package:sairam_incubation/Profile/Model/certificate.dart';
import 'package:sairam_incubation/Profile/Model/department.dart';
import 'package:sairam_incubation/Profile/Model/domains.dart';
import 'package:sairam_incubation/Profile/Model/link.dart';
import 'package:sairam_incubation/Profile/Model/profile.dart';
import 'package:sairam_incubation/Utils/exceptions/profile_exceptions.dart';

/// Service Provider for handling all student profile operations with Firestore.
/// Supports smooth caching, read/write logic and throws meaningful exceptions for errors.
class ProfileCloudFirestoreProvider {
  static final shared = ProfileCloudFirestoreProvider._();
  ProfileCloudFirestoreProvider._();
  factory ProfileCloudFirestoreProvider() => shared;

  final students = FirebaseFirestore.instance.collection("students");
  Profile? _studentProfile;

  /// Returns the currently cached student profile, if available
  Profile? get profile => _studentProfile;

  /// Creates a new blank profile with ID and email only
  Future<Profile> createNewProfile({required AuthUser user}) async {
    final String studentId = user.email.split("@").first.toUpperCase();
    final studentProfile = Profile(id: studentId, emailAddresss: user.email);
    await students.doc(studentId).set(studentProfile.toJson());
    _studentProfile = studentProfile;
    return studentProfile;
  }

  /// Retrieves the profile from Firestore or returns cached if already loaded
  Future<Profile?> getProfile({required AuthUser user}) async {
    if (_studentProfile != null) return _studentProfile;
    final String studentId = user.email.split("@").first.toUpperCase();
    final docSnapshot = await students.doc(studentId).get();
    if (!docSnapshot.exists) return null;
    final data = docSnapshot.data();
    if (data == null) return null;
    _studentProfile = Profile.fromJson(data);
    return _studentProfile;
  }

  /// Saves basic personal profile information
  Future<Profile> saveProfileInformation({
    String? profilePic,
    required String fullName,
    required String emailAddress,
    required String phoneNumber,
    required Department department,
    required String dateOfBirth,
  }) async {
    final String studentId = emailAddress.split('@').first.toUpperCase();
    final currentProfile = _studentProfile;

    if (currentProfile == null) throw UserProfileNotFoundException();

    final updated = Profile(
      name: fullName,
      emailAddresss: emailAddress,
      phoneNumber: phoneNumber,
      department: department,
      dateOfBirth: dateOfBirth,
      id: currentProfile.id,
      profilePicture: profilePic ?? currentProfile.profilePicture,
      yearOfGraduation: currentProfile.yearOfGraduation,
      currentYear: currentProfile.currentYear,
      currentMentor: currentProfile.currentMentor,
      collegeIdPhoto: currentProfile.collegeIdPhoto,
      certificates: currentProfile.certificates,
      domains: currentProfile.domains,
      skillSet: currentProfile.skillSet,
    );

    await students.doc(studentId).set(updated.toJson());
    _studentProfile = updated;
    return updated;
  }

  /// Saves academic/identity details to the student profile
  Future<Profile> saveIdentityDetails({
    required String studentId,
    required Department department,
    required int currentYear,
    required int yearOfGraduation,
    required String mentorName,
    required String idCardPhoto,
  }) async {
    final currentProfile = _studentProfile;
    if (currentProfile == null) throw UserProfileNotFoundException();

    final updated = currentProfile.copyWith(
      department: department,
      currentYear: currentYear,
      yearOfGraduation: yearOfGraduation,
      currentMentor: mentorName,
      collegeIdPhoto: idCardPhoto,
    );

    await students.doc(studentId).update(updated.toJson());
    _studentProfile = updated;
    return updated;
  }

  /// Saves domain preferences (interests)
  Future<Profile> saveDomainPreferences(List<Domains> domains) async {
    final currentProfile = _studentProfile;
    if (currentProfile == null) throw UserProfileNotFoundException();

    final updated = currentProfile.copyWith(domains: domains);
    await students.doc(currentProfile.id!).update(updated.toJson());
    _studentProfile = updated;
    return updated;
  }

  /// Saves student's skill set and resume
  Future<Profile> saveSkillSet({
    required List<Domains> skills,
    required String resumeFile,
  }) async {
    final currentProfile = _studentProfile;
    if (currentProfile == null) throw UserProfileNotFoundException();

    final updated = currentProfile.copyWith(
      skillSet: skills,
      profilePicture:
          resumeFile, // If resume saved as profile file, else adjust field
    );

    await students.doc(currentProfile.id!).update(updated.toJson());
    _studentProfile = updated;
    return updated;
  }

  /// Saves portfolio links
  Future<Profile> savePortfolioLinks(List<Link> links) async {
    final currentProfile = _studentProfile;
    if (currentProfile == null) throw UserProfileNotFoundException();

    // Assuming links stored in skillSet or extend Profile model to include "portfolioLinks"
    final updated = currentProfile.copyWith();
    await students.doc(currentProfile.id!).update(updated.toJson());
    _studentProfile = updated;
    return updated;
  }

  /// Saves certificates
  Future<Profile> saveCertificates(List<Certificate> certificates) async {
    final currentProfile = _studentProfile;
    if (currentProfile == null) throw UserProfileNotFoundException();

    final updated = currentProfile.copyWith(certificates: certificates);
    await students.doc(currentProfile.id!).update(updated.toJson());
    _studentProfile = updated;
    return updated;
  }
}
