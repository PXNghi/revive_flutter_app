import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';

// colors
const primaryColor = Color(0xff64B541);
const alertColor = Color(0xffE92929);
const redColor = Color(0xffFD1111);
const grayColor = Color(0xffF9FAFB);
const grayBorderColor = Color(0xffC0C8BD);
const grayContentColor = Color(0xff918C8C);
const dartGrayColor = Color(0xff9C9CA0);

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
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontFamily: montFont,
);

const contentStyle = TextStyle(
  fontSize: defaultFontSize,
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontFamily: montFont,
);

// padding
const pageHorizontalPadding = EdgeInsets.symmetric(horizontal: 16.0);

// border radius
const defaultBorderRadius = 10.0;
const cardBorderRadius = BorderRadius.all(Radius.circular(defaultBorderRadius));
const imageBorderRadius = BorderRadius.all(Radius.circular(5.0));

// mock data
const bannerImageList = [
  bannerImage,
  bannerImage,
  bannerImage,
  bannerImage,
  bannerImage,
];
