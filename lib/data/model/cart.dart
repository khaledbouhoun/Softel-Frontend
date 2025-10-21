class CartModel {
  int? cddID;
  String? cls;
  String? cddArtNo;
  String? cddArtNom;
  String? cddArtFam;
  String? cddArtSFam;
  String? cddArtUni;
  String? cddColisage;
  String? cddColisageNom;
  double? cddColis;
  double? cddUntCol;
  double? cddQte;
  double? cddPrix;
  double? cddMontant;

  CartModel({
    this.cddID,
    this.cls,
    this.cddArtNo,
    this.cddArtNom,
    this.cddArtFam,
    this.cddArtSFam,
    this.cddArtUni,
    this.cddColisage,
    this.cddColisageNom,
    this.cddColis,
    this.cddUntCol,
    this.cddQte,
    this.cddPrix,
    this.cddMontant,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    cddID = (json['CddID'] != null) ? (json['CddID'] as num).toInt() : 0;
    cls = json['Cls'];
    cddArtNo = json['CddArtNo'];
    cddArtNom = json['CddArtNom'];
    cddArtFam = json['CddArtFam'];
    cddArtSFam = json['CddArtSFam'];
    cddArtUni = json['CddArtUni'];
    cddColisage = json['CddColisage'];
    cddColisageNom = json['CddColisageNom'];
    cddColis = (json['CddColis'] != null) ? (json['CddColis'] as num).toDouble() : 0.0;
    cddUntCol = (json['CddUntCol'] != null) ? (json['CddUntCol'] as num).toDouble() : 0.0;
    cddQte = (json['CddQte'] != null) ? (json['CddQte'] as num).toDouble() : 0.0;
    cddPrix = (json['CddPrix'] != null) ? (json['CddPrix'] as num).toDouble() : 0.0;
    cddMontant = (json['CddMontant'] != null) ? (json['CddMontant'] as num).toDouble() : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CddID'] = cddID;
    data['Cls'] = cls;
    data['CddArtNo'] = cddArtNo;
    data['CddArtNom'] = cddArtNom;
    data['CddArtFam'] = cddArtFam;
    data['CddArtSFam'] = cddArtSFam;
    data['CddArtUni'] = cddArtUni;
    data['CddColisage'] = cddColisage;
    data['CddColisageNom'] = cddColisageNom;
    data['CddColis'] = cddColis;
    data['CddUntCol'] = cddUntCol;
    data['CddQte'] = cddQte;
    data['CddPrix'] = cddPrix;
    data['CddMontant'] = cddMontant;
    return data;
  }
}
