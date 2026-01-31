import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/core/error/failures.dart';
import 'package:myevents/core/usecases/app_usecases.dart';
import 'package:myevents/features/auth/data/repositories/auth_repository.dart';
import 'package:myevents/features/auth/domain/entities/auth_entity.dart';
import 'package:myevents/features/auth/domain/repositories/auth_repository.dart';


class RegisterParams extends Equatable {
  final String firstName;
  final String lastName;
  final String password;
  final String? email;
  

  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.password,
    this.email,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    password,
    email,
  ];
}

// Create Provider
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase implements UsecaseWithParms<bool, RegisterParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterParams params) {
    final authEntity = AuthEntity(
      firstName: params.firstName,
      lastName: params.lastName,
      password: params.password,
      email: params.email,
    
    );

    return _authRepository.register(authEntity);
  }
}