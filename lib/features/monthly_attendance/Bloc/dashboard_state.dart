import 'package:equatable/equatable.dart';

import '../../../core/model/dashboard_model.dart';



abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardModel data;

  DashboardLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}