import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mercle/constants/colors.dart';
import 'package:mercle/features/onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash-screen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Don't auto-navigate - let AuthWrapper handle the routing logic
    // The splash screen is only shown while AuthWrapper checks authentication
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(child: SvgPicture.asset("assets/images/logo.svg")),
    );
  }
}
