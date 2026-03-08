import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myevents/core/api/api_endpoints.dart';
import 'package:myevents/core/services/storage/user_session_service.dart';
import 'package:myevents/core/utils/snackbar_utils.dart';
import 'package:myevents/features/profile/presentation/state/profile_state.dart';
import 'package:myevents/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:myevents/features/profile/presentation/widgets/media_picker_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final primaryOrange = const Color(0xFFE64A19);
  final lightYellow = const Color(0xFFFFF9C4);
  final buttonOrange = const Color(0xFFFFB74D);

  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _isDataLoaded = false;

  final List<XFile?> _profile = [];
  String? _profilePicture;

  final _imagePicker = ImagePicker();

  /// LOAD USER PROFILE
  Future<void> _loadUserData() async {
    final userSession = ref.read(userSessionServiceProvider);
    final userId = userSession.getCurrentUserId();

    if (userId != null && userId.isNotEmpty) {
      _isDataLoaded = false;

      await ref
          .read(profileViewModelProvider.notifier)
          .getProfileById(userId: userId);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  /// CAMERA PERMISSION
  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    return false;
  }

  /// CAMERA IMAGE
  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);

    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _profile.clear();
        _profile.add(photo);
      });
    }
  }

  /// GALLERY IMAGE
  Future<void> _pickFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profile.clear();
        _profile.add(image);
      });
    }
  }

  /// MEDIA PICKER
  void _showMediaPicker() {
    MediaPickerBottomSheet.show(
      context,
      onCameraTap: _pickFromCamera,
      onGalleryTap: _pickFromGallery,
    );
  }

  /// CLEAR IMAGE
  void _clearImage() {
    setState(() {
      _profile.clear();
      _profilePicture = null;
    });
  }

  /// UPDATE PROFILE
  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(profileViewModelProvider.notifier).updateProfile(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            profile: _profile.isNotEmpty ? File(_profile.first!.path) : null,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (next.status == ProfileStatus.loaded &&
          !_isDataLoaded &&
          next.user != null) {
        _isDataLoaded = true;

        _firstNameController.text = next.user!.firstName ?? "";
        _lastNameController.text = next.user!.lastName ?? "";

        _profilePicture = next.user!.profilePicture;
      }

      else if (next.status == ProfileStatus.updated) {
        SnackbarUtils.showSuccess(context, "Profile updated successfully");

        _isDataLoaded = false;

        Navigator.pop(context);
      }

      else if (next.status == ProfileStatus.error &&
          next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: primaryOrange,
        centerTitle: true,
        title: const Text("Edit Profile"),
      ),

      body: profileState.status == ProfileStatus.loading && !_isDataLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    /// PROFILE IMAGE
                    if (_profile.isNotEmpty)
                      GestureDetector(
                        onTap: _showMediaPicker,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  FileImage(File(_profile.first!.path)),
                            ),

                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: _clearImage,
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.close, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )

                    else if (_profilePicture != null &&
                        _profilePicture!.isNotEmpty)
                      GestureDetector(
                        onTap: _showMediaPicker,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                "${ApiEndpoints.baseUrl}${_profilePicture!}",
                              ),
                            ),

                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: _clearImage,
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.close, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )

                    else
                      GestureDetector(
                        onTap: _showMediaPicker,
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.pink,
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),

                    const SizedBox(height: 30),

                    /// FORM
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          _inputField(
                            label: "First Name",
                            icon: Icons.person,
                            hint: "Enter first name",
                            controller: _firstNameController,
                          ),

                          const SizedBox(height: 16),

                          _inputField(
                            label: "Last Name",
                            icon: Icons.person,
                            hint: "Enter last name",
                            controller: _lastNameController,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// SAVE BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonOrange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _handleSubmit,
                        child: const Text("Save Changes"),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// CANCEL
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primaryOrange),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: primaryOrange),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _inputField({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(label),

        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Required";
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.orange),
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFFFFDE7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}