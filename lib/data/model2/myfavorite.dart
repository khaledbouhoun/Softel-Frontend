class MyFavoriteModel {
  String? favoriteId;
  String? favoriteUsersid;
  String? favoriteproductsid;
  String? productsId;
  String? productsName;
  String? productsNameAr;
  String? productsDesc;
  String? productsDescAr;
  String? productsImage;
  String? productsCount;
  String? productsActive;
  String? productsPrice;
  String? productsDiscount;
  String? productsDate;
  String? productsCat;
  String? usersId;

  MyFavoriteModel({
    this.favoriteId,
    this.favoriteUsersid,
    this.favoriteproductsid,
    this.productsId,
    this.productsName,
    this.productsNameAr,
    this.productsDesc,
    this.productsDescAr,
    this.productsImage,
    this.productsCount,
    this.productsActive,
    this.productsPrice,
    this.productsDiscount,
    this.productsDate,
    this.productsCat,
    this.usersId,
  });

  MyFavoriteModel.fromJson(Map<String, dynamic> json) {
    favoriteId = json['favorite_id'];
    favoriteUsersid = json['favorite_usersid'];
    favoriteproductsid = json['favorite_productsid'];
    productsId = json['products_id'];
    productsName = json['products_name'];
    productsNameAr = json['products_name_ar'];
    productsDesc = json['products_desc'];
    productsDescAr = json['products_desc_ar'];
    productsImage = json['products_image'];
    productsCount = json['products_count'];
    productsActive = json['products_active'];
    productsPrice = json['products_price'];
    productsDiscount = json['products_discount'];
    productsDate = json['products_date'];
    productsCat = json['products_cat'];
    usersId = json['users_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['favorite_id'] = favoriteId;
    data['favorite_usersid'] = favoriteUsersid;
    data['favorite_productsid'] = favoriteproductsid;
    data['products_id'] = productsId;
    data['products_name'] = productsName;
    data['products_name_ar'] = productsNameAr;
    data['products_desc'] = productsDesc;
    data['products_desc_ar'] = productsDescAr;
    data['products_image'] = productsImage;
    data['products_count'] = productsCount;
    data['products_active'] = productsActive;
    data['products_price'] = productsPrice;
    data['products_discount'] = productsDiscount;
    data['products_date'] = productsDate;
    data['products_cat'] = productsCat;
    data['users_id'] = usersId;
    return data;
  }
}
