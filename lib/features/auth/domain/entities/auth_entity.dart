import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? password;
  final String? profilePicture;
  final String role; // 'user' or 'admin'

  const AuthEntity({
    this.authId,
    required this.firstName,
    required this.lastName,
    this.email,
    this.password,
    this.profilePicture,
    this.role = 'user',
  });

  @override
  List<Object?> get props => [
    authId,
    firstName,
    lastName,
    email,
    password,
    profilePicture,
    role,
  ];
}
