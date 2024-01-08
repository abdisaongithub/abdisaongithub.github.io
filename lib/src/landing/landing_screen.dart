import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/src/android.dart';

class LandingScreen extends StatefulWidget {
  static String id = 'LandingScreen';

  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return const AndroidUI();
  }
}
