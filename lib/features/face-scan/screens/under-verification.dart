import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mercle/constants/colors.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../providers/user_provider.dart';
import '../../../services/auth_service.dart';
import '../../../services/deep_link_service.dart';

class UnderVerificationScreen extends StatefulWidget {
  final String? sessionId;
  
  const UnderVerificationScreen({super.key, this.sessionId});

  @override
  State<UnderVerificationScreen> createState() =>
      _UnderVerificationScreenState();
}

class _UnderVerificationScreenState extends State<UnderVerificationScreen> {
  Timer? _verificationTimer;
  bool _isPolling = false;
  bool _isProcessing = false;
  int _pollCount = 0;
  static const int _maxPollAttempts = 60; // 2 hours with 2-minute intervals
  StreamSubscription<DeepLinkData>? _deepLinkSubscription;

  @override
  void initState() {
    super.initState();
    // Set up deep link listener to catch redirects from React app
    _setupDeepLinkListener();
    // First call processLivenessResults, then start polling
    _initializeVerification();
  }
  
  Future<void> _initializeVerification() async {
    print('🗣️ Initializing verification - NOT calling liveness APIs yet (waiting for deep link)');
    
    // Start polling for verification status immediately
    // Do NOT call liveness APIs yet - wait for deep link redirect
    Future.delayed(const Duration(seconds: 3), () {
      _startVerificationPolling();
    });
  }
  
