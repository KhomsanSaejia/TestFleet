class PumpDetailModel {
  int? pumpId;
  int? pumpChannal;
  int? pumpNozzle;
  int? tankId;
  String? productName;
  String? productDetail;
  String? productId;
  int? tankCapacity;
  String? keypadId;

  PumpDetailModel(
      {this.pumpId,
      this.pumpChannal,
      this.pumpNozzle,
      this.tankId,
      this.productName,
      this.productDetail,
      this.productId,
      this.tankCapacity,
      this.keypadId});

  PumpDetailModel.fromJson(Map<String, dynamic> json) {
    pumpId = json['pump_id'];
    pumpChannal = json['pump_channal'];
    pumpNozzle = json['pump_nozzle'];
    tankId = json['tank_id'];
    productName = json['product_name'];
    productDetail = json['product_detail'];
    productId = json['product_id'];
    tankCapacity = json['tank_capacity'];
    keypadId = json['keypad_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pump_id'] = pumpId;
    data['pump_channal'] = pumpChannal;
    data['pump_nozzle'] = pumpNozzle;
    data['tank_id'] = tankId;
    data['product_name'] = productName;
    data['product_detail'] = productDetail;
    data['product_id'] = productId;
    data['tank_capacity'] = tankCapacity;
    data['keypad_id'] = keypadId;
    return data;
  }
}
