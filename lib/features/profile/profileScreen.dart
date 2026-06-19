import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_colors2.dart';
import '../../core/theme/app_text_style.dart';
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

  Widget _buildProfileHeader(ProfileLoaded state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            Color(0xFF5B7FFF),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: pickImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  backgroundImage: profileImageFile != null
                      ? FileImage(profileImageFile!)
                      : (state.profile.profilePhoto.isNotEmpty
                      ? NetworkImage(
                      "https://gruzen.in/DSA_Mahesh/public/images/profile/${state.profile.profilePhoto}")
                      : null) as ImageProvider?,
                  child: profileImageFile == null &&
                      state.profile.profilePhoto.isEmpty
                      ? const Icon(
                    Icons.person,
                    size: 55,
                    color: Colors.grey,
                  )
                      : null,
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            state.profile.name,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              state.profile.userType,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .85,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
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
          "Update Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
        print("Current State: ${state.runtimeType}");
        if (state is ProfileError) {
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: state is ProfileLoaded
              ? SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                _buildProfileHeader(state),

                const SizedBox(height: 24),

                _sectionCard(
                  title: "Personal Information",
                  children: [
                    _field("Name", Icons.person, nameCtrl),
                    _field("Address", Icons.home, addressCtrl),
                    _field("Mobile", Icons.phone, mobileCtrl),
                    _field("Email", Icons.email, emailCtrl),
                  ],
                ),

                _sectionCard(
                  title: "Employee Details",
                  children: [
                    _field(
                      "User ID",
                      Icons.badge,
                      userIdCtrl,
                      readOnly: true,
                    ),
                    _field(
                      "Designation",
                      Icons.work,
                      userTypeCtrl,
                      readOnly: true,
                    ),
                  ],
                ),

                const SizedBox(height: 80),
              ],
            ),
          )
              : const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }


  Widget _field(
      String label,
      IconData icon,
      TextEditingController controller, {
        bool readOnly = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor:
          readOnly ? Colors.grey.shade100 : Colors.grey.shade50,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),

          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
