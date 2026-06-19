import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Helper/ApiString.dart';
import '../model/profile_model.dart';

class ProfileRepository {

   Future<UserProfile> getProfile(String userAutoId) async {
    final response = await http.post(
      Uri.parse(ApiString.userProfile),
      body: {"user_auto_id": userAutoId},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 1) {
      return UserProfile.fromJson(data['profile']);
    } else {
      throw Exception("Failed to load profile");
    }
  }

   Future<void> updateProfile({
    required String userAutoId,
    required String name,
    required String address,
    required String designation,
    required String mobile,
    required String email,
    File? profileFile,
  }) async {
    var uri = Uri.parse(ApiString.updateProfileUser);
    var request = http.MultipartRequest('POST', uri);

     request.fields['user_auto_id'] = userAutoId;
    request.fields['name'] = name;
    request.fields['address'] = address;
    request.fields['user_type'] = designation;
    request.fields['mobile'] = mobile;
    request.fields['email'] = email;

     if (profileFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_photo',
        profileFile.path,
        filename: profileFile.path.split('/').last,
      ));
    }

     var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    final data = jsonDecode(response.body);

    if (!(response.statusCode == 200 && data['status'] == 1)) {
      throw Exception("Profile update failed");
    }
  }
}
