class TankModel {
  int? tankId;
  int? tankCapacity;
  String? productId;

  TankModel({this.tankId, this.tankCapacity, this.productId});

  TankModel.fromJson(Map<String, dynamic> json) {
    tankId = json['tank_id'];
    tankCapacity = json['tank_capacity'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tank_id'] = tankId;
    data['tank_capacity'] = tankCapacity;
    data['product_id'] = productId;
    return data;
  }
}
