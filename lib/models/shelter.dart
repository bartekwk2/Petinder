import 'package:Petinder/models/location.dart';

class Shelter {
  MyLocation location;
  List<String> pets;
  List<String> photosRef;
  String sId;
  String name;
  String address;
  int iV;
  String desc;

  Shelter(
      {this.location,
      this.pets,
      this.photosRef,
      this.sId,
      this.name,
      this.address,
      this.iV,
      this.desc});

  Shelter.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new MyLocation.fromJson(json['location'])
        : null;
    pets = json['pets'].cast<String>();
    photosRef = json['photosRef'].cast<String>();
    sId = json['_id'];
    name = json['name'];
    address = json['address'];
    iV = json['__v'];
    desc = json['desc'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['pets'] = this.pets;
    data['photosRef'] = this.photosRef;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['__v'] = this.iV;
    data['desc'] = this.desc;
    return data;
  }

  @override
  String toString() {
    return 'Shelter(location: $location, pets: $pets, photosRef: $photosRef, sId: $sId, name: $name, address: $address, iV: $iV, desc: $desc)';
  }
}
