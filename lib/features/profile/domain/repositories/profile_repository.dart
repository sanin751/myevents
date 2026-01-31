import 'package:dartz/dartz.dart';
import 'package:myevents/core/error/failures.dart';
import 'package:myevents/features/profile/domain/entities/profile_entity.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, bool>> updateProfile(ProfileEntity updatedData);
  Future<Either<Failure, ProfileEntity?>> getUserById(String userId);
}