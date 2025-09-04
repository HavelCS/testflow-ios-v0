import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mercle/constants/utils.dart';
import 'package:http/http.dart' as http;
import 'package:mercle/features/rewards/screens/lootbox/bytypemodel.dart';
import 'package:mercle/features/rewards/screens/mkey-decor/mKeyDecor-model.dart';
import 'package:mercle/features/rewards/screens/points-history/point-historymodel.dart';
import 'package:mercle/models/daily_scan_model.dart';
import 'package:mercle/services/error_handling.dart';

class RewardsService {
  Future<int> getUserPoints({required BuildContext context}) async {
    try {
      http.Response res = await http.get(
        Uri.parse('http://mockapi.mercle.ai/user/all?platform_id=123456'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      int points = 0;

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          points = jsonDecode(res.body)['currentPoints'] ?? 0;
        },
      );

      return points;
    } catch (error) {
      showSnackBar(context, error.toString());
      return 0;
    }
  }

  Future<Map<String, dynamic>> getDailyScans({
    required BuildContext context,
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse(
          'http://mockapi.mercle.ai/user/dailyscan/state?platform_id=123456',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      int streak = 0;
      DateTime nextScanAt = DateTime.now();
      bool todayScanned = false;

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          streak = jsonDecode(res.body)['streak'] ?? 0;
          nextScanAt = DateTime.parse(
            jsonDecode(res.body)['nextScanAt'] ?? DateTime.now().toString(),
          );
          todayScanned = jsonDecode(res.body)['todayScanned'] ?? false;
        },
      );

      return {
        'streak': streak,
        'nextScanAt': nextScanAt,
        'todayScanned': todayScanned,
      };
    } catch (error) {
      showSnackBar(context, error.toString());
      return {'streak': 0, 'nextScanAt': DateTime.now()};
    }
  }

  Future<List<MkeyDecorModel>> getUserStickers({
    required BuildContext context,
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse('http://mockapi.mercle.ai/user/stickers?platform_id=123456'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      List<MkeyDecorModel> stickers = [];

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          try {
            final Map<String, dynamic> responseData = jsonDecode(res.body);
            print('Response data: $responseData'); // Debug print

            final List<dynamic> stickersJson = responseData['stickers'] ?? [];
            print('Stickers JSON: $stickersJson'); // Debug print

            stickers =
                stickersJson.map((stickerJson) {
                  try {
                    print('Processing sticker: $stickerJson'); // Debug print

                    // Additional type checking
                    if (stickerJson is! Map<String, dynamic>) {
                      print(
                        'Warning: stickerJson is not a Map: ${stickerJson.runtimeType}',
                      );
                      throw Exception(
                        'Invalid sticker data format: ${stickerJson.runtimeType}',
                      );
                    }

                    return MkeyDecorModel.fromJson(stickerJson);
                  } catch (itemError) {
                    print('Error parsing individual sticker: $itemError');
                    print('Problematic sticker data: $stickerJson');
                    rethrow;
                  }
                }).toList();

            print('Parsed ${stickers.length} stickers'); // Debug print
          } catch (parseError) {
            print('Parse error: $parseError');
            showSnackBar(context, 'Error parsing stickers data: $parseError');
          }
        },
      );

      return stickers;
    } catch (error) {
      print('API error: $error');
      showSnackBar(context, error.toString());
      return [];
    }
  }

  Future<List<MkeyDecorModel>> getUserCharms({
    required BuildContext context,
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse('http://mockapi.mercle.ai/user/charms?platform_id=123456'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      List<MkeyDecorModel> charms = [];

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          try {
            final Map<String, dynamic> responseData = jsonDecode(res.body);
            print('Response data: $responseData'); // Debug print

            final List<dynamic> charmsJson = responseData['charms'] ?? [];
            print('Stickers JSON: $charmsJson'); // Debug print

            charms =
                charmsJson.map((charmJson) {
                  try {
                    print('Processing charm: $charmJson'); // Debug print

                    // Additional type checking
                    if (charmJson is! Map<String, dynamic>) {
                      print(
                        'Warning: charmJson is not a Map: ${charmJson.runtimeType}',
                      );
                      throw Exception(
                        'Invalid charm data format: ${charmJson.runtimeType}',
                      );
                    }

                    return MkeyDecorModel.fromJson(charmJson);
                  } catch (itemError) {
                    print('Error parsing individual charm: $itemError');
                    print('Problematic charm data: $charmJson');
                    rethrow;
                  }
                }).toList();

            print('Parsed ${charms.length} charms'); // Debug print
          } catch (parseError) {
            print('Parse error: $parseError');
            showSnackBar(context, 'Error parsing stickers data: $parseError');
          }
        },
      );

      return charms;
    } catch (error) {
      print('API error: $error');
      showSnackBar(context, error.toString());
      return [];
    }
  }

  Future<List<PointHistoryModel>> getUserPointHistory({
    required BuildContext context,
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse(
          'http://mockapi.mercle.ai/user/point-history?platform_id=123456&limit=$limit&skip=$skip',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(res.body);
        final List<dynamic> itemsJson = responseData['items'] ?? [];

        return itemsJson
            .map((item) => PointHistoryModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load point history: ${res.statusCode}');
      }
    } catch (error) {
      showSnackBar(context, error.toString());
      return [];
    }
  }

  Future<ByTypeModel> getByTypeData({required BuildContext context}) async {
    try {
      final response = await http.get(
        Uri.parse('http://mockapi.mercle.ai/user/lootboxes?platform_id=123456'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Extract only the byType data
        final Map<String, dynamic> byTypeData = jsonData['byType'] ?? {};

        return ByTypeModel.fromJson(byTypeData);
      } else {
        throw Exception('Failed to load lootbox data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching byType data: $e');
    }
  }

  Future<List<DailyScanModel>> getDailyScanLast5({
    required BuildContext context,
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse('http://mockapi.mercle.ai/user/dailyscan/last5?platform_id=123456'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      List<DailyScanModel> scanData = [];

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          try {
            final List<dynamic> responseData = jsonDecode(res.body);
            scanData = responseData
                .map((item) => DailyScanModel.fromJson(item as Map<String, dynamic>))
                .toList();
          } catch (parseError) {
            print('Parse error in getDailyScanLast5: $parseError');
            showSnackBar(context, 'Error parsing daily scan data');
          }
        },
      );

      return scanData;
    } catch (error) {
      print('API error in getDailyScanLast5: $error');
      showSnackBar(context, 'Error fetching daily scan data');
      return [];
    }
  }
}
