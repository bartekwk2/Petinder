import 'package:Petinder/models/character.dart';
import 'location.dart';

class Pet {
  Character character;
  MyLocation location;
  List<String> imageRefs;
  String sId;
  String name;
  int typeOfPet;
  int typeOfPetOwner;
  String dateOfAdd;
  String city;
  int age;
  int numberOfViews;
  int iV;
  String desc;
  String vaccinates;
  bool vaccinateFirstCheck;
  bool vaccinateSecondCheck;
  bool vaccinateThirdCheck;
  int gender;
  String petBreed;
  String locationString;
  String userID;

  Pet(
      {this.character,
      this.location,
      this.vaccinates,
      this.imageRefs,
      this.city,
      this.sId,
      this.name,
      this.desc,
      this.vaccinateFirstCheck,
      this.vaccinateSecondCheck,
      this.vaccinateThirdCheck,
      this.typeOfPet,
      this.typeOfPetOwner,
      this.dateOfAdd,
      this.age,
      this.numberOfViews,
      this.iV,
      this.locationString,
      this.userID,
      this.gender,
      this.petBreed});

  Pet.fromJson(Map<String, dynamic> json) {
    character = json['character'] != null
        ? new Character.fromJson(json['character'])
        : null;
    location = json['location'] != null
        ? new MyLocation.fromJson(json['location'])
        : null;
    vaccinates = json['vaccinates'];
    imageRefs = json['imageRefs'].cast<String>();
    vaccinateFirstCheck = json['vaccinateFirstCheck'];
    vaccinateSecondCheck = json['vaccinateSecondCheck'];
    vaccinateThirdCheck = json['vaccinateThirdCheck'];
    desc = json['desc'];
    city = json['city'];
    userID = json['userID'];
    gender = json['gender'];
    petBreed = json['petBreed'];
    sId = json['_id'];
    name = json['name'];
    typeOfPet = json['typeOfPet'];
    typeOfPetOwner = json['typeOfPetOwner'];
    dateOfAdd = json['dateOfAdd'];
    age = json['age'];
    numberOfViews = json['numberOfViews'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.character != null) {
      data['character'] = this.character.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['vaccinates'] = this.vaccinates;
    data['city'] = this.city;
    data['vaccinateFirstCheck'] = this.vaccinateFirstCheck;
    data['vaccinateSecondCheck'] = this.vaccinateSecondCheck;
    data['vaccinateThirdCheck'] = this.vaccinateThirdCheck;
    data['desc'] = this.desc;
    data['userID'] = this.userID;
    data['petBreed'] = this.petBreed;
    data['gender'] = this.gender;
    data['imageRefs'] = this.imageRefs;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['typeOfPet'] = this.typeOfPet;
    data['typeOfPetOwner'] = this.typeOfPetOwner;
    data['dateOfAdd'] = this.dateOfAdd;
    data['age'] = this.age;
    data['numberOfViews'] = this.numberOfViews;
    data['__v'] = this.iV;

    return data;
  }

  @override
  String toString() {
    return 'Pet(userID: $userID,character: $character, location: $location, vaccinates: $vaccinates, imageRefs: $imageRefs, sId: $sId, name: $name, typeOfPet: $typeOfPet, typeOfPetOwner: $typeOfPetOwner, dateOfAdd: $dateOfAdd, age: $age, numberOfViews: $numberOfViews, iV: $iV,gender : $gender, petBreed : $petBreed)';
  }
}
