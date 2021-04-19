import 'dart:convert';
import 'package:Petinder/models/petNames.dart';
import 'package:http/http.dart' as http;

class PetNames {
  Future<List<dynamic>> getPetNames(String animalType) async {
    var response = await http.get(
      "https://petsyy.herokuapp.com/${animalType}Names",
      headers: {"Content-Type": "application/json"},
    );

    List<dynamic> petNames = json.decode(response.body)["pet"].map((val) {
      return PetName.fromJson(val);
    }).toList();

    return petNames;
  }
}
