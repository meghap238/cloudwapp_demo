import 'dart:ui';

import 'package:flutter/material.dart';

abstract class CommonWidgets{
  static Text  textWidget({required String data,double? fontSize,FontWeight? fontWeight }) {
    return Text(data,style: TextStyle(color: Colors.white,fontFamily: 'poppins',fontSize: fontSize ?? 16,fontWeight: fontWeight ?? FontWeight.w500),);

  }
}