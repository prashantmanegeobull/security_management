import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repository/leave_repository.dart';
import '../leave_response_model.dart';
import 'leave_event.dart';
import 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final LeaveRepository repository;

  LeaveBloc(this.repository) : super(LeaveInitial()) {
    on<FetchLeavesEvent>(_fetchLeaves);
    on<ApplyLeaveEvent>(_applyLeave);
    on<ResetLeaveEvent>(_resetLeaves);
  }

   Future<void> _fetchLeaves(
      FetchLeavesEvent event,
      Emitter<LeaveState> emit,
      ) async {
    emit(LeaveLoading());

    try {
      final LeaveResponse response = await repository.getLeaves(
        userAutoId: event.userAutoId,
        adminAutoId: event.adminAutoId,
        appTypeId: event.appTypeId,
      );

      emit(LeaveLoaded(
        leaves: response.leaves,
        summary: response.summary,
      ));
    } catch (e) {
      emit(LeaveError(e.toString()));
    }
  }

   Future<void> _applyLeave(
      ApplyLeaveEvent event,
      Emitter<LeaveState> emit,
      ) async {
    emit(LeaveLoading());

    try {
       final message = await repository.applyLeave(
        userAutoId: event.userAutoId,
        adminAutoId: event.adminAutoId,
        appTypeId: event.appTypeId,
        leaveType: event.leaveType,
        startDate: event.startDate,
        endDate: event.endDate,
        isHalfDay: event.isHalfDay,
        shift: event.shift,
        reason: event.reason,
         weeklyLeave: event.weeklyLeave,
      );

       final LeaveResponse response = await repository.getLeaves(
        userAutoId: event.userAutoId,
        adminAutoId: event.adminAutoId,
        appTypeId: event.appTypeId,
      );

       emit(LeaveAppliedSuccess(message));

      emit(LeaveLoaded(
        leaves: response.leaves,
        summary: response.summary,
      ));
    } catch (e) {
      emit(LeaveError(e.toString()));
    }
  }


  void _resetLeaves(
      ResetLeaveEvent event,
      Emitter<LeaveState> emit,
      ) {
    emit(LeaveInitial());
  }
}