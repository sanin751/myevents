import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/core/api/api_client.dart';
import 'package:myevents/core/api/api_endpoints.dart';
import 'package:myevents/core/services/storage/token_service.dart';
import 'package:myevents/core/services/storage/user_session_service.dart';
import 'package:myevents/features/auth/data/datasources/auth_datasource.dart';
import 'package:myevents/features/auth/data/models/auth_api_model.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  final _tokenSessionService = ref.read(tokenServiceProvider);
  return AuthRemoteDatasource(
    apiClient: apiClient,
    userSessionService: userSessionService,
    tokenSessionService: _tokenSessionService,
  );
});

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenSessionService = tokenSessionService;

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.userLogin,
      data: {"email": email, "password": password},
    );

    if (response.data["success"] == true) {
      final data = response.data["data"] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);
      final token = response.data['token'] as String;
      await _tokenSessionService.saveToken(token);
      // info: Save user session
      await _userSessionService.saveUserSession(
        userId: user.authId,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
      );
      return user;
    }
    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.userRegister,
      data: user.toJson(),
    );

    if (response.data["success"] == true) {
      final data = response.data["data"] as Map<String, dynamic>;
      final resistedUser = AuthApiModel.fromJson(data);
      return resistedUser;
    }

    return user;
  }
}
