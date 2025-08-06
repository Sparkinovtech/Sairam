import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sairam_incubation/Night_Stay/model/night_stay_student.dart';
import 'package:sairam_incubation/Night_Stay/service/night_stay_provider.dart';

import 'night_stay_event.dart';
import 'night_stay_state.dart';

class NightStayBloc extends Bloc<NightStayEvent, NightStayState> {
  final NightStayProvider _provider;
  StreamSubscription<List<NightStayStudent>>? _streamSubscription;

  NightStayBloc(this._provider) : super(NightStayInitial()) {
    on<SaveNightStayEvent>(_onSaveNightStay);
    on<LoadNightStayStudentsEvent>(_onLoadStudents);
    on<_StudentsUpdated>(
      _onStudentsUpdated,
    ); // Register handler for internal event

    // Automatically start listening for student list changes
    add(LoadNightStayStudentsEvent());
  }

  Future<void> _onSaveNightStay(
    SaveNightStayEvent event,
    Emitter<NightStayState> emit,
  ) async {
    emit(NightStayLoading());
    try {
      if (event.choice == 'Yes') {
        await _provider.saveNightStay(event.student);
        emit(NightStaySuccess());
      } else if (event.choice == 'No') {
        final exists = await _provider.nightStayExists(event.student.studentId);
        if (exists) {
          await _provider.deleteNightStay(event.student.studentId);
        }
        emit(NightStaySuccess());
      } else {
        emit(NightStayFailure('Invalid choice'));
      }
    } catch (e) {
      emit(NightStayFailure(e.toString()));
    }
  }

  Future<void> _onLoadStudents(
    LoadNightStayStudentsEvent event,
    Emitter<NightStayState> emit,
  ) async {
    emit(NightStayLoading());
    await _streamSubscription?.cancel().catchError((_) {});
    _streamSubscription = _provider.studentsStream.listen(
      (students) => add(_StudentsUpdated(students)),
    );
  }

  void _onStudentsUpdated(
    _StudentsUpdated event,
    Emitter<NightStayState> emit,
  ) {
    emit(NightStayLoaded(event.students));
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}

// Internal event class to handle stream updates
class _StudentsUpdated extends NightStayEvent {
  final List<NightStayStudent> students;

  const _StudentsUpdated(this.students);

  @override
  List<Object?> get props => [students];
}
