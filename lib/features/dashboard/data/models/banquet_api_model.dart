import '../../domain/entities/banquet_entity.dart';

class BanquetApiModel {
  final String? banquetId;
  final String title;
  final String description;
  final String location;
  final int capacity;
  final double price;
  final String? image;
  final bool isAvailable;

  BanquetApiModel({
    this.banquetId,
    required this.title,
    required this.description,
    required this.location,
    required this.capacity,
    required this.price,
    this.image,
    required this.isAvailable,
  });

  factory BanquetApiModel.fromJson(Map<String, dynamic> json) {
    return BanquetApiModel(
      banquetId: json["_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      location: json["location"] ?? "",
      capacity: json["capacity"] ?? 0,
      price: (json["price"] ?? 0).toDouble(),
      image: json["image"],
      isAvailable: json["isAvailable"] ?? false,
    );
  }

  BanquetEntity toEntity() {
    return BanquetEntity(
      banquetId: banquetId,
      title: title,
      description: description,
      location: location,
      capacity: capacity,
      price: price,
      image: image,
      isAvailable: isAvailable,
    );
  }

  static List<BanquetEntity> toEntityList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => BanquetApiModel.fromJson(json).toEntity())
        .toList();
  }
}
