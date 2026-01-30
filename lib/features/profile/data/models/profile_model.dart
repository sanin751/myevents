import 'dart:io';

import 'package:myevents/features/profile/domain/entities/profile_entity.dart';

class ProfileModel {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final File? profile;
  final String? password;
  final String? profilePicture;

  ProfileModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.profile,
    this.password,
    this.profilePicture,
  });

  // info: To JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (userId != null) json['userId'] = userId;
    if (firstName != null) json['firstName'] = firstName;
    if (lastName != null) json['lastName'] = lastName;
    if (profile != null) json['profile'] = profile;
    if (password != null) json['password'] = password;
    if (profilePicture != null) json['profilePicture'] = profilePicture;
    return json;
  }

  // info: from JSON
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      firstName: json["firstName"] as String?,
      lastName: json["lastName"] as String?,
      profilePicture: json["profile"] as String?,
      password: json["password"] as String?,
    );
  }

  // info: to entity
  ProfileEntity toEntity() {
    return ProfileEntity(
      userId: userId,
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      profilePicture: profilePicture ?? '',
    );
  }

  // info: from entity
  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      profile: entity.profile,
    );
  }

  // info: to entity list
  static List<ProfileEntity> toEntityList(List<ProfileModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
