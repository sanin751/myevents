
import 'package:myevents/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthDataSource {
  Future<bool> register(AuthHiveModel user);
  Future<AuthHiveModel?> login(String phoneNumber, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();
}