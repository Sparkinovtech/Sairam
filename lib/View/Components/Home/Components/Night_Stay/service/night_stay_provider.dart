// Provider
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/model/night_stay_student.dart';

class NightStayProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Real-time stream for admin side (already in use)
  Stream<List<NightStayStudent>> get studentsStream {
    return _firestore
        .collection('night_stay_requests')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NightStayStudent.fromFirestore(doc.data()))
              .toList(),
        );
  }

  // Call this when student taps “Yes”
  Future<void> saveNightStay(NightStayStudent student) async {
    try {
      // Use studentId as doc id to avoid duplicates for same student
      await _firestore
          .collection('night_stay_requests')
          .doc(student.studentId)
          .set(student.toMap());
    } catch (e) {
      debugPrint('Error saving night stay request:');
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Call this when student taps “No” to remove their request
  Future<void> deleteNightStay(String studentId) async {
    try {
      await _firestore
          .collection('night_stay_requests')
          .doc(studentId)
          .delete();
    } catch (e) {
      debugPrint('Error deleting night stay request:');
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Optional: method to check if student exists in requests (could be helpful)
  Future<bool> nightStayExists(String studentId) async {
    final doc = await _firestore
        .collection('night_stay_requests')
        .doc(studentId)
        .get();
    return doc.exists;
  }

  // Call this to check if the current user has opted for night stay or not
  Future<bool> hasOptedForNightStay(String studentId) async {
    try {
      final doc = await _firestore
          .collection('night_stay_requests')
          .doc(studentId)
          .get();
      return doc.exists;
    } catch (e) {
      debugPrint('Error checking night stay status:');
      debugPrint(e.toString());
      return false;
    }
  }
}
