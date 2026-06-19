import 'package:equatable/equatable.dart';

abstract class SalaryEvent extends Equatable {
  const SalaryEvent();

  @override
  List<Object?> get props => [];
}

class FetchSalaryEvent extends SalaryEvent {
  final String userAutoId;
  final String startMonth;
  final String endMonth;

  const FetchSalaryEvent({
    required this.userAutoId,
    required this.startMonth,
    required this.endMonth,
  });

  @override
  List<Object?> get props => [userAutoId, startMonth, endMonth];
}