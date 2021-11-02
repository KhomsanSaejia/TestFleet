class CompanyModel {
  int? comId;
  String? comName;
  String? comAddress;
  String? comLat;
  String? comLong;
  String? comTel;
  String? comReference;

  CompanyModel(
      {this.comId,
      this.comName,
      this.comAddress,
      this.comLat,
      this.comLong,
      this.comTel,
      this.comReference});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    comId = json['com_id'];
    comName = json['com_name'];
    comAddress = json['com_address'];
    comLat = json['com_lat'];
    comLong = json['com_long'];
    comTel = json['com_tel'];
    comReference = json['com_reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =<String, dynamic>{};
    data['com_id'] = comId;
    data['com_name'] = comName;
    data['com_address'] = comAddress;
    data['com_lat'] = comLat;
    data['com_long'] = comLong;
    data['com_tel'] = comTel;
    data['com_reference'] = comReference;
    return data;
  }
}
