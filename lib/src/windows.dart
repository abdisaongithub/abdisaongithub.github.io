import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart' as fl;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
  bool menuOpen = true;

  double containerHeight = 450;
  double containerWidth = 600;

  Duration duration = const Duration(
    milliseconds: 300,
  );

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
              AnimatedOpacity(
                opacity: menuOpen ? 1.0 : 0.0,
                duration: duration,
                child: AnimatedContainer(
                  height: containerHeight,
                  width: containerWidth,
                  duration: duration,
                  margin: EdgeInsets.only(bottom: menuOpen ? 20 : 0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          border: Border(
                            bottom: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Transform.flip(
                              flipX: true,
                              child: const Icon(
                                Icons.search,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Flexible(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Type here to search',
                                  border: InputBorder.none,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          Text(
                            'Pinned',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: containerWidth,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                WindowsIconButton(
                                  image: 'assets/icons/chrome.svg',
                                  onTap: () {},
                                  text: 'Website',
                                ),
                                WindowsIconButton(
                                  image: 'assets/icons/chrome.svg',
                                  onTap: () {},
                                  text: 'Website',
                                ),
                                WindowsIconButton(
                                  image: 'assets/icons/chrome.svg',
                                  onTap: () {},
                                  text: 'Website',
                                ),
                                WindowsIconButton(
                                  image: 'assets/icons/chrome.svg',
                                  onTap: () {},
                                  text: 'Website',
                                ),
                                WindowsIconButton(
                                  image: 'assets/icons/chrome.svg',
                                  onTap: () {},
                                  text: 'Website',
                                ),
                                WindowsIconButton(
                                  image: 'assets/icons/chrome.svg',
                                  onTap: () {},
                                  text: 'Website',
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                WindowsIconButton(
                                  image: 'assets/icons/chrome.svg',
                                  onTap: () {},
                                  text: 'Website',
                                ),
                                WindowsIconButton(
                                  image: 'assets/icons/chrome.svg',
                                  onTap: () {},
                                  text: 'Website',
                                ),
                                WindowsIconButton(
                                  image: 'assets/icons/chrome.svg',
                                  onTap: () {},
                                  text: 'Website',
                                ),
                                WindowsIconButton(
                                  image: 'assets/icons/chrome.svg',
                                  onTap: () {},
                                  text: 'Website',
                                ),
                                WindowsIconButton(
                                  image: 'assets/icons/chrome.svg',
                                  onTap: () {},
                                  text: 'Website',
                                ),
                                WindowsIconButton(
                                  image: 'assets/icons/chrome.svg',
                                  onTap: () {},
                                  text: 'Website',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border:
                                  Border.all(color: Colors.black, width: 0.4),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/cloud.svg',
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            'Abdisa Tsegaye',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: SizedBox()),
                    // WindowsIcon(image: 'image'),
                    InkWell(
                      onTap: () {
                        setState(() {
                          menuOpen = !menuOpen;
                        });
                        debugPrint('$menuOpen');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Image.asset(
                          'assets/icons/windows/start_menu_icon.png',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      fl.FluentIcons.search,
                      size: 28,
                    ),

                    const Expanded(child: SizedBox()),
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
                    width: width ?? 30,
                    height: height ?? 30,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    image,
                    width: width ?? 30,
                    height: height ?? 30,
                    fit: BoxFit.contain,
                  ),
          ),
          text != null
              ? Center(
                  child: Text(
                    text!,
                    style: textMedium.copyWith(
                      color: Colors.black,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
