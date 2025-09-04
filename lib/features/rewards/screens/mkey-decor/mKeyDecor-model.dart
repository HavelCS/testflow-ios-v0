import 'dart:convert';

class MkeyDecorModel {
  final String imageUrl;
  final String name;
  final String rarity;
  final String collection;
  final DateTime obtainedAt;
  final String description;
  final String? mintAddress;
  final String? itemRef;

  MkeyDecorModel({
    required this.imageUrl,
    required this.name,
    required this.rarity,
    required this.collection,
    required this.obtainedAt,
    required this.description,
    this.mintAddress,
    this.itemRef,
  });

  factory MkeyDecorModel.fromJson(Map<String, dynamic> json) {
    return MkeyDecorModel(
      imageUrl: (json['image'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      rarity: (json['rarity'] ?? '').toString(),
      collection: (json['collection'] ?? '').toString(),
      obtainedAt: _parseDateTime(json['obtainedAt']),
      description: (json['description'] ?? '').toString(),
      mintAddress: json['mintAddress']?.toString(),
      itemRef: json['itemRef']?.toString(),
    );
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    
    if (dateValue is String) {
      return DateTime.tryParse(dateValue) ?? DateTime.now();
    }
    
    if (dateValue is Map<String, dynamic>) {
      // Handle if date is returned as an object
      final dateString = dateValue['\$date'] ?? dateValue.toString();
      return DateTime.tryParse(dateString.toString()) ?? DateTime.now();
    }
    
    // If it's any other type, convert to string and try to parse
    return DateTime.tryParse(dateValue.toString()) ?? DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'image': imageUrl,
      'name': name,
      'rarity': rarity,
      'collection': collection,
      'obtainedAt': obtainedAt.toIso8601String(),
      'description': description,
      if (mintAddress != null) 'mintAddress': mintAddress,
      if (itemRef != null) 'itemRef': itemRef,
    };
  }

  @override
  String toString() {
    return 'MkeyDecorModel(name: $name, rarity: $rarity, collection: $collection)';
  }
}
