class DriverQuotaModel {
  String? empCode;
  String? empFullname;

  DriverQuotaModel({this.empCode, this.empFullname});

  DriverQuotaModel.fromJson(Map<String, dynamic> json) {
    empCode = json['emp_code'];
    empFullname = json['emp_fullname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emp_code'] = empCode;
    data['emp_fullname'] = empFullname;
    return data;
  }
}