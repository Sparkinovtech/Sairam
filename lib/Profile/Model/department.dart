enum Department {
  cse,
  iot,
  it,
  aids,
  aiml,
  cyberSecurity,
  csbs,
  cce,
  ece,
  eee,
  me,
}

extension DepartmentName on Department {
  String get departmentName {
    switch (this) {
      case Department.cse:
        return "Computer Science And Engineering";
      case Department.iot:
        return "Internet of Things";
      case Department.it:
        return "Information Technology";
      case Department.aids:
        return "Artificial Intelligence and Data Science";
      case Department.aiml:
        return "Artificial Intelligence and Machine Learning";
      case Department.cyberSecurity:
        return "Cyber Security";
      case Department.csbs:
        return "Computer Science and Business Systems";
      case Department.cce:
        return "Computer Science and Communication Engineering";
      case Department.ece:
        return "Electrical and Communication Engineering";
      case Department.eee:
        return "Electrical and Electronics Engineering";
      case Department.me:
        return "Mechanical Engineering";
    }
  }
}
