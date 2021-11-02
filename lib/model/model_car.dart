class CarDetailModel {
  int? carId;
  String? carRegistration;
  String? productId;
  String? productName;
  String? productDetail;
  int? lastMileage;
  int? comId;
  String? comName;
  String? comReference;

  CarDetailModel(
      {this.carId,
      this.carRegistration,
      this.productId,
      this.productName,
      this.productDetail,
      this.lastMileage,
      this.comId,
      this.comName,
      this.comReference});

  CarDetailModel.fromJson(Map<String, dynamic> json) {
    carId = json['car_id'];
    carRegistration = json['car_registration'];
    productId = json['product_id'];
    productName = json['product_name'];
    productDetail = json['product_detail'];
    lastMileage = json['last_mileage'];
    comId = json['com_id'];
    comName = json['com_name'];
    comReference = json['com_reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['car_id'] = carId;
    data['car_registration'] = carRegistration;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_detail'] = productDetail;
    data['last_mileage'] = lastMileage;
    data['com_id'] = comId;
    data['com_name'] = comName;
    data['com_reference'] = comReference;
    return data;
  }
}
