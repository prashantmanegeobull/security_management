import 'dart:io';

import '../Helper/ApiString.dart';

class UserProfileResponse {
  final int status;
  final UserProfile profile;
  final int taskCount;
  final int newCustomerCount;

  UserProfileResponse({
    required this.status,
    required this.profile,
    required this.taskCount,
    required this.newCustomerCount,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      status: json['status'] ?? 0,
      profile: UserProfile.fromJson(json['profile'] ?? {}),
      taskCount: json['task_count'] ?? 0,
      newCustomerCount: json['new_customer_count'] ?? 0,
    );
  }
}

class UserProfile {
  final String id;
  final String userId;
  final String name;
  final String createdBy;
  final String userType;
  final String email;
  final String mobile;
  final String username;
  final String status;
  final String city;
  final String state;
  final String address;
  final String employeeId;
  final String joiningDate;
  final String salary;
  final String dateOfBirth;
  final int yearlyLeaveQuota;
  final int yearlyLeavesTaken;
  final String profilePhoto;
  final String panAadharNumber;
  final String cancelledChequeImg;
  final String registerDate;
  final String token;
  final int taskCount;

  final File? profileFile;

  UserProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdBy,
    required this.userType,
    required this.email,
    required this.mobile,
    required this.username,
    required this.status,
    required this.city,
    required this.state,
    required this.address,
    required this.employeeId,
    required this.joiningDate,
    required this.salary,
    required this.dateOfBirth,
    required this.yearlyLeaveQuota,
    required this.yearlyLeavesTaken,
    required this.profilePhoto,
    required this.panAadharNumber,
    required this.cancelledChequeImg,
    required this.registerDate,
    required this.token,
    this.profileFile,
    this.taskCount = 0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      createdBy: json['created_by'] ?? '',
      userType: json['user_type'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      username: json['username'] ?? '',
      status: json['status'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      address: json['address'] ?? '',
      employeeId: json['employee_id'] ?? '',
      joiningDate: json['joining_date'] ?? '',
      salary: json['salary'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      yearlyLeaveQuota: json['yearly_leave_quota'] ?? 0,
      yearlyLeavesTaken: json['yearly_leaves_taken'] ?? 0,
      profilePhoto: json['profile_photo'] ?? '',
      panAadharNumber: json['pan_aadhar_number'] ?? '',
      cancelledChequeImg: json['cancelled_cheque_img'] ?? '',
      registerDate: json['register_date'] ?? '',
      token: json['token'] ?? '',
      profileFile: null,
      taskCount: json['task_count'] ?? 0,
    );
  }

  String get profileImageUrl {
    if (profilePhoto.isEmpty) return "";
    return "${ApiString.baseUrl}$profilePhoto";
  }
}