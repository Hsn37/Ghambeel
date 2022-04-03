import 'package:flutter/material.dart';

var darkMode = false;

Color darkPrimary = darkMode ? const Color(0xffb2ebf2):  const Color(0xff0097A7) ;
Color lightPrimary = darkMode ? const Color(0xff0097A7) :const Color(0xffb2ebf2);
const Color primary = Color(0xff00bcd4);
const Color accent = Color(0xffffc107);

Color primaryText = darkMode ? const Color(0xffbdbdbd) : const Color(0xff212121);
Color secondaryText = darkMode ? const Color(0xffbdbdbd) : const Color(0xff212121);

const Color divider = Color(0xffbdbdbd);
const Color icon = Colors.green;
Color bg = darkMode ? const Color(0xff212121) : const Color.fromARGB(255, 255, 255, 255);
const Color plusFloatCol = Color.fromARGB(1, 0, 151, 167);

Color navColor = darkMode? const Color(0xff006a74) : const Color(0xff00bcd4);

const Color toDoIconCols= Color(0xFF00695C);

const Color subText = Color(0x01666666);