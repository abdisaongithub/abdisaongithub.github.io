import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/util/color.dart';
import 'package:flutter_svg/svg.dart';

GlobalKey globalKey = GlobalKey<ScaffoldState>();

enum SnackBarState { success, danger, info }

class SnackBars {
  static void showSnackBar({
    required BuildContext context,
    required String message,
    SnackBarState state = SnackBarState.success,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 1,
        dismissDirection: DismissDirection.horizontal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color(0xfff1f1f1),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
        // width: MediaQuery.of(context).size.width * 0.9,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  state == SnackBarState.success
                      ? 'assets/icons/icon-notification-success.svg'
                      : state == SnackBarState.info
                          ? 'assets/icons/icon-notification-alert.svg'
                          : 'assets/icons/icon-notification-error.svg',
                  height: 20,
                  width: 20,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  message,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    },
                    child: const SizedBox(
                      width: 10,
                      height: 10,
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xfff1f1f1),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        content: Container(
          decoration: const BoxDecoration(),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 14,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 3,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xfff1f1f1),
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 14,
            fontFamily: "Montserrat",
          ),
        ),
      ),
    );
  }

  static void showBigSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 3,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xfff1f1f1),
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Montserrat",
          ),
        ),
      ),
    );
  }

  static void showLoadingSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 3,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xfff1f1f1),
          ),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: "Montserrat",
              ),
            ),
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: CustomColor.redo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
