import 'package:flutter/material.dart';

class Company {
  String? clsNo;
  String? clsNom;
  Color? clsClr1;
  Color? clsClr2;
  String? clsFac;
  String? clsIns;
  String? clsTik;
  String? clsWhts;
  String? clsImg;
  int? clsActif;
  DateTime? clsDateIn;
  DateTime? clsDateOut;

  Company({this.clsNo, this.clsNom, this.clsClr1, this.clsClr2, this.clsImg, this.clsActif, this.clsDateIn, this.clsDateOut});

  Company.fromJson(Map<String, dynamic> json) {
    clsNo = json['ClsNo'];
    clsNom = json['ClsNom'];
    clsClr1 = fromDelphi(json['ClsClr1']);
    clsClr2 = fromDelphi(json['ClsClr2']);
    clsFac = json['ClsFac'];
    clsIns = json['ClsIns'];
    clsTik = json['ClsTik'];
    clsWhts = json['ClsWhts'];
    clsImg = json['ClsImg'];
    clsActif = (json['ClsActif'] is String) ? int.tryParse(json['ClsActif']) : json['ClsActif'];
    clsDateIn = _parseDate(json['ClsDateIn']);
    clsDateOut = _parseDate(json['ClsDateOut']);
  }

  Map<String, dynamic> toJson() {
    return {
      'ClsNo': clsNo,
      'ClsNom': clsNom,
      'ClsClr1': clsClr1?.toARGB32().toRadixString(16),
      'ClsClr2': clsClr2?.toARGB32().toRadixString(16),
      'ClsFac': clsFac,
      'ClsIns': clsIns,
      'ClsTik': clsTik,
      'ClsWhts': clsWhts,
      'ClsImg': clsImg,
      'ClsActif': clsActif,
      'ClsDateIn': clsDateIn?.toIso8601String(),
      'ClsDateOut': clsDateOut?.toIso8601String(),
    };
  }


  DateTime? _parseDate(String? date) {
    if (date == null || date.isEmpty) return null;
    try {
      return DateTime.parse(date);
    } catch (_) {
      return null;
    }
  }

  Color fromDelphi(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return Colors.transparent;

    int delphiColor = int.tryParse(colorStr) ?? 16777215;

    int r = delphiColor & 0xFF;
    int g = (delphiColor >> 8) & 0xFF;
    int b = (delphiColor >> 16) & 0xFF;

    return Color.fromARGB(255, r, g, b);
  }
}
