class Familles {
  String? famNo;
  String? famNom;
  String? famImg;

  Familles({this.famNo, this.famNom, this.famImg});

  Familles.fromJson(Map<String, dynamic> json) {
    famNo = json['FamNo'];
    famNom = (json['FamNom'] as String?)?.trim();
    famImg = json['FamImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FamNo'] = famNo;
    data['FamNom'] = famNom;
    data['FamImg'] = famImg;
    return data;
  }
}
