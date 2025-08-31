import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:app_links/app_links.dart';

enum DeepLinkType {
  faceVerification,
  unknown,
}

class DeepLinkData {
  final DeepLinkType type;
  final Map<String, dynamic> parameters;

  DeepLinkData({
    required this.type,
    required this.parameters,
  });
}

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  // Stream controller to broadcast deep link events
  final _deepLinkStreamController = StreamController<DeepLinkData>.broadcast();
  Stream<DeepLinkData> get deepLinkStream => _deepLinkStreamController.stream;

  // Track if initialization has been done
  bool _isInitialized = false;

  // Initialize deep link handling
  Future<void> initDeepLinks(BuildContext context) async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      // Handle app launched from deep link
      if (Platform.isIOS) {
        // Modern approach using app_links package
        final appLinks = AppLinks();

        // Handle app start link
        final appStartUri = await appLinks.getInitialAppLink();
        if (appStartUri != null) {
          _handleDeepLink(appStartUri.toString(), context);
        }

        // Listen for links when app is running
        appLinks.uriLinkStream.listen((uri) {
          _handleDeepLink(uri.toString(), context);
        });
      } else {
        // Fallback to uni_links for older implementations or Android
        final initialLink = await getInitialLink();
        if (initialLink != null) {
          _handleDeepLink(initialLink, context);
        }

        // Listen for links when app is running
        linkStream.listen((String? link) {
          if (link != null) {
            _handleDeepLink(link, context);
          }
        }, onError: (error) {
          debugPrint('Deep link error: $error');
        });
      }
    } catch (e) {
      debugPrint('Error initializing deep links: $e');
    }
  }

  // Process deep link URI and extract relevant data
  void _handleDeepLink(String link, BuildContext context) {
    debugPrint('Deep link received: $link');

    // Parse the URI
    final uri = Uri.parse(link);
    final pathSegments = uri.pathSegments;
    final queryParams = uri.queryParameters;

    // Determine link type and extract data
    DeepLinkType type = DeepLinkType.unknown;
    final parameters = <String, dynamic>{};

    // Add all query parameters to our parameters map
    parameters.addAll(queryParams);

    // Process specific deep link patterns
    if (link.contains('face-verification') || link.contains('faceverification')) {
      type = DeepLinkType.faceVerification;
      
      // Extract session ID and success status if available
      if (queryParams.containsKey('sessionId')) {
        parameters['sessionId'] = queryParams['sessionId'];
      }
      
      if (queryParams.containsKey('isSuccess')) {
        parameters['isSuccess'] = queryParams['isSuccess'] == 'true';
      }
    }

    // Broadcast the deep link event
    final deepLinkData = DeepLinkData(type: type, parameters: parameters);
    _deepLinkStreamController.add(deepLinkData);
  }

  // Helper method to generate a deep link for face verification
  static String generateFaceVerificationDeepLink({
    required String sessionId,
    bool isSuccess = true,
  }) {
    return 'mercle://face-verification?sessionId=$sessionId&isSuccess=$isSuccess';
  }

  // Helper method to generate a universal link for face verification
  static String generateFaceVerificationUniversalLink({
    required String sessionId,
    bool isSuccess = true,
  }) {
    return 'https://fastapi.mercle.ai/api/deeplink/face-verification?sessionId=$sessionId&isSuccess=$isSuccess';
  }

  // Dispose resources
  void dispose() {
    _deepLinkStreamController.close();
  }
}
