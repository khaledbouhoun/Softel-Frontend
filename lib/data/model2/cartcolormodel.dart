class CartColorModel {
  String? cartId;
  List<Clr>? clr;

  CartColorModel({this.cartId, this.clr});

  CartColorModel.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    if (json['clr'] != null) {
      clr = <Clr>[];
      json['clr'].forEach((v) {
        clr!.add(Clr.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    if (clr != null) {
      data['clr'] = clr!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Clr {
  String? colorCode2;
  double? qty;

  Clr({this.colorCode2, this.qty});

  Clr.fromJson(Map<String, dynamic> json) {
    colorCode2 = json['color_code2'];
    qty = json['qty'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color_code2'] = colorCode2;
    data['qty'] = qty;
    return data;
  }
}
