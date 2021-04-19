import 'package:http/http.dart' as http;
import 'dart:convert';

class PetProfileRepository {
  Future<dynamic> getUserData(String id) async {
    var response = await http.get(
      "https://petsyy.herokuapp.com/getUserShortData?id=$id",
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      dynamic user = json.decode(response.body)["user"]["name"];
      print("USER $user");
      return user;
    } else {
      return "";
    }
  }

  Future<List<bool>> checkIfLiked(String myID, String petID) async {
    var response = await http.get(
      "https://petsyy.herokuapp.com/checkIfLiked?myID=$myID&petID=$petID",
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      var petInput = json.decode(response.body)["user"]["pets"];
      var petType;
      if (petInput.isNotEmpty) {
        petType = petInput[0]["petType"];
      } else {
        return [false, false];
      }
      if (petType == "Liked") {
        return [true, false];
      } else {
        return [false, true];
      }
    } else {
      return [false, false];
    }
  }

  Future<bool> addPet(String id, String petRef) async {
    Map pet = {'petType': "Liked", 'petRef': petRef};
    Map data = {'id': id, 'pet': pet};

    String body = json.encode(data);

    var response = await http.post(
      'https://petsyy.herokuapp.com/addPetToUser',
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removePet(String id, String petRef) async {
    Map data = {'id': id, 'petID': petRef};

    String body = json.encode(data);

    var response = await http.post(
      'https://petsyy.herokuapp.com/removePetFromUser',
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changePetToLiked(String id, String petRef) async {
    Map data = {'id': id, 'petType': "Liked", 'petID': petRef};

    String body = json.encode(data);

    var response = await http.post(
      'https://petsyy.herokuapp.com/updatePetType',
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addNewUserIfNeeded(String myID, String friendID) async {
    var response = await http.get(
      'https://petsyy.herokuapp.com/checkIfFriends?myID=$myID&friendID=$friendID',
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletePet(String petID) async {
    var response = await http.get(
      "https://petsyy.herokuapp.com/petDelete?id=$petID",
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