  Future<void> _processLivenessResults() async {
    if (widget.sessionId == null) return;
    
    setState(() {
      _isProcessing = true;
    });
    
    try {
      print('🔄 Processing liveness results for session: ${widget.sessionId}');
      
      // Call the processLivenessResults API (this one exists)
      final processResult = await AuthService.processLivenessResults(widget.sessionId!);
      
      // Check if processing was initiated successfully
      String message = processResult['message'] ?? '';
      
      if (processResult['success'] == true || message.contains('Processing initiated')) {
        print('✅ Liveness processing started successfully: $message');
      } else {
        print('❌ Failed to start liveness processing: $message');
        // Only show error if it's a real error, not "Processing initiated"
        if (!message.contains('Processing initiated') && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to start verification: $message'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error in liveness processing: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing scan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _deepLinkSubscription?.cancel();
    super.dispose();
  }
  
  void _setupDeepLinkListener() {
    _deepLinkSubscription = DeepLinkService().deepLinkStream.listen((
      deepLinkData,
    ) {
      if (!mounted) return;

      if (deepLinkData.type == DeepLinkType.faceVerification) {
        final sessionId = deepLinkData.parameters['sessionId'];
        final isSuccess = deepLinkData.parameters['isSuccess'] == true;

        print(
          '🔗 Deep link received in under-verification: sessionId=$sessionId, isSuccess=$isSuccess',
        );

        if (sessionId == widget.sessionId) {
          // This is our session
          _handleDeepLinkResult(isSuccess);
        }
      }
    });
  }
  
  void _handleDeepLinkResult(bool isSuccess) {
    print('🚀 Handling deep link result: isSuccess=$isSuccess');
    
    // Stop polling since we got a result
    _verificationTimer?.cancel();
    setState(() {
      _isPolling = false;
    });
    
    if (isSuccess) {
      // Face scan was successful! NOW call the liveness APIs
      print('✅ Face scan successful! NOW calling liveness processing APIs...');
      _processLivenessResultsAfterScan();
    } else {
      // Face scan failed, navigate back to face scan setup
      print('❌ Face scan failed, navigating back...');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          '/face-scan-setup',
          arguments: {'error': 'Face scan failed. Please try again.'},
        );
      }
    }
  }
  
  Future<void> _processLivenessResultsAfterScan() async {
    print('🎉 Face scan completed! Now processing with backend...');
    
    // Now process the liveness results - AWS session should match Flutter session
    await _processLivenessResults();
    
    // Now check verification status and continue polling
    await _checkVerificationStatus();
    
    // Resume polling if still needed
    if (mounted) {
      _startVerificationPolling();
    }
  }

  void _startVerificationPolling() {
    if (_isPolling) return;

    setState(() {
      _isPolling = true;
      _pollCount = 0;
    });

    print('🔄 Starting verification status polling every 2 minutes...');

    _verificationTimer = Timer.periodic(const Duration(minutes: 2), (
      timer,
    ) async {
      _pollCount++;

      if (_pollCount >= _maxPollAttempts) {
        timer.cancel();
        setState(() {
          _isPolling = false;
        });
        print('⏰ Verification polling timeout after 2 hours');
        return;
      }

      await _checkVerificationStatus();
    });
  }

  Future<void> _checkVerificationStatus() async {
    try {
      print(
        '🔍 Checking verification status (attempt $_pollCount/$_maxPollAttempts) - 2min intervals...',
      );

      // Get current user data to check status
      final result = await AuthService.getCurrentUser();

      if (result['success'] == true) {
        final userData = result['user'];
        final status = userData['status']?.toString();

        print('📊 Current user status: $status');

        if (status == 'verified') {
          print(
            '✅ User verification completed! Updating provider and navigating...',
          );
          _verificationTimer?.cancel();
          setState(() {
            _isPolling = false;
          });

          if (mounted) {
            // Check if it's a duplicate face detection case
            final duplicateDetected = userData['duplicateDetected'] ?? false;
            
            if (duplicateDetected) {
              // Show duplicate face dialog
              _showDuplicateFaceDialog(userData);
            } else {
              // Update user provider with verified user data
              final userProvider = Provider.of<UserProvider>(
                context,
                listen: false,
              );
              
              // Store all user data in provider for state management
              await userProvider.handleVerificationSuccess();

              // Show success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Face is verified'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );

              // Navigate to identity active screen after a brief delay
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/identity-active');
                }
              });
            }
          }
          return;
        } else if (status == 'failed' || status == 'rejected') {
          print('❌ User verification failed: $status');
          _verificationTimer?.cancel();
          setState(() {
            _isPolling = false;
          });

          if (mounted) {
            // Navigate back to face scan setup with error
            Navigator.of(context).pushReplacementNamed(
              '/face-scan-setup',
              arguments: {'error': 'Verification failed. Please try again.'},
            );
          }
          return;
        }

        // Status is still 'pending', continue polling
        print(
          '⏳ Verification still pending, continuing to poll in 2 minutes...',
        );
      } else {
        print('❌ Error getting user data: ${result['message']}');
      }
    } catch (e) {
      print('❌ Exception during verification check: $e');
    }
  }

  void _checkNow() async {
    print('🔍 Manual verification check triggered');
    await _checkVerificationStatus();
  }

  void _showDuplicateFaceDialog(Map<String, dynamic> userData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 10),
              Text(
                'Face Already Registered',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This face is already associated with another account.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Match Confidence: ${((userData['confidence'] ?? 0.0) * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'User ID: ${userData['uid'] ?? 'Unknown'}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'You can either:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text('• Use a different phone number to login to that account'),
              const Text('• Contact support if this is an error'),
              const Text('• Try again with a different face'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate back to face scan setup for retry
                Navigator.of(context).pushReplacementNamed('/face-scan-setup');
              },
              child: const Text('Try Again'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate back to face scan setup
                Navigator.of(context).pushReplacementNamed('/face-scan-setup');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Use Different Number'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(top: 70.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: SvgPicture.asset("assets/images/logo.svg")),

            Container(
              height: 462.h,
              width: 402.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 48.h, left: 32.w, right: 32.w),
                child: Column(
                  children: [
                    Text(
                      'Under verification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 44.sp,
                        fontFamily: 'HandjetRegular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'We’ve put your scan under\nthe verification queue, this might take\nsome time, please check back later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF6C6C6C),
                        fontSize: 16.sp,
                        fontFamily: 'GeistRegular',
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                        letterSpacing: -0.16,
                      ),
                    ),
                    SizedBox(height: 67.h),
                    Container(
                      height: 62.h,
                      width: 338.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        color: Color(0xffF5F5F5),
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Check back after ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.27.sp,
                                fontFamily: 'HandjetRegular',
                                fontWeight: FontWeight.w400,
                                height: 1.45,
                                letterSpacing: -0.22,
                              ),
                            ),
                            TextSpan(
                              text: '1 hour',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.27.sp,
                                fontFamily: 'HandjetRegular',
                                fontWeight: FontWeight.w700,
                                height: 1.45,
                                letterSpacing: -0.22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 52.h),
                    // Check Now button
                    GestureDetector(
                      onTap: _checkNow,
                      child: Container(
                        height: 52.h,
                        width: 161.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'Check Now',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: 'GeistRegular',
                            fontWeight: FontWeight.w400,
                            height: 1.12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
