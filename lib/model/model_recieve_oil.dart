class RecieveOilModel {
  String? recieveId;
  String? recieveCreateDate;
  String? recieveDateRecieve;
  String? recieveRef;
  String? tankId;
  String? productName;
  String? recieveVolumn;
  String? recievePrice;

  RecieveOilModel(
      {this.recieveId,
      this.recieveCreateDate,
      this.recieveDateRecieve,
      this.recieveRef,
      this.tankId,
      this.productName,
      this.recieveVolumn,
      this.recievePrice});

  RecieveOilModel.fromJson(Map<String, dynamic> json) {
    recieveId = json['recieve_id'];
    recieveCreateDate = json['recieve_CreateDate'];
    recieveDateRecieve = json['recieve_DateRecieve'];
    recieveRef = json['recieve_Ref'];
    tankId = json['tank_id'];
    productName = json['product_name'];
    recieveVolumn = json['recieve_volumn'];
    recievePrice = json['recieve_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recieve_id'] = recieveId;
    data['recieve_CreateDate'] = recieveCreateDate;
    data['recieve_DateRecieve'] = recieveDateRecieve;
    data['recieve_Ref'] = recieveRef;
    data['tank_id'] = tankId;
    data['product_name'] = productName;
    data['recieve_volumn'] = recieveVolumn;
    data['recieve_price'] = recievePrice;
    return data;
  }
}
