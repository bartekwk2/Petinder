class UserApp {
  List<String> photosRef;
  String sId;
  String name;
  String password;
  bool isActive;
  String lastActive;

  UserApp(
      {this.photosRef,
      this.sId,
      this.name,
      this.password,
      this.isActive,
      this.lastActive});

  UserApp.fromJson(Map<String, dynamic> json) {
    photosRef = json['photosRef'].cast<String>();
    sId = json['_id'];
    name = json['name'];
    isActive = json['isActive'];
    password = json['password'];
    lastActive = json['lastActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photosRef'] = this.photosRef;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['password'] = this.password;
    data['lastActive'] = this.lastActive;

    return data;
  }

  @override
  String toString() {
    return 'User(photosRef: $photosRef, sId: $sId, name: $name, password: $password,isActive: $isActive,lastActive: $lastActive)';
  }
}
