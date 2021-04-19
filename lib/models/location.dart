class MyLocation {
  String type;
  List<double> coordinates;

  MyLocation({this.type, this.coordinates});

  MyLocation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }

  @override
  String toString() => 'MyLocation(type: $type, coordinates: $coordinates)';
}
