class PetName {
  String sId;
  String name;
  String photo;

  PetName({this.sId, this.name, this.photo});

  PetName.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['photo'] = this.photo;
    return data;
  }

  @override
  String toString() => 'PetName(sId: $sId, name: $name, photo: $photo)';
}
