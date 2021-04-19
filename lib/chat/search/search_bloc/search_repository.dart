import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class SearchRepository {
  static final SearchRepository _searchRepository = SearchRepository._();

  SearchRepository._();

  factory SearchRepository() {
    return _searchRepository;
  }

  Future<dynamic> getResults({
    @required String query,
  }) async {
    try {
      var myId =Hive.box("IsLogin").get("id");
      var response = await http.get(
        "https://petsyy.herokuapp.com/friendsQuery/?myId=$myId&searchString=$query",
        headers: {"Content-Type": "application/json"},
      );
      return response;
    } catch (e) {
      return e.toString();
    }
  }

  Future<int> addFriend(String friendID) async {
    var body = {
      "myId": Hive.box("IsLogin").get("id"),
      "friendID": friendID,
    };
    var response = await http.put("https://petsyy.herokuapp.com/addFriend",
        headers: {"Content-Type": "application/json"}, body: jsonEncode(body));
    return response.statusCode;
  }
}
