// Model
class NightStayStudent {
  final String studentId;
  final String studentName;
  final String scholarType;

  NightStayStudent({
    required this.studentId,
    required this.studentName,
    required this.scholarType,
  });

  factory NightStayStudent.fromFirestore(Map<String, dynamic> data) {
    return NightStayStudent(
      studentId: data['student_id'] ?? '',
      studentName: data['student_name'] ?? '',
      scholarType: data['scholar_type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'scholar_type': scholarType,
    };
  }

  @override
  String toString() {
    return 'NightStudent(studentId: $studentId, studentName: $studentName, scholarType: $scholarType)';
  }
}
