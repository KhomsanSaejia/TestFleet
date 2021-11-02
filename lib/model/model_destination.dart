class DestinationModel {
  int? id;
  String? routeName;
  String? routeLat;
  String? routeLong;
  String? routeRef;

  DestinationModel(
      {this.id, this.routeName, this.routeLat, this.routeLong, this.routeRef});

  DestinationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    routeName = json['route_name'];
    routeLat = json['route_lat'];
    routeLong = json['route_long'];
    routeRef = json['route_ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['route_name'] = routeName;
    data['route_lat'] = routeLat;
    data['route_long'] = routeLong;
    data['route_ref'] = routeRef;
    return data;
  }
}
