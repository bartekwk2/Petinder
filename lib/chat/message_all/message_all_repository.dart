import 'dart:convert';
import 'package:Petinder/models/latestMessages.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MessageAllRepository {
  Future<List<dynamic>> getFriends() async {
    String id = Hive.box("IsLogin").get("id");
    print(id);
    var response = await http.get(
      "https://petsyy.herokuapp.com/getLatestMessages?myId=$id",
      headers: {"Content-Type": "application/json"},
    );

    List<dynamic> latestMessages =
        json.decode(response.body)["results"]["friends"].map((val) {
      return Friends.fromJson(val);
    }).toList();

    return latestMessages;
  }
}

String decideTime(String time) {
  DateTime dateOfSend = DateFormat("yyyy-MM-dd HH:mm").parse(time);
  DateTime now = DateTime.now();

  Duration duration = now.difference(dateOfSend);
  int days = duration.inDays;
  int hours = duration.inHours;
  int minutes = duration.inMinutes;

  if (minutes < 1) {
    return "teraz";
  } else if (minutes >= 1 && minutes < 60) {
    return "$minutes min";
  } else if (hours >= 1 && hours < 24) {
    return "$hours godz";
  } else if (days >= 1) {
    return "$days dni";
  } else {
    return "";
  }
}
