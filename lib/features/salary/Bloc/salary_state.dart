import 'package:equatable/equatable.dart';

import '../../../core/model/salary_model.dart';


abstract class SalaryState extends Equatable {
  const SalaryState();

  @override
  List<Object?> get props => [];
}

class SalaryInitial extends SalaryState {}

class SalaryLoading extends SalaryState {}

class SalaryLoaded extends SalaryState {
  final SalaryResponse response;

  const SalaryLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class SalaryError extends SalaryState {
  final String message;

  const SalaryError(this.message);

  @override
  List<Object?> get props => [message];
}