class ApiEndpoints {
  ApiEndpoints._();

  // Base URL

  // static const String baseUrl = "http://10.0.2.2:5050";
  static const String baseUrl = "http://192.168.1.72:5050";
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ================= AUTH =================
  static const String userLogin = "/api/auth/login";
  static const String userRegister = "/api/auth/register";

  // ================= PROFILE =================
  static const String updateProfile = "/api/auth/update";

  // IMPORTANT
  // This endpoint should return current logged user
  static const String getUser = "/api/auth/users";

  // ================= BANQUETS =================
  static const String banquets = "/api/banquets";

  // ================= ADMIN =================
  static const String adminUsers = "/api/admin";
  static const String adminBanquets = "/api/admin/banquets";

  // ================= OTHER SERVICES =================
  static const String decorations = "/api/decorations";
  static const String photography = "/api/photography";
}