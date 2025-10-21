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
    clsClr1 = _parseColor(json['ClsClr1']);
    clsClr2 = _parseColor(json['ClsClr2']);
    clsFac = json['ClsFac'];
    clsIns = json['ClsIns'];
    clsTik = json['ClsTik'];
    clsWhts = json['ClsWhts'];
    clsImg = json['ClsImg'];
    clsActif = json['ClsActif'];
    clsDateIn = _parseDate(json['ClsDateIn']);
    clsDateOut = _parseDate(json['ClsDateOut']);
  }

  Map<String, dynamic> toJson() {
    return {
      'ClsNo': clsNo,
      'ClsNom': clsNom,
      'ClsClr1': clsClr1?.value.toRadixString(16),
      'ClsClr2': clsClr2?.value.toRadixString(16),
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

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.black;
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return Colors.black;
    }
  }

  DateTime? _parseDate(String? date) {
    if (date == null || date.isEmpty) return null;
    try {
      return DateTime.parse(date);
    } catch (_) {
      return null;
    }
  }
}
