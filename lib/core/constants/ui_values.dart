import 'package:flutter/material.dart';

// colors
const primaryColor = Color(0xff64B541);
const alertColor = Color(0xffE92929);
const redColor = Color(0xffFD1111);
const grayColor = Color(0xffD9D9D9);

// font sizes
const headerFontSize = 25.0;
const titleFontSize = 17.0;
const defaultFontSize = 14.0;
const smallFontSize = 12.0;
const smallestFontSize = 10.0;

// font family
const montFont = 'Montserrat';

// styles
const headerStyle = TextStyle(
  fontSize: headerFontSize,
  color: primaryColor,
  fontWeight: FontWeight.bold,
  fontFamily: montFont,
);

const titleStyle = TextStyle(
  fontSize: titleFontSize,
  color: primaryColor,
  fontWeight: FontWeight.w600,
  fontFamily: montFont,
);

const contentStyle = TextStyle(
  fontSize: defaultFontSize,
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontFamily: montFont,
);
