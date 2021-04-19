import 'dart:convert';
import 'package:Petinder/common/common.dart';
import 'package:Petinder/models/character.dart';
import 'package:Petinder/models/location.dart';
import 'package:Petinder/models/pet.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_state.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class RegistrationPetRepository {
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

    return {"lat": position.latitude, "long": position.longitude};
  }

  Future<String> getAddressFromCoordinates(Coordinates coordinates) async {
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first.addressLine;
  }

  Future<String> submitPetAdding(RegistrationPetState petState) async {
    var myLocationBox = Hive.box("Location");
    dynamic city = myLocationBox.get("city");

    Character character = Character(
      health: Feature(numberDecimal: petState.health),
      active: Feature(numberDecimal: petState.active),
      loud: Feature(numberDecimal: petState.loud),
      likesEating: Feature(numberDecimal: petState.likesEating),
      familyFriendly: Feature(numberDecimal: petState.familyFriendly),
      smart: Feature(numberDecimal: petState.smart),
      wellBehaved: Feature(numberDecimal: petState.wellBehaved),
      fearfull: Feature(numberDecimal: petState.fearfull),
      peaceful: Feature(numberDecimal: petState.peaceful),
      indipendent: Feature(numberDecimal: petState.indipendent),
    );

    MyLocation myLocation = MyLocation(type: "Point", coordinates: [
      petState.coordinates["long"],
      petState.coordinates["lat"]
    ]);

    Pet pet = Pet(
        petBreed: petState.breedChosen,
        gender: petState.genderChosen,
        character: character,
        location: myLocation,
        name: petState.petName,
        typeOfPet: petState.specieChosen,
        typeOfPetOwner: petState.originChosen,
        desc: petState.petDesc,
        vaccinates: petState.vaccinationDesc,
        vaccinateFirstCheck: petState.vaccinationFirst,
        vaccinateSecondCheck: petState.vaccinationSecond,
        vaccinateThirdCheck: petState.vaccinationThird,
        dateOfAdd: Common.getCurrentDate(),
        age: petState.ageChosen.round());

    var bodyPet = pet.toJson();
    bodyPet["imageRefs"] = [];
    bodyPet["id"] = Hive.box("IsLogin").get("id");
    bodyPet["city"] = city;

    var response = await http.post("https://petsyy.herokuapp.com/registerPet",
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyPet));

    var id = json.decode(response.body)["pet"];

    print(response.statusCode);

    return id;
  }

  Future<String> uploadImage(filepath, url, userId) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', filepath,
        contentType: MediaType('image', 'jpeg'), filename: 'pet.jpg'));
    request.fields.addAll({
      "userID": userId,
    });
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<bool> uploadImages(List<String> imagesPath, String userId) async {
    for (int i = 0; i < imagesPath.length; i++) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://petsyy.herokuapp.com/upload3'));
      request.files.add(await http.MultipartFile.fromPath(
          'image', imagesPath[i],
          contentType: MediaType('image', 'jpeg'), filename: 'pet.jpg'));
      request.fields.addAll({
        "userID": userId,
      });
      var res = await request.send();
      print("FROM IMAGE ${res.statusCode}");
    }
    return true;
  }
}
