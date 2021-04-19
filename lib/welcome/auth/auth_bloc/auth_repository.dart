import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  Future<dynamic> loginUser(mail, password) async {
    Map body = {
      'name': mail,
      'password': password,
    };

    var response = await http.post("https://petsyy.herokuapp.com/authenticate",
        headers: {"Content-Type": "application/json"}, body: jsonEncode(body));

    dynamic id = json.decode(response.body)["id"];
    await Hive.box("IsLogin").put("id", id);
    return id;
  }

  Future<dynamic> registerUser(mail, password) async {
    Map body = {
      'name': mail,
      'password': password,
    };

    var response = await http.post("https://petsyy.herokuapp.com/adduser",
        headers: {"Content-Type": "application/json"}, body: jsonEncode(body));

    dynamic id = json.decode(response.body)["id"];
    await Hive.box("IsLogin").put("id", id);
    return id;
  }
}
