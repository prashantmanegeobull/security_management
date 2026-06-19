import 'package:equatable/equatable.dart';
import '../../../core/model/leave_model.dart';
import '../../../core/model/my_leave_model.dart';
import '../leave_response_model.dart';

abstract class LeaveState extends Equatable {
  @override
  List<Object?> get props => [];
}

 class LeaveInitial extends LeaveState {}

 class LeaveLoading extends LeaveState {}


class LeaveLoaded extends LeaveState {
  final List<LeaveModel> leaves;
  final LeaveSummary summary;

  LeaveLoaded({
    required this.leaves,
    required this.summary,
  });

  @override
  List<Object?> get props => [leaves, summary];
}


 class LeaveAppliedSuccess extends LeaveState {
  final String message;

   LeaveAppliedSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

 class LeaveError extends LeaveState {
  final String message;

   LeaveError(this.message);

  @override
  List<Object?> get props => [message];
}