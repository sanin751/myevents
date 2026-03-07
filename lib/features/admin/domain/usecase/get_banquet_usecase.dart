import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myevents/features/admin/data/repository/admin_banquet_repository.dart';

final getBanquetsUseCaseProvider = Provider<GetBanquetsUseCase>((ref) {
  final repository = ref.read(adminRepositoryProvider);
  return GetBanquetsUseCase(repository);
});

class GetBanquetsUseCase {
  final AdminRepository _repository;

  GetBanquetsUseCase(this._repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int size = 10,
    String? search,
  }) async {
    return await _repository.getBanquets(
      page: page,
      size: size,
      search: search,
    );
  }
}