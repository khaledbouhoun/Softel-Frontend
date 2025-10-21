class ImagesBanner {
  String? imgCls;
  String? imgFam;
  String? imgSFam;
  String? imgSFamNom;
  String? imgNom;

  ImagesBanner({this.imgCls, this.imgFam, this.imgSFam, this.imgSFamNom, this.imgNom});

  ImagesBanner.fromJson(Map<String, dynamic> json) {
    imgCls = json['ImgCls'];
    imgFam = json['ImgFam'];
    imgSFam = json['ImgSFam'];
    imgSFamNom = json['ImgSFamNom'];
    imgNom = json['ImgNom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ImgCls'] = imgCls;
    data['ImgFam'] = imgFam;
    data['ImgSFam'] = imgSFam;
    data['ImgSFamNom'] = imgSFamNom;
    data['ImgNom'] = imgNom;
    return data;
  }
}
