class QuotaModel {
  int? id;
  String? recRef;
  String? recCreate;
  String? empCode;
  String? empFullname;
  double? limitLite;
  double? limitBath;
  String? productId;
  String? productName;
  String? carRegistration;

  QuotaModel(
      {this.id,
      this.recRef,
      this.recCreate,
      this.empCode,
      this.empFullname,
      this.limitLite,
      this.limitBath,
      this.productId,
      this.productName,
      this.carRegistration});

  QuotaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recRef = json['rec_ref'];
    recCreate = json['rec_create'];
    empCode = json['emp_code'];
    empFullname = json['emp_fullname'];
    limitLite = json['limit_lite'];
    limitBath = json['limit_bath'];
    productId = json['product_id'];
    productName = json['product_name'];
    carRegistration = json['car_registration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rec_ref'] = recRef;
    data['rec_create'] = recCreate;
    data['emp_code'] = empCode;
    data['emp_fullname'] = empFullname;
    data['limit_lite'] = limitLite;
    data['limit_bath'] = limitBath;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['car_registration'] = carRegistration;
    return data;
  }
}
