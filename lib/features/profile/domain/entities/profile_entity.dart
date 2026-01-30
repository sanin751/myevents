import 'dart:io';
import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final File? profile;
  final String? password;
  final String? profilePicture;

  const ProfileEntity({
    this.userId,
    this.firstName,
    this.lastName,
    this.profile,
    this.password,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    profile,
    password,
    profilePicture,
  ];
}
