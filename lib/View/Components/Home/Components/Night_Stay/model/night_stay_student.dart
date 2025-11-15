import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/model/mentor_name.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/model/stay_reason.dart';

class NightStayStudent {
  final String studentId;
  final String studentName;
  final String scholarType;
  final bool dinner;
  final bool lunch;
  final bool breakfast;
  final StayReason? stayreason;
  final String? reasonStatement;
  final MentorName? mentorName;

  NightStayStudent({
    required this.studentId,
    required this.studentName,
    required this.scholarType,
    required this.dinner,
    required this.lunch,
    required this.breakfast,
    this.stayreason,
    this.reasonStatement,
    this.mentorName,
  });

  factory NightStayStudent.fromFirestore(Map<String, dynamic> data) {
    return NightStayStudent(
      studentId: data['student_id'] ?? '',
      studentName: data['student_name'] ?? '',
      scholarType: data['scholar_type'] ?? '',
      dinner: data['dinner'] ?? false,
      lunch: data['lunch'] ?? false,
      breakfast: data['breakfast'] ?? false,
      stayreason: (data['stay_reason'] != null)
          ? StayReasonExtension.fromMap(data['stay_reason'])
          : StayReason.adAstra, // or any default of your choice

      reasonStatement: data['reason_statement'] ?? '',
      mentorName: (data['mentor_name'] is String)
          ? MentorNameExtension.fromMap(data['mentor_name'])
          : MentorName.startup, // or any default value you prefer
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'scholar_type': scholarType,
      'dinner': dinner,
      'lunch': lunch,
      'breakfast': breakfast,
      'stay_reason': stayreason?.name,
      'reason_statement': reasonStatement,
      'mentor_name': mentorName?.name,
    };
  }

  @override
  String toString() {
    return 'NightStayStudent(studentId: $studentId, studentName: $studentName, scholarType: $scholarType, dinner: $dinner, lunch: $lunch, breakfast: $breakfast, stayreason: $stayreason, reasonStatement: $reasonStatement, mentorName: $mentorName)';
  }
}
