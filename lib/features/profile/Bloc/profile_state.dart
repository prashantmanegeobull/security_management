import 'package:equatable/equatable.dart';

import '../../../core/model/profile_model.dart';



abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}



class ProfileUpdated extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
