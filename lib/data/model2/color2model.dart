import 'package:flutter/material.dart';

class ColorModel2 {
  int? idprd;
  Color? colorCode;
  int? qty;

  ColorModel2({this.idprd, this.colorCode, this.qty});

  ColorModel2.fromJson(Map<String, dynamic> json) {
    idprd = json['id_prd'];
    colorCode = Color(
      int.parse(json['color_code2'], radix: 16),
    );
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = <String, String>{};
    data['id_prd'] = idprd.toString();
    data['color_code2'] = colorCode.toString();
    data['qty'] = qty.toString();
    return data;
  }
}
