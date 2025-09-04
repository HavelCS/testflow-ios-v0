class ByTypeModel {
  final int mars;
  final int jupiter;
  final int saturn;

  ByTypeModel({
    required this.mars,
    required this.jupiter,
    required this.saturn,
  });

  factory ByTypeModel.fromJson(Map<String, dynamic> json) {
    return ByTypeModel(
      mars: json['Mars'] ?? 0,
      jupiter: json['Jupiter'] ?? 0,
      saturn: json['Saturn'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'Mars': mars, 'Jupiter': jupiter, 'Saturn': saturn};
  }

  @override
  String toString() {
    return 'ByTypeModel(mars: $mars, jupiter: $jupiter, saturn: $saturn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ByTypeModel &&
        other.mars == mars &&
        other.jupiter == jupiter &&
        other.saturn == saturn;
  }

  @override
  int get hashCode => mars.hashCode ^ jupiter.hashCode ^ saturn.hashCode;
}
