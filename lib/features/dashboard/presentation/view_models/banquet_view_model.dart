import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_all_banquet_usecase.dart';
import '../state/banquet_state.dart';

final banquetViewModelProvider =
    NotifierProvider<BanquetViewModel, BanquetState>(
  BanquetViewModel.new,
);

class BanquetViewModel extends Notifier<BanquetState> {
  late final GetAllBanquetUsecase _getAllBanquetUsecase;

  @override
  BanquetState build() {
    _getAllBanquetUsecase =
        ref.read(getAllBanquetUsecaseProvider);
    return const BanquetState();
  }

  Future<void> fetchBanquets() async {
    state = state.copyWith(status: BanquetStatus.loading);

    final result = await _getAllBanquetUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: BanquetStatus.error,
        errorMessage: failure.message,
      ),
      (banquets) => state = state.copyWith(
        status: BanquetStatus.loaded,
        banquets: banquets,
      ),
    );
  }
}