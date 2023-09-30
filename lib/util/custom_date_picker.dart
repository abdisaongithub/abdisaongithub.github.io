import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../src/theme/theme.dart';

selectDate(BuildContext context, DateTime? selectedDate,
    TextEditingController textEditingController) async {
  DateTime? newSelectedDate = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).custom.primaryColor,
            onPrimary: Colors.white,
            surface: Colors.blueGrey,
            onSurface: Theme.of(context).custom.grayTextColor,
          ),
        ),
        child: child!,
      );
    },
  );

  if (newSelectedDate != null) {
    selectedDate = newSelectedDate;
    textEditingController
      ..text = DateFormat.yMd().format(selectedDate)
      ..selection = TextSelection.fromPosition(
        TextPosition(
          offset: textEditingController.text.length,
          affinity: TextAffinity.downstream,
        ),
      );
    List<String> date = textEditingController.value.text.contains('/')
        ? textEditingController.value.text.split('/')
        : textEditingController.value.text.split('-');
    String reversedDate =
        '${date[2]}-${date[1].length == 1 ? '0${date[1]}' : date[1]}-${date[0].length == 1 ? '0${date[0]}' : date[0]}';
    textEditingController.text = reversedDate;

    // debugPrint("printed datae${textEditingController.value.text}");
  }
}
