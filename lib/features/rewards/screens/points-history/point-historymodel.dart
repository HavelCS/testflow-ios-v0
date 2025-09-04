import 'dart:convert';

class PointHistoryModel {
  String event;
  String datetime;
  int points;

  PointHistoryModel({
    required this.event,
    required this.datetime,
    required this.points,
  });

  factory PointHistoryModel.fromJson(Map<String, dynamic> json) {
    return PointHistoryModel(
      event: json['event'] ?? '',
      datetime: json['datetime'] ?? '',
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'event': event, 'datetime': datetime, 'points': points};
  }
}
