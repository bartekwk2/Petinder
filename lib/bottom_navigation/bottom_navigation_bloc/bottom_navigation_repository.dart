import 'package:Petinder/models/user.dart';
import 'package:Petinder/repository/loginStatus.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BottomNavigationRepository {
  Future<dynamic> getUserInfo() async {
    String id = Hive.box("IsLogin").get("id");
    print("ID $id");
    changeStatus(true, id: id);
    var response = await http.get(
      "https://petsyy.herokuapp.com/getUserShortData?id=$id",
      headers: {"Content-Type": "application/json"},
    );
    dynamic user = UserApp.fromJson(json.decode(response.body)["user"]);
    return user;
  }

  Future<void> changeStatus(bool isActive, {String id}) async {
    if (!isActive) {
      Hive.box("IsLogin").put("id", "");
    }
    await LoginStatus.changeStatus(isActive, id: id ?? null);
  }
}
