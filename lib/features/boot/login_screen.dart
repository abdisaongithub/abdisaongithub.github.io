import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../os_mode/cubit/os_mode_cubit.dart';
import '../os_mode/os_mode.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  String _getWallpaper(OSMode mode) {
    switch (mode) {
      case OSMode.windows:
        return 'assets/images/windows_wallpaper.jpg';
      case OSMode.macos:
        return 'assets/images/macos_wallpaper.png';
      case OSMode.linux:
        return 'assets/images/linux_wallpaper.jpg';
      case OSMode.android:
        return 'assets/images/android_wallpaper.jpg';
      case OSMode.ios:
        return 'assets/images/ios_wallpaper.jpg';
      default:
        return 'assets/images/macos_wallpaper.png';
    }
  }

  void _login() async {
    setState(() => _isLoading = true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainSystem(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 200),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OSModeCubit, OSModeState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_getWallpaper(state.mode)),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              // Blur/Dark overlay
              color: Colors.black.withOpacity(0.2), // Slight tint
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Picture
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.white, width: 2),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/profile.jpg'),
                          fit: BoxFit.cover,
                          onError: _onImageError,
                        ),
                      ),
                      child: const Icon(Icons.person,
                          size: 60, color: Colors.grey), // Fallback if no image
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Abdisa Tsegaye',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_isLoading)
                      const CircularProgressIndicator(color: Colors.white)
                    else
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          backgroundColor: Colors.white.withOpacity(0.2),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                        ),
                        child: const Text('Login'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void _onImageError(Object exception, StackTrace? stackTrace) {
    // Silence error
  }
}
