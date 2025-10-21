class Command {
  int? cdeID;
  String? cdeCls;
  String? cdeCli;
  DateTime? cdeDate;
  int? cdeStatus;
  double? cdeMontant;

  Command({this.cdeID, this.cdeCls, this.cdeCli, this.cdeDate, this.cdeStatus, this.cdeMontant});

  Command.fromJson(Map<String, dynamic> json) {
    cdeID = (json['CdeID'] != null) ? (json['CdeID'] as num).toInt() : 0;
    cdeCls = json['CdeCls'];
    cdeCli = json['CdeCli'];
    cdeDate = DateTime.parse(json['CdeDate']);
    cdeStatus = (json['CdeStatus'] != null) ? (json['CdeStatus'] as num).toInt() : 0;
    cdeMontant = (json['CdeMontant'] != null) ? (json['CdeMontant'] as num).toDouble() : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CdeID'] = cdeID;
    data['CdeCls'] = cdeCls;
    data['CdeCli'] = cdeCli;
    data['CdeDate'] = cdeDate;
    data['CdeStatus'] = cdeStatus;
    data['CdeMontant'] = cdeMontant;
    return data;
  }
}
