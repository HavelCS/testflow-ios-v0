class DailyScanModel {
  final String date;
  final bool scannedState;

  DailyScanModel({
    required this.date,
    required this.scannedState,
  });

  factory DailyScanModel.fromJson(Map<String, dynamic> json) {
    return DailyScanModel(
      date: json['date']?.toString() ?? '',
      scannedState: json['scanned_state'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'scanned_state': scannedState,
    };
  }

  @override
  String toString() {
    return 'DailyScanModel(date: $date, scannedState: $scannedState)';
  }
}
