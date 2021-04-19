import 'dart:convert';
import 'package:Petinder/models/pet.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapsRepository {
  BitmapDescriptor pinLocationIconShelter;
  BitmapDescriptor pinLocationIconIndividual;
  BitmapDescriptor pinLocationIconBreeding;

  String distanceBetween(lat, long, myLat, myLong) {
    double distance = Geolocator.distanceBetween(myLat, myLong, lat, long);
    String distanceKm = (distance / 1000).toStringAsFixed(1);
    return "$distanceKm km";
  }

  Future<void> setCustomMapPin() async {
    pinLocationIconShelter = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/pino.png');

    pinLocationIconIndividual = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/pine.png');

    pinLocationIconBreeding = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/pinu.png');
  }

  Future<List<dynamic>> getPetsNearBy(
      double long, double lat, double dist, List<int> clickedCategories) async {
    Map body = {
      'longitude': long,
      'latitude': lat,
      'distance': dist * 1000,
      'typeOfPetOwner': clickedCategories
    };

    var response = await http.post("https://petsyy.herokuapp.com/petsNearby",
        headers: {"Content-Type": "application/json"}, body: jsonEncode(body));

    List<dynamic> pets = json.decode(response.body)["pet"].map((pet) {
      var petOutput = Pet.fromJson(pet);
      var notMyLat = petOutput.location.coordinates[1];
      var notMyLong = petOutput.location.coordinates[0];
      petOutput.locationString =
          distanceBetween(lat, long, notMyLat, notMyLong);
      return petOutput;
    }).toList();

    print("Shelters function : ${pets.length}");

    return pets;
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // getAddressFromCoordinates(
    //    Coordinates(position.latitude, position.longitude));

    return position.toJson();
  }

  Future<List<Marker>> addMarkers(
      List<dynamic> pets, PageController pageController) async {
    int counter = 0;
    List<Marker> allMarkers = [];

    pets.forEach((element) {
      var lat = element.location.coordinates[1];
      var long = element.location.coordinates[0];

      int insider = counter;
      BitmapDescriptor pinLocationIcon;

      switch (element.typeOfPetOwner) {
        case 0:
          pinLocationIcon = pinLocationIconBreeding;
          break;
        case 1:
          pinLocationIcon = pinLocationIconIndividual;
          break;
        case 2:
          pinLocationIcon = pinLocationIconShelter;
          break;
      }

      allMarkers.add(Marker(
          markerId: MarkerId(element.name),
          draggable: false,
          onTap: () {
            print(pageController);
            pageController.animateToPage(insider,
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 300));
          },
          icon: pinLocationIcon,
          position: LatLng(lat, long)));
      counter++;
    });
    return allMarkers;
  }

  getAddressFromCoordinates(Coordinates coordinates) async {
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print(addresses.first.addressLine);
  }
}

String assetOriginChosen(int index) {
  String word = "";
  switch (index) {
    case -1:
      break;
    case 0:
      word = "images/uno.svg";
      break;
    case 1:
      word = "images/dos.svg";
      break;
    case 2:
      word = "images/tres.svg";
      break;
  }
  return word;
}

Color decideColor(int index) {
  switch (index) {
    case 0:
      return Color(0x230c7401);
      break;
    case 1:
      return Color(0x23004569);
      break;
    case 2:
      return Color(0x23cb4d3a);
      break;
    default:
      return Colors.white;
  }
}

BorderRadius decideBorderRadius(int index) {
  switch (index) {
    case 0:
      return BorderRadius.only(
        topLeft: Radius.circular(15),
      );
      break;
    case 2:
      return BorderRadius.only(
        bottomLeft: Radius.circular(15),
      );
      break;
    default:
      return BorderRadius.circular(1);
  }
}
