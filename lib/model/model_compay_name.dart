class CompanyNameModel {
  String? comName;

  CompanyNameModel({this.comName});

  CompanyNameModel.fromJson(Map<String, dynamic> json) {
    comName = json['com_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['com_name'] = comName;
    return data;
  }
}
