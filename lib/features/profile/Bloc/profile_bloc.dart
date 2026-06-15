import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/Helper/session_manager.dart';
import '../../../core/repository/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc( {required this.repository}) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_loadProfile);
    on<UpdateProfileEvent>(_updateProfile);
  }

   Future<void> _loadProfile(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final userAutoId = await SessionManager.getUserId();
      if (userAutoId == null) throw Exception("User not logged in");

      final profile = await repository.getProfile(userAutoId);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

   Future<void> _updateProfile(
      UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final userAutoId = await SessionManager.getUserId();
      if (userAutoId == null) throw Exception("User not logged in");

      await repository.updateProfile(
        userAutoId: userAutoId,
        name: event.name,
        address: event.address,
        mobile: event.mobile,
        email: event.email,
        designation: event.designation,
        profileFile: event.profileFile,
      );

      emit(ProfileUpdated());
      add(LoadProfileEvent());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
