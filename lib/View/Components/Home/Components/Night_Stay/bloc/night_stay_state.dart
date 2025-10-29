import 'package:equatable/equatable.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/model/night_stay_student.dart';

abstract class NightStayState extends Equatable {
  const NightStayState();

  @override
  List<Object?> get props => [];
}

class NightStayInitial extends NightStayState {}

class NightStayLoading extends NightStayState {}

class NightStaySuccess extends NightStayState {}

class NightStayFailure extends NightStayState {
  final String error;

  const NightStayFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// State with current list of students (optional, if used)
class NightStayLoaded extends NightStayState {
  final List<NightStayStudent> students;

  const NightStayLoaded(this.students);

  @override
  List<Object?> get props => [students];
}

// Add new state for night stay status result

// migrated code for checking night stay status to ProfileBloc
class NightStayStatusState extends NightStayState {
  final bool hasOpted;

  const NightStayStatusState(this.hasOpted);

  @override
  List<Object?> get props => [hasOpted];
}
