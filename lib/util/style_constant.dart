import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'color.dart';

const appbarStyleText = TextStyle(
  color: CustomColor.bluoDark,
  fontSize: 15,
  fontWeight: FontWeight.w700,
);

var dropDownStyleText = const TextStyle(
  color: CustomColor.greoDark,
  fontSize: kIsWeb ? 12 : 11,
  fontWeight: FontWeight.w500,
);

var boxShadow = const BoxShadow(
  color: CustomColor.greoLighter,
  blurRadius: 0.2,
  offset: Offset(0, 1),
);

var h1 = const TextStyle(
  color: CustomColor.bluoDark,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

var h2 = const TextStyle(
  color: CustomColor.bluoDark,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

var h3 = const TextStyle(
  color: CustomColor.bluoDark,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

var h4 = const TextStyle(
  color: CustomColor.bluoDark,
  fontSize: 12,
  fontWeight: FontWeight.w600,
);

var textMedium = const TextStyle(
  color: CustomColor.greoDark,
  fontSize: 12,
  fontWeight: FontWeight.w500,
);

var textLink = const TextStyle(
  color: CustomColor.redo,
  fontSize: 12,
  fontWeight: FontWeight.w500,
);

var textSmall = const TextStyle(
  color: CustomColor.greoDark,
  fontSize: 10,
  fontWeight: FontWeight.w500,
);

var textMini = const TextStyle(
  color: CustomColor.greoDark,
  fontSize: 8,
  fontWeight: FontWeight.w500,
);

var textMiniMini = const TextStyle(
  color: CustomColor.greoDark,
  fontSize: 6,
  fontWeight: FontWeight.w500,
);

// var textLink = const TextStyle(
//   color: CustomColor.redo,
//   fontSize: kIsWeb ? 12 : 11,
//   fontWeight: FontWeight.w500,
// );
//
// const textMiniMini = TextStyle(
//   color: CustomColor.bluoDark,
//   fontSize: 11,
//   fontWeight: FontWeight.w500,
// );
//
// var textMedium = const TextStyle(
//   color: Color(0xff5b5b5b),
//   fontSize: kIsWeb ? 12 : 11,
//   fontWeight: FontWeight.w200,
// );
//
// var textMini = const TextStyle(
//   color: CustomColor.greoDark,
//   fontSize: kIsWeb ? 10 : 12,
//   fontWeight: FontWeight.w500,
// );
