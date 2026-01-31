class ApiEndpoints {
  ApiEndpoints._();

  //Info: Base URL
  static const String baseUrl = "http://10.0.2.2:5050"; // info: for android
  // static const String baseUrl =
  //     "http://192.168.100.8:3000/api/v1"; // info: for physical device use computers IP

  // Note: For physical device use computer IP: "http:/102.168.x.x:5000/api/v1"

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Hack: ========== Student Endpoints ===========
  static const String userLogin = "/api/auth/login";
  static const String userRegister = "/api/auth/register";
  static const String updateProfile = '/api/auth/update';
  static const String getUser = '/api/auth/users';
}
