import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/core/api/api_client.dart';
import 'package:myevents/core/api/api_endpoints.dart';
import 'package:myevents/features/dashboard/data/datasources/banquet_datasource.dart';
import 'package:myevents/features/dashboard/data/models/banquet_api_model.dart';


final banquetRemoteDatasourceProvider =
    Provider<IBanquetRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return BanquetRemoteDatasource(apiClient: apiClient);
});

class BanquetRemoteDatasource implements IBanquetRemoteDatasource {
  final ApiClient _apiClient;

  BanquetRemoteDatasource({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<BanquetApiModel>> getAllBanquets() async {
    final response = await _apiClient.get(ApiEndpoints.banquets);

    if (response.data["success"] == true) {
      final List<dynamic> banquets = response.data["banquets"];
      return banquets
          .map((json) => BanquetApiModel.fromJson(json))
          .toList();
    }

    return [];
  }
}