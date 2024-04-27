import 'package:fluent_ui/fluent_ui.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/util/launcher.dart';
import 'package:flutter_portfolio_app/util/style_constant.dart';
import 'package:flutter_svg/svg.dart';

class WindowsUI extends StatefulWidget {
  static String id = 'WindowsUI';

  const WindowsUI({Key? key}) : super(key: key);

  @override
  _WindowsUIState createState() => _WindowsUIState();
}

class _WindowsUIState extends State<WindowsUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/windows_wallpaper.jpg',
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: SizedBox()),
                    // WindowsIcon(image: 'image'),
                    Icon(
                      Icons.person,
                      size: 32,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      fl.FluentIcons.search,
                      size: 28,
                    ),

                    Expanded(child: SizedBox()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WindowsIconButton extends StatelessWidget {
  const WindowsIconButton({
    super.key,
    required this.image,
    this.height,
    this.width,
    required this.svg,
    this.onTap,
    this.bgColor,
    this.text,
  });

  final String image;
  final double? height;
  final double? width;
  final bool svg;
  final VoidCallback? onTap;
  final Color? bgColor;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WindowsIcon(
          image: image,
          onTap: onTap,
          width: width,
          height: height,
          bgColor: bgColor,
          text: text,
        ),
      ],
    );
  }
}

class WindowsIcon extends StatelessWidget {
  const WindowsIcon({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.onTap,
    this.bgColor,
    this.text,
  });

  final String image;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final Color? bgColor;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: bgColor ?? Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: image.endsWith('.svg')
                ? SvgPicture.asset(
                    image,
                    width: width ?? 50,
                    height: height ?? 50,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    image,
                    width: width ?? 50,
                    height: height ?? 50,
                    fit: BoxFit.contain,
                  ),
          ),
          text != null
              ? Center(
                  child: Text(
                    text!,
                    style: textMedium,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
