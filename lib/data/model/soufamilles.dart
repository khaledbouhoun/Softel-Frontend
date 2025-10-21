class SouFamilles {
  String? souFam;
  String? souNo;
  String? souNom;
  String? souImg;

  SouFamilles({this.souFam, this.souNo, this.souNom, this.souImg});

  SouFamilles.fromJson(Map<String, dynamic> json) {
    souFam = json['SouFam'];
    souNo = json['SouNo'];
    souNom = (json['SouNom'] as String?)?.trim();
    souImg = json['SouImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SouFam'] = souFam;
    data['SouNo'] = souNo;
    data['SouNom'] = souNom;
    data['SouImg'] = souImg;
    return data;
  }
}
