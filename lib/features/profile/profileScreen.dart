import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../core/theme/app_colors2.dart';
import 'Bloc/profile_bloc.dart';
import 'Bloc/profile_event.dart';
import 'Bloc/profile_state.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final userTypeCtrl = TextEditingController();
  final userIdCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  Uint8List? profileImageBytes; // bytes from API
  File? profileImageFile; // local picked image
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }



  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  final image =
                  await _picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    setState(() => profileImageFile = File(image.path));
                  }

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  final image =
                  await _picker.pickImage(source: ImageSource.camera);

                  if (image != null) {
                    setState(() => profileImageFile = File(image.path));
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {


    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileLoaded) {
          nameCtrl.text = state.profile.name;
          addressCtrl.text = state.profile.address;
          userTypeCtrl.text = state.profile.userType;
          userIdCtrl.text = state.profile.userId;
          mobileCtrl.text = state.profile.mobile;
          emailCtrl.text = state.profile.email;

         }

        if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile updated successfully"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          await Future.delayed(const Duration(seconds: 2));

          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (_) => const main_screen()),
          //       (route) => false,
          // );
        }

        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [

                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profileImageFile != null
                        ? FileImage(profileImageFile!)
                        : (state is ProfileLoaded &&
                        state.profile.profilePhoto.isNotEmpty
                        ? NetworkImage(
                        "https://gruzen.in/DSA_Mahesh/public/images/profile/${state.profile.profilePhoto}")
                        : null),
                    child: profileImageFile == null &&
                        !(state is ProfileLoaded &&
                            state.profile.profilePhoto.isNotEmpty)
                        ? const Icon(Icons.person, size: 45, color: Colors.white)
                        : null,
                  ),
                ),

                const SizedBox(height: 55),

                _field("Name", Icons.person, nameCtrl),
                _field("Address", Icons.home, addressCtrl),
                _field("Designation", Icons.work, userTypeCtrl, readOnly: true),
                _field("User ID", Icons.badge, userIdCtrl, readOnly: true),
                _field("Mobile Number", Icons.phone, mobileCtrl),
                _field("Email", Icons.email, emailCtrl),

                const SizedBox(height: 55),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.darkSkyBlue,
                  ),
                  onPressed: () {
                    context.read<ProfileBloc>().add(
                      UpdateProfileEvent(
                        name: nameCtrl.text,
                        address: addressCtrl.text,
                        mobile: mobileCtrl.text,
                        email: emailCtrl.text,
                        designation: userTypeCtrl.text,
                        profileFile: profileImageFile,
                      ),
                    );
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _field(
      String label,
      IconData icon,
      TextEditingController ctrl, {
        bool readOnly = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: ctrl,
        readOnly: readOnly,
        keyboardType:
        label == "Email" ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
      ),
    );
  }
}
