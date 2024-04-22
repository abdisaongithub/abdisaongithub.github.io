import 'dart:io';

import 'package:flutter/foundation.dart';
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
    if (defaultTargetPlatform == TargetPlatform.linux) {
      return const AndroidUI();
    } else if (Platform.isIOS) {
      return Scaffold(
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: const Center(
            child: Text("iOS App"),
          ),
        ),
      );
    } else if (Platform.isWindows) {
      return Scaffold(
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: const Center(
            child: Text("Windows App"),
          ),
        ),
      );
    } else if (Platform.isLinux) {
      return Scaffold(
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: const Center(
            child: Text("Linux App"),
          ),
        ),
      );
    } else if (Platform.isMacOS) {
      return Scaffold(
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: const Center(
            child: Text("MacOS App"),
          ),
        ),
      );
    }
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: const Center(
          child: Text("Could not find OS"),
        ),
      ),
    );
  }
}
