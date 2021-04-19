import 'dart:convert';

import 'package:Petinder/pet_main/pet_main_bloc/pet_main_state.dart';

class PetMainRepository {
  String getPetsNearByWithQuery(
      double long, double lat, double dist, PetMainState state) {
    Map body = {};

    if (state.originChosen != -1) {
      body["typeOfPetOwner"] = state.originChosen;
    }
    if (state.genderChosen != -1) {
      body["gender"] = state.genderChosen;
    }
    if (state.specieChosen != -1) {
      body["typeOfPet"] = state.specieChosen;
    }
    state.characterChosen.forEach((element) {
      body[convertToEnglish(element)] = state.chosen[element];
    });

    if (state.breedChosen.isNotEmpty) {
      body["petBreed"] = state.breedChosen;
    }

    int lower = state.ageChosenLower.round();
    int upper = state.ageChosenUpper.round();

    if (body.isNotEmpty ||lower!=0 || upper!=25) {
      body["ageStart"] = lower;
      body["ageStop"] = upper;
      body["longitude"] = long;
      body["latitude"] = lat;
      body["distance"] = dist * 1000;
      print(body);
    }

    String encodedBody = jsonEncode(body);

    return encodedBody;
  }

  //-----------------------------------------------------------------------------

  String convertChosenToString(PetMainState petMainState) {
    String chosen = "Wybrano: ";

    chosen += originChosen(petMainState.originChosen);
    chosen +=
        ageChosen(petMainState.ageChosenLower, petMainState.ageChosenUpper);
    chosen += genderChosen(petMainState.genderChosen);
    chosen += specieChosen(petMainState.specieChosen);
    chosen += breedChosen(petMainState.breedChosen);
    chosen +=
        characterChosen(petMainState.characterChosen, petMainState.chosen);

    if (chosen != "Wybrano: ") {
      chosen = chosen.replaceFirst(", ", "");
      return chosen;
    } else {
      return "";
    }
  }
}

String originChosen(int index) {
  String word = "";
  switch (index) {
    case -1:
      break;
    case 0:
      word = ", hodowla";
      break;
    case 1:
      word = ", domowe";
      break;
    case 2:
      word = ", schronisko";
      break;
  }
  return word;
}

String convertToEnglish(String polish) {
  String word = "";
  switch (polish) {
    case "Aktywny":
      word = "active";
      break;
    case "Głośny":
      word = "loud";
      break;
    case "Żarłoczny":
      word = "likesEating";
      break;
    case "Rodzinny":
      word = "familyFriendly";
      break;
    case "Mądry":
      word = "smart";
      break;
    case "Tresowany":
      word = "wellBehaved";
      break;
    case "Strachliwy":
      word = "fearfull";
      break;
    case "Łagodny":
      word = "peaceful";
      break;
    case "Samodzielny":
      word = "indipendent";
      break;
    case "Zdrowy":
      word = "health";
      break;
  }
  return word;
}

String breedChosen(String breed) {
  if (breed.isNotEmpty) {
    return ", $breed";
  } else {
    return "";
  }
}

String genderChosen(int index) {
  String word = "";
  switch (index) {
    case -1:
      break;
    case 0:
      word = ", samiec";
      break;
    case 1:
      word = ", samica";
      break;
  }
  return word;
}

String specieChosen(int index) {
  String word = "";
  switch (index) {
    case -1:
      break;
    case 0:
      word = ", pies";
      break;
    case 1:
      word = ", kot";
      break;
    case 2:
      word = ", królik";
      break;
    case 3:
      word = ", chomik";
      break;
    case 4:
      word = ", świnka morska";
      break;
    case 5:
      word = ", żółw";
      break;
    case 6:
      word = ", koń";
      break;
    case 7:
      word = ", inne";
      break;
  }
  return word;
}

String characterChosen(List<String> characterChosen, Map<String, int> chosen) {
  String word = "";
  characterChosen.forEach((element) {
    word += ", ${element.toLowerCase()} ";
    word += powerOfCharacter(chosen[element]);
  });
  return word;
}

String powerOfCharacter(int index) {
  String word = "";
  switch (index) {
    case 0:
      word = ": dużo";
      break;
    case 1:
      word = ": średnio";
      break;
    case 2:
      word = ": mało";
      break;
  }
  return word;
}

String ageChosen(double lower, double upper) {
  String word = "";
  if (lower != 0.0 || upper != 25.0) {
    word = ", wiek: ${lower.round()} - ${upper.round()}";
  }
  return word;
}
