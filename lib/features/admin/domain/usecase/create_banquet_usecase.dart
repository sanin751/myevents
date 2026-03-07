import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myevents/features/admin/data/repository/admin_banquet_repository.dart';
import 'package:myevents/features/dashboard/data/models/banquet_api_model.dart';

final createBanquetUseCaseProvider = Provider<CreateBanquetUseCase>((ref) {
  final repository = ref.read(adminRepositoryProvider);
  return CreateBanquetUseCase(repository);
});

class CreateBanquetUseCase {
  final AdminRepository _repository;

  CreateBanquetUseCase(this._repository);

  Future<BanquetApiModel> call({
    required String title,
    required String location,
    required double price,
    required int capacity,
    String? image,
    String? description,
  }) async {
    return await _repository.createBanquet(
      title: title,
      location: location,
      price: price,
      capacity: capacity,
      image: image,
      description: description,
    );
  }
}