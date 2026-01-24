import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/util/launcher.dart';
import 'package:flutter_portfolio_app/util/style_constant.dart';
import 'package:flutter_svg/svg.dart';

class IOSUI extends StatefulWidget {
  static String id = 'IOSUI';

  const IOSUI({Key? key}) : super(key: key);

  @override
  _IOSUIState createState() => _IOSUIState();
}

class _IOSUIState extends State<IOSUI> {
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
                'assets/images/ios_wallpaper.jpg',
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                height: 60,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     const IOSIcon(
              //       image: 'assets/images/cloud.svg',
              //     ),
              //     const SizedBox(
              //       width: 8,
              //     ),
              //     Text(
              //       '33°',
              //       style: jumboText,
              //     ),
              //   ],
              // ),
              // Text(
              //   'Partly Cloudy',
              //   style: h3,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     const Icon(
              //       Icons.location_on,
              //       color: CustomColor.whito,
              //       size: 18,
              //     ),
              //     const SizedBox(
              //       width: 6,
              //     ),
              //     Text(
              //       'Addis Ababa',
              //       style: h3,
              //     ),
              //   ],
              // ),
              // Text(
              //   'UV Index: Perfect',
              //   style: h3,
              // ),
              // const Expanded(
              //   child: SizedBox(
              //     height: 20,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     // AndroidIcon(
                    //     //   image: 'assets/icons/android/phone.svg',
                    //     //   svg: true,
                    //     //   onTap: () {
                    //     //     Launcher().launchUrl(
                    //     //       context: context,
                    //     //       url: 'https://google.com',
                    //     //     );
                    //     //   },
                    //     // ),
                    //     InkWell(
                    //       onTap: () {
                    //         Launcher().launchUrl(
                    //           context: context,
                    //           url: 'https://miltotech.com/abdi',
                    //         );
                    //       },
                    //       child: const FlutterLogo(
                    //         size: 50,
                    //         style: FlutterLogoStyle.markOnly,
                    //       ),
                    //     ),
                    //     Text(
                    //       'Projects',
                    //       style: textMedium,
                    //     ),
                    //   ],
                    // ),
                    IOSIconButton(
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
                    IOSIconButton(
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
                    IOSIconButton(
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
                    IOSIconButton(
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
              const Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var i = 0; i < 3; i++)
                    Container(
                      height: 10,
                      width: 10,
                      margin: const EdgeInsets.only(
                        left: 4,
                        right: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: i == 0
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   width: 20,
                    // ),
                    IOSIcon(
                      image: 'assets/icons/android/calendar.svg',
                    ),
                    IOSIcon(
                      image: 'assets/icons/android/internet.svg',
                    ),
                    IOSIcon(
                      image: 'assets/icons/android/my-files.svg',
                    ),
                    IOSIcon(
                      image: 'assets/icons/android/phone.svg',
                    ),
                    // IOSIcon(
                    //   image: 'assets/icons/android/planner.svg',
                    // ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Expanded(child: const SizedBox(height: 10,),),
              // Center(
              //   child: Container(
              //     height: 5,
              //     width:
              //         MediaQuery.of(context).orientation == Orientation.portrait
              //             ? MediaQuery.sizeOf(context).width * 0.4
              //             : 180,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class IOSIconButton extends StatelessWidget {
  const IOSIconButton({
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
        IOSIcon(
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

class IOSIcon extends StatelessWidget {
  const IOSIcon({
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: image.endsWith('.svg')
                ? SvgPicture.asset(
                    image,
                    width: width ?? 60,
                    height: height ?? 60,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    image,
                    width: width ?? 60,
                    height: height ?? 60,
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
