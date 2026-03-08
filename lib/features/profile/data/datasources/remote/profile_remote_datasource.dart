import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/core/api/api_client.dart';
import 'package:myevents/core/api/api_endpoints.dart';
import 'package:myevents/core/services/storage/token_service.dart';
import 'package:myevents/core/services/storage/user_session_service.dart';
import 'package:myevents/features/profile/data/datasources/profile_datasource.dart';
import 'package:myevents/features/profile/data/models/profile_model.dart';

final profileRemoteDatasourceProvider = Provider<IProfileRemoteDatasource>((
  ref,
) {
  return ProfileRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ProfileRemoteDatasource implements IProfileRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  ProfileRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenService = tokenService;

  /// ================= UPDATE PROFILE =================
  @override
  Future<ProfileModel?> updatePersonalInfo(ProfileModel personalInfo) async {
    try {
      final token = await _tokenService.getToken();

      final formData = FormData.fromMap({
        ...personalInfo.toJson(),

        /// Upload profile image if exists
        if (personalInfo.profile != null)
          'profile': await MultipartFile.fromFile(
            personalInfo.profile!.path,
            filename: 'profile.jpg',
          ),
      });

      final response = await _apiClient.put(
        ApiEndpoints.updateProfile,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;

        final updatedUser = ProfileModel.fromJson(data);

        /// Update session
        await _userSessionService.saveUserSession(
          userId: updatedUser.userId ?? "",
          email: _userSessionService.getCurrentUserEmail() ?? "",
          firstName: updatedUser.firstName ?? "",
          lastName: updatedUser.lastName ?? "",
        );

        return updatedUser;
      }

      return null;
    } catch (e) {
      print("Update profile error: $e");
      return null;
    }
  }

  @override
  Future<ProfileModel?> getUserById(String userId) async {
    if (userId.isEmpty) {
      print("User ID is empty");
      return null;
    }

    final token = await _tokenService.getToken();

    final response = await _apiClient.get(
      '${ApiEndpoints.getUser}/$userId',
      option: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      return ProfileModel.fromJson(response.data['data']);
    }

    return null;
  }
}
