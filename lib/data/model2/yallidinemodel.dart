import 'package:animated_custom_dropdown/custom_dropdown.dart';

class WilayasModel with CustomDropdownListFilter {
  int? id;
  String? name;
  int? isDeliverable;

  WilayasModel({this.id, this.name, this.isDeliverable});

  WilayasModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isDeliverable = json['is_deliverable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_deliverable'] = isDeliverable;
    return data;
  }

  @override
  bool filter(String query) {
    return name!.toLowerCase().contains(query.toLowerCase());
  }
}

class CommunesModel with CustomDropdownListFilter {
  int? id;
  String? name;
  int? wilayaId;
  int? hasStopDesk;
  int? isDeliverable;

  CommunesModel({this.id, this.name, this.wilayaId, this.hasStopDesk, this.isDeliverable});

  CommunesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    wilayaId = json['wilaya_id'];
    hasStopDesk = json['has_stop_desk'];
    isDeliverable = json['is_deliverable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['wilaya_id'] = wilayaId;
    data['has_stop_desk'] = hasStopDesk;
    data['is_deliverable'] = isDeliverable;
    return data;
  }

  @override
  bool filter(String query) {
    return name!.toLowerCase().contains(query.toLowerCase());
  }
}

class CenterModel with CustomDropdownListFilter {
  int? centerId;
  String? name;
  String? address;
  String? lat;
  String? lng;
  String? gps;
  int? communeId;
  int? wilayaId;

  CenterModel({this.centerId, this.name, this.address, this.gps, this.communeId, this.wilayaId});

  CenterModel.fromJson(Map<String, dynamic> json) {
    centerId = json['center_id'];
    name = json['name'];
    address = json['address'];
    lng = json['lng'];
    gps = json['gps'];
    communeId = json['commune_id'];
    wilayaId = json['wilaya_id'];
    lat = gps.toString().split(',')[0];
    lng = gps.toString().split(',')[1];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['center_id'] = centerId;
    data['name'] = name;
    data['address'] = address;
    data['gps'] = gps;
    data['commune_id'] = communeId;
    data['wilaya_id'] = wilayaId;
    return data;
  }

  @override
  bool filter(String query) {
    return name!.toLowerCase().contains(query.toLowerCase());
  }
}
