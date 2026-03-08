import '../models/banquet_api_model.dart';

abstract interface class IBanquetRemoteDatasource {
  Future<List<BanquetApiModel>> getAllBanquets();
}