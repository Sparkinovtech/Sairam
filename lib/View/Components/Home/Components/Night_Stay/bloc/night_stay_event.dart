import 'package:equatable/equatable.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/model/night_stay_student.dart';

abstract class NightStayEvent extends Equatable {
  const NightStayEvent();

  @override
  List<Object?> get props => [];
}

// Event to save student's night stay choice
class SaveNightStayEvent extends NightStayEvent {
  final NightStayStudent student;
  final String choice;

  const SaveNightStayEvent(this.student, this.choice);

  @override
  List<Object?> get props => [student, choice];
}

// Event to load/listen to night stay students (optional)
class LoadNightStayStudentsEvent extends NightStayEvent {}


// Add new event for checking current user's night stay status
class CheckNightStayStatusEvent extends NightStayEvent {
  final String studentId;

  const CheckNightStayStatusEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}