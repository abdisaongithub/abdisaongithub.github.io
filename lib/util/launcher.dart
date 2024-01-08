import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:url_launcher/url_launcher_string.dart';

import 'snackbars.dart';


class Launcher {
  Future<void> launchUrl({
    required BuildContext context,
    required String url,
  }) async {
    final url0 = Uri.parse(url);
    if (await launcher.canLaunchUrl(url0)) {
      !await launcher.launchUrl(url0, );
    } else {

      SnackBars.showSnackBar(
        context: context,
        message: 'Can\'t launch url',
        state: SnackBarState.danger,
      );
    }
  }

  Future<void> launchUrlExternalApplication({
    required BuildContext context,
    required String url,
  }) async {
    final url0 = Uri.parse(url);
    if (await launcher.canLaunchUrl(url0)) {
      !await launcher.launchUrl(url0, mode: LaunchMode.externalApplication);
    } else {

      SnackBars.showSnackBar(
        context: context,
        message: 'Can\'t launch app',
        state: SnackBarState.danger,
      );
    }
  }

  Future<void> launchEmail({
    required BuildContext context,
    required String url,
  }) async {
    final url0 = Uri.parse('mailto:$url');
    if (await launcher.canLaunchUrl(url0)) {
      !await launcher.launchUrl(url0);
    } else {

      SnackBars.showSnackBar(
        context: context,
        message: 'Can\'t open email app',
        state: SnackBarState.danger,
      );
    }
  }

  Future<void> launchTel({
    required BuildContext context,
    required String url,
  }) async {
    final url0 = Uri.parse('tel:$url');
    if (await launcher.canLaunchUrl(url0)) {
      !await launcher.launchUrl(url0);
    } else {

      SnackBars.showSnackBar(
        context: context,
        message: 'Can\'t open phone app',
        state: SnackBarState.danger,
      );
    }
  }

  // Future<void> launchCalendar({
  //   required BuildContext context,
  //   required String title,
  //   required String description,
  //   required DateTime startDate,
  //   required DateTime endDate,
  // }) async {
  //   try {
  //     final Event event = Event(
  //       title: title,
  //       description: description,
  //       allDay: true,
  //       startDate: startDate,
  //       endDate: endDate,
  //       iosParams: const IOSParams(
  //         reminder: Duration(
  //           hours: 1,
  //         ), // on iOS, you can set alarm notification after your event.
  //         url:
  //             'https://coffee.miltotech.com', // on iOS, you can set url to your event.
  //       ),
  //       // androidParams: const AndroidParams(
  //       //   emailInvites: [], // on Android, you can add invite emails to your event.
  //       // ),
  //     );
  //     Add2Calendar.addEvent2Cal(event);
  //   } catch (e) {
  //     Util.showErrorSnackBar(context, 'Can\'t open calendar app');
  //   }
  // }
}
