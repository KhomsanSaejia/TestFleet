class DropdownCar {
  int? carId;
  String? carRegistration;
  String? carDriverName;

  DropdownCar({this.carId, this.carRegistration, this.carDriverName});

  DropdownCar.fromJson(Map<String, dynamic> json) {
    carId = json['car_id'];
    carRegistration = json['car_registration'];
    carDriverName = json['car_driver_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['car_id'] = carId;
    data['car_registration'] = carRegistration;
    data['car_driver_name'] = carDriverName;
    return data;
  }
}
