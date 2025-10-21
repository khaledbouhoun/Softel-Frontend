class Communes {
  String? vilPays;
  String? vilTerr;
  String? vilNo;
  String? vilNom;

  Communes({this.vilPays, this.vilTerr, this.vilNo, this.vilNom});

  Communes.fromJson(Map<String, dynamic> json) {
    vilPays = json['VilPays'];
    vilTerr = json['VilTerr'];
    vilNo = json['VilNo'];
    vilNom = json['VilNom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VilPays'] = vilPays;
    data['VilTerr'] = vilTerr;
    data['VilNo'] = vilNo;
    data['VilNom'] = vilNom;
    return data;
  }
}
