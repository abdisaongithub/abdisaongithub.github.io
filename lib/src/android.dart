import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/util/color.dart';
import 'package:flutter_portfolio_app/util/launcher.dart';
import 'package:flutter_portfolio_app/util/style_constant.dart';
import 'package:flutter_svg/svg.dart';

class AndroidUI extends StatefulWidget {
  static String id = 'AndroidUI';

  const AndroidUI({Key? key}) : super(key: key);

  @override
  _AndroidUIState createState() => _AndroidUIState();
}

class _AndroidUIState extends State<AndroidUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width
              : 400,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/android_wallpaper.jpg',
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const AndroidIcon(
                        image: 'assets/images/cloud.svg',
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        '33°',
                        style: jumboText,
                      ),
                    ],
                  ),
                  Text(
                    'Partly Cloudy',
                    style: h3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: CustomColor.whito,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        'Addis Ababa',
                        style: h3,
                      ),
                    ],
                  ),
                  Text(
                    'UV Index: Perfect',
                    style: h3,
                  ),
                  const Expanded(
                    child: SizedBox(
                      height: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // AndroidIcon(
                            //   image: 'assets/icons/android/phone.svg',
                            //   svg: true,
                            //   onTap: () {
                            //     Launcher().launchUrl(
                            //       context: context,
                            //       url: 'https://google.com',
                            //     );
                            //   },
                            // ),
                            InkWell(
                              onTap: () {
                                Launcher().launchUrl(
                                  context: context,
                                  url: 'https://miltotech.com/abdi',
                                );
                              },
                              child: const FlutterLogo(
                                size: 50,
                                style: FlutterLogoStyle.markOnly,
                              ),
                            ),
                            Text(
                              'Projects',
                              style: textMedium,
                            ),
                          ],
                        ),
                        AndroidIconButton(
                          image: 'assets/icons/chrome.svg',
                          svg: true,
                          text: 'Website',
                          onTap: () {
                            Launcher().launchUrl(
                              context: context,
                              url: 'https://miltotech.com',
                            );
                          },
                        ),
                        AndroidIconButton(
                          image: 'assets/icons/pdf.svg',
                          svg: true,
                          text: 'CV',
                          onTap: () {
                            Launcher().launchUrl(
                              context: context,
                              url: 'https://github.com/abdisaongithub',
                            );
                          },
                        ),
                        AndroidIconButton(
                          image: 'assets/icons/upwork.png',
                          svg: false,
                          text: 'UpWork',
                          onTap: () {
                            Launcher().launchUrl(
                              context: context,
                              url:
                                  'https://www.upwork.com/freelancers/~01d8a688898b3f8808',
                            );
                          },
                        ),
                        AndroidIconButton(
                          image: 'assets/icons/github.svg',
                          svg: true,
                          text: 'GitHub',
                          onTap: () {
                            Launcher().launchUrl(
                              context: context,
                              url: 'https://github.com/abdisaongithub',
                            );
                          },
                          bgColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            color: Colors.white,
                            height: 2,
                            width: 8,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            color: Colors.white,
                            height: 2,
                            width: 8,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      AndroidIcon(
                        image: 'assets/icons/android/calendar.svg',
                      ),
                      AndroidIcon(
                        image: 'assets/icons/android/internet.svg',
                      ),
                      AndroidIcon(
                        image: 'assets/icons/android/my-files.svg',
                      ),
                      AndroidIcon(
                        image: 'assets/icons/android/phone.svg',
                      ),
                      AndroidIcon(
                        image: 'assets/icons/android/planner.svg',
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Expanded(child: const SizedBox(height: 10,),),
                  Center(
                    child: Container(
                      height: 5,
                      width:
                          MediaQuery.of(context).orientation == Orientation.portrait
                              ? MediaQuery.sizeOf(context).width * 0.4
                              : 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AndroidIconButton extends StatelessWidget {
  const AndroidIconButton({
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
        AndroidIcon(
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

class AndroidIcon extends StatelessWidget {
  const AndroidIcon({
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
