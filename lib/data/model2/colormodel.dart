import 'package:flutter/material.dart';

class ColorModel {
  Color? colorCode;

  ColorModel({this.colorCode});

  ColorModel.fromJson(Map<String, dynamic> json) {
    colorCode = Color(
      int.parse(json['color_code'], radix: 16),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color_code'] = colorCode;
    return data;
  }
}
