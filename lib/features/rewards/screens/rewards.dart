import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mercle/constants/colors.dart';
import 'package:mercle/constants/utils.dart';
import 'package:mercle/providers/user_provider.dart';
import 'package:provider/provider.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  /// Temporary logout functionality for testing
  Future<void> _handleLogout() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // Show confirmation dialog
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text(
                'Are you sure you want to logout? This will clear all your session data.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
      );

      if (shouldLogout == true) {
        // Perform complete logout and cleanup
        await userProvider.logoutAndCleanup();

        // Navigate back to phone verification
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/phone-verification',
            (route) => false,
          );
        }
      }
    } catch (e) {
      print('❌ Error during logout: $e');
      showSnackBar(context, 'Failed to logout. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: InkWell(
          onTap: () {
            _handleLogout();
          },
          child: Container(
            height: 40.h,
            width: 100.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Text("Log out", style: TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}
