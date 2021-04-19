import 'dart:convert';
import 'package:Petinder/models/pet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class SwipeRepository {
  Future<List<dynamic>> getSwipePets(double longitude, double latitude,
      double distance, int limit, int page, String id) async {
    var distanceKm = distance * 1000;
    var response = await http.get(
      "https://petsyy.herokuapp.com/getNearestPetsSwipeScreen?longitude=$longitude&latitude=$latitude&distance=$distanceKm&limit=$limit&page=$page&id=$id",
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      var petFirst = json.decode(response.body)["pet"];
      if (petFirst != null) {
        var pets = petFirst.map((val) {
          var myLocationBox = Hive.box("Location");
          dynamic myLocation = myLocationBox.get("positionMap");
          var myLat = myLocation["lat"];
          var myLong = myLocation["long"];
          var petOutput = Pet.fromJson(val);
          var lat = petOutput.location.coordinates[1];
          var long = petOutput.location.coordinates[0];
          petOutput.locationString = distanceBetween(lat, long, myLat, myLong);
          return petOutput;
        }).toList();
        return pets;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  String distanceBetween(lat, long, myLat, myLong) {
    double distance = Geolocator.distanceBetween(myLat, myLong, lat, long);
    String distanceKm = (distance / 1000).toStringAsFixed(1);
    return "$distanceKm km";
  }

  void addPet(String id, String petType, String petRef) async {
    Map pet = {'petType': petType, 'petRef': petRef};
    Map data = {'id': id, 'pet': pet};

    String body = json.encode(data);

    await http.post(
      'https://petsyy.herokuapp.com/addPetToUser',
      headers: {"Content-Type": "application/json"},
      body: body,
    );
  }
}
