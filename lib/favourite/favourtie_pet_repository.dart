import 'dart:convert';
import 'package:Petinder/models/pet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class FavouritePetRepository {
  Future<List<dynamic>> getPetsByType(String type) async {
    var id = Hive.box("IsLogin").get("id");

    var myLocationBox = Hive.box("Location");
    dynamic myLocation = myLocationBox.get("positionMap");
    var myLat = myLocation["lat"];
    var myLong = myLocation["long"];

    var response = await http.get(
        "https://petsyy.herokuapp.com/myPetsType?id=$id&typePet=$type",
        headers: {"Content-Type": "application/json"});

    var petsInitial = json.decode(response.body)["pets"];
    List<dynamic> pets = [];
    if (petsInitial != null) {
      pets = petsInitial["petOut"].map((val) {
        if (val.isNotEmpty) {
          var petOutput = Pet.fromJson(val[0]);
          var lat = petOutput.location.coordinates[1];
          var long = petOutput.location.coordinates[0];
          petOutput.locationString = distanceBetween(lat, long, myLat, myLong);
          return petOutput;
        }
      }).toList();
    } else {
      pets = [];
    }

    return pets;
  }

  String distanceBetween(lat, long, myLat, myLong) {
    double distance = Geolocator.distanceBetween(myLat, myLong, lat, long);
    String distanceKm = (distance / 1000).toStringAsFixed(1);
    return "$distanceKm km";
  }
}
