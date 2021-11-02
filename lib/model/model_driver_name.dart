class DriverNameModel {
  int? id;
  String? empCode;
  String? empFullname;
  String? empTel;
  String? empToken;
  String? comName;

  DriverNameModel(
      {this.id,
      this.empCode,
      this.empFullname,
      this.empTel,
      this.empToken,
      this.comName});

  DriverNameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empCode = json['emp_code'];
    empFullname = json['emp_fullname'];
    empTel = json['emp_tel'];
    empToken = json['emp_token'];
    comName = json['com_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['emp_code'] = empCode;
    data['emp_fullname'] = empFullname;
    data['emp_tel'] = empTel;
    data['emp_token'] = empToken;
    data['com_name'] = comName;
    return data;
  }
}
