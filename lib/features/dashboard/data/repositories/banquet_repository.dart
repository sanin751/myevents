import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/core/error/failures.dart';
import 'package:myevents/core/services/connectivity/network_info.dart';
import '../../domain/entities/banquet_entity.dart';
import '../datasources/banquet_datasource.dart';
import '../datasources/remote/banquet_remote_datasource.dart';

abstract interface class IBanquetRepository {
  Future<Either<Failure, List<BanquetEntity>>> getAllBanquets();
}

final banquetRepositoryProvider =
    Provider<IBanquetRepository>((ref) {
  final remote = ref.watch(banquetRemoteDatasourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return BanquetRepository(
    remoteDatasource: remote,
    networkInfo: networkInfo,
  );
});

class BanquetRepository implements IBanquetRepository {
  final IBanquetRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  BanquetRepository({
    required IBanquetRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<BanquetEntity>>> getAllBanquets() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDatasource.getAllBanquets();
        final entities =
            models.map((model) => model.toEntity()).toList();
        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Failed to fetch banquets",
          ),
        );
      }
    } else {
      return const Left(
          ApiFailure(message: "No internet connection"));
    }
  }
}