class Product {
  String? artNo;
  String? artNom;
  String? artFam;
  String? artSFam;
  String? artColisage;
  String? artColisageNom;
  String? artUni;
  double? artUntCol;
  double? artPrix;
  double? artQte;
  List<ArtImages>? artImages;

  Product({
    this.artNo,
    this.artNom,
    this.artFam,
    this.artSFam,
    this.artColisage,
    this.artColisageNom,
    this.artUni,
    this.artUntCol,
    this.artPrix,
    this.artQte,
    this.artImages,
  });

  Product.fromJson(Map<String, dynamic> json) {
    artNo = json['ArtNo'];
    artNom = (json['ArtNom'] as String?)?.trim() ?? '';
    artFam = (json['ArtFam'] as String?)?.trim() ?? '';
    artSFam = (json['ArtSFam'] as String?)?.trim() ?? '';
    artColisage = json['ArtColisage'] ?? '';
    artColisageNom = (json['ArtColisageNom'] != null) ? (json['ArtColisageNom'] as String) : '';
    artUni = json['ArtUni'] ?? '';
    artUntCol = (json['ArtUntCol'] != null) ? (json['ArtUntCol'] as num).toDouble() : 0.0;
    artPrix = (json['ArtPrix'] != null) ? (json['ArtPrix'] as num).toDouble() : 0.0;
    artQte = (json['ArtQte'] != null) ? (json['ArtQte'] as num).toDouble() : 0.0;
    if (json['ArtImages'] != null) {
      artImages = <ArtImages>[];
      json['ArtImages'].forEach((v) {
        artImages!.add(ArtImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ArtNo'] = artNo;
    data['ArtNom'] = artNom;
    data['ArtFam'] = artFam;
    data['ArtSFam'] = artSFam;
    data['ArtColisage'] = artColisage;
    data['ArtColisageNom'] = artColisageNom;
    data['ArtUni'] = artUni;
    data['ArtUntCol'] = artUntCol;
    data['ArtPrix'] = artPrix;
    data['ArtQte'] = artQte;
    if (artImages != null) {
      data['ArtImages'] = artImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ArtImages {
  String? imgCls;
  String? imgArt;
  String? imgNom;

  ArtImages({this.imgCls, this.imgArt, this.imgNom});

  ArtImages.fromJson(Map<String, dynamic> json) {
    imgCls = json['ImgCls'];
    imgArt = json['ImgArt'];
    imgNom = json['ImgNom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ImgCls'] = imgCls;
    data['ImgArt'] = imgArt;
    data['ImgNom'] = imgNom;
    return data;
  }
}
