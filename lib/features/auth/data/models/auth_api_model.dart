import 'package:myevents/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? authId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? password;
 


  AuthApiModel({
    this.authId,
    required this.firstName,
    required this.lastName,
    this.email,
    this.password,
   
    
  });

  // info: To JSON
  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      
    };
  }

  // info: from JSON
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      authId: json["_id"] as String?,
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      email: json["email"] as String?,
     
    );
  }

  // info: to entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      firstName: firstName,
      lastName: lastName,
     
    );
  }

  // info: from entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      authId: entity.authId,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      password: entity.password,

    );
  }

  // info: to entity list
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
