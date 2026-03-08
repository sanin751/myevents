import 'package:equatable/equatable.dart';
import '../../domain/entities/banquet_entity.dart';

enum BanquetStatus { initial, loading, loaded, error }

class BanquetState extends Equatable {
  final BanquetStatus status;
  final List<BanquetEntity> banquets;
  final String? errorMessage;

  const BanquetState({
    this.status = BanquetStatus.initial,
    this.banquets = const [],
    this.errorMessage,
  });

  BanquetState copyWith({
    BanquetStatus? status,
    List<BanquetEntity>? banquets,
    String? errorMessage,
  }) {
    return BanquetState(
      status: status ?? this.status,
      banquets: banquets ?? this.banquets,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, banquets, errorMessage];
}