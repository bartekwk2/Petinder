import 'dart:convert';
import 'package:Petinder/common/common.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class LoginStatus {
  static Future<int> changeStatus(bool isActive, {String id}) async {
    var body = {
      "id": id ?? Hive.box("IsLogin").get("id"),
      "isActive": isActive,
      "lastActive": Common.getCurrentDate()
    };
    var response = await http.put("https://petsyy.herokuapp.com/changeStatus",
        headers: {"Content-Type": "application/json"}, body: jsonEncode(body));

    print("STATE 2 ${response.statusCode}");
    return response.statusCode;
  }
}

Future<int> updatePetViews(String id) async {
  var response = await http.put(
    "https://petsyy.herokuapp.com/updatePetViews?id=$id",
    headers: {"Content-Type": "application/json"},
  );
  return response.statusCode;
}


