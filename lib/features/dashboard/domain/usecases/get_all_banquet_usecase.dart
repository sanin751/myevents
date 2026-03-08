import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/core/error/failures.dart';
import 'package:myevents/core/usecases/app_usecases.dart';
import '../entities/banquet_entity.dart';
import '../../data/repositories/banquet_repository.dart';

final getAllBanquetUsecaseProvider =
    Provider<GetAllBanquetUsecase>((ref) {
  final repo = ref.read(banquetRepositoryProvider);
  return GetAllBanquetUsecase(repository: repo);
});

class GetAllBanquetUsecase
    implements UsecaseWithoutParms<List<BanquetEntity>> {
  final IBanquetRepository repository;

  GetAllBanquetUsecase({required this.repository});

  @override
  Future<Either<Failure, List<BanquetEntity>>> call() {
    return repository.getAllBanquets();
  }
}