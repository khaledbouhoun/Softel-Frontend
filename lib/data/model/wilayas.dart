class Wilayas {
  String? terPays;
  String? terNo;
  String? terNom;

  Wilayas({this.terPays, this.terNo, this.terNom});

  Wilayas.fromJson(Map<String, dynamic> json) {
    terPays = json['TerPays'];
    terNo = json['TerNo'];
    terNom = json['TerNom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TerPays'] = terPays;
    data['TerNo'] = terNo;
    data['TerNom'] = terNom;
    return data;
  }
}
