class ReportModel {
  int? id;
  String? recRef;
  String? recCreate;
  String? recFinish;
  String? empFullname;
  String? carRegistration;
  String? limitLite;
  String? limitBath;
  String? pumpAmount;
  String? pumpLite;
  String? pumpId;
  String? pumpPrice;
  String? newMileage;
  String? recStatus;
  String? desination;

  ReportModel(
      {this.id,
      this.recRef,
      this.recCreate,
      this.recFinish,
      this.empFullname,
      this.carRegistration,
      this.limitLite,
      this.limitBath,
      this.pumpAmount,
      this.pumpLite,
      this.pumpId,
      this.pumpPrice,
      this.newMileage,
      this.recStatus,
      this.desination});

  ReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recRef = json['rec_ref'];
    recCreate = json['rec_create'];
    recFinish = json['rec_finish'];
    empFullname = json['emp_fullname'];
    carRegistration = json['car_registration'];
    limitLite = json['limit_lite'];
    limitBath = json['limit_bath'];
    pumpAmount = json['pump_amount'];
    pumpLite = json['pump_lite'];
    pumpId = json['pump_id'];
    pumpPrice = json['pump_price'];
    newMileage = json['new_mileage'];
    recStatus = json['rec_status'];
    desination = json['desination'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rec_ref'] = recRef;
    data['rec_create'] = recCreate;
    data['rec_finish'] = recFinish;
    data['emp_fullname'] = empFullname;
    data['car_registration'] = carRegistration;
    data['limit_lite'] = limitLite;
    data['limit_bath'] = limitBath;
    data['pump_amount'] = pumpAmount;
    data['pump_lite'] = pumpLite;
    data['pump_id'] = pumpId;
    data['pump_price'] = pumpPrice;
    data['new_mileage'] = newMileage;
    data['rec_status'] = recStatus;
    data['desination'] = desination;
    return data;
  }
}
