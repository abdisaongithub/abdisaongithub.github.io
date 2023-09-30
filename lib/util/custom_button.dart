import 'package:flutter/material.dart';
import '../src/theme/theme.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool active;

  const CustomButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.active = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: active ? onTap : null,
      child: Container(
        width: width,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: active
              ? const LinearGradient(
                  colors: <Color>[
                    Color(0xff7C83C8),
                    Color(0xff636AB1),
                  ],
                  // Gradient from https://learnui.design/tools/gradient-generator.html
                )
              : LinearGradient(
                  colors: <Color>[
                    const Color(0xff7C83C8).withOpacity(0.5),
                    const Color(0xff636AB1).withOpacity(0.5),
                  ],
                ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).custom.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
