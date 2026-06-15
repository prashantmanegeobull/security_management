import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

 class LoadProfileEvent extends ProfileEvent {}

 class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String address;
  final String mobile;
  final String email;
  final String designation;
  final File? profileFile;

  UpdateProfileEvent({
    required this.name,
    required this.address,
    required this.mobile,
    required this.email,
    required this.designation,
    this.profileFile,
  });

  @override
  List<Object?> get props => [name, address, mobile, email, designation, profileFile];
}
