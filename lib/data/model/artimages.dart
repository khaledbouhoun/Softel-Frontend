class Artimages {
  String? imgCls;
  String? imgArt;
  String? imgNom;

  Artimages({this.imgCls, this.imgArt, this.imgNom});

  Artimages.fromJson(Map<String, dynamic> json) {
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
