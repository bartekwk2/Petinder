import 'dart:io';

class RegistrationPetState {
  final String adress;
  final Map coordinates;
  final List<File> images;
  final List<String> imagesPath;
  final String petName;
  final int specieChosen;
  final String breedChosen;
  final String petDesc;

  final int genderChosen;
  final double ageChosen;
  final int originChosen;

  final bool vaccinationFirst;
  final bool vaccinationSecond;
  final bool vaccinationThird;
  final String vaccinationDesc;

  final double health;
  final double active;
  final double smart;
  final double loud;
  final double likesEating;
  final double familyFriendly;
  final double peaceful;
  final double inteligence;
  final double wellBehaved;
  final double indipendent;
  final double fearfull;

  final bool loadingSubmit;
  final bool canGo;

  factory RegistrationPetState.empty() {
    return RegistrationPetState(
      coordinates: {},
      adress: "",
      images: [],
      imagesPath: [],
      petName: "",
      specieChosen: -1,
      breedChosen: "",
      petDesc: "",
      genderChosen: -1,
      ageChosen: 15.0,
      originChosen: -1,
      vaccinationFirst: false,
      vaccinationSecond: false,
      vaccinationThird: false,
      vaccinationDesc: "",
      health: 3.0,
      active: 3.0,
      smart: 3.0,
      loud: 3.0,
      likesEating: 3.0,
      familyFriendly: 3.0,
      peaceful: 3.0,
      inteligence: 3.0,
      wellBehaved: 3.0,
      indipendent: 3.0,
      fearfull: 3.0,
      canGo: false,
      loadingSubmit : false
    );
  }

  RegistrationPetState({
    this.imagesPath,
    this.coordinates,
    this.adress,
    this.images,
    this.petName,
    this.specieChosen,
    this.breedChosen,
    this.petDesc,
    this.genderChosen,
    this.ageChosen,
    this.originChosen,
    this.vaccinationFirst,
    this.vaccinationSecond,
    this.vaccinationThird,
    this.vaccinationDesc,
    this.health,
    this.active,
    this.smart,
    this.loud,
    this.likesEating,
    this.familyFriendly,
    this.peaceful,
    this.inteligence,
    this.wellBehaved,
    this.indipendent,
    this.fearfull,
    this.canGo,
    this.loadingSubmit
  });

  RegistrationPetState copyWith({
    Map coordinates,
    String adress,
    List<File> images,
    List<String> imagesPath,
    String petName,
    int specieChosen,
    String breedChosen,
    String petDesc,
    String location,
    int genderChosen,
    double ageChosen,
    int originChosen,
    bool vaccinationFirst,
    bool vaccinationSecond,
    bool vaccinationThird,
    String vaccinationDesc,
    double health,
    double active,
    double smart,
    double loud,
    double likesEating,
    double familyFriendly,
    double peaceful,
    double indipendent,
    double inteligence,
    double wellBehaved,
    double fearfull,
    bool canGo,
    bool loadingSubmit
  }) {
    return RegistrationPetState(
      coordinates: coordinates ?? this.coordinates,
      adress: adress ?? this.adress,
      images: images ?? this.images,
      imagesPath: imagesPath ?? this.imagesPath,
      petName: petName ?? this.petName,
      specieChosen: specieChosen ?? this.specieChosen,
      breedChosen: breedChosen ?? this.breedChosen,
      petDesc: petDesc ?? this.petDesc,
      genderChosen: genderChosen ?? this.genderChosen,
      ageChosen: ageChosen ?? this.ageChosen,
      originChosen: originChosen ?? this.originChosen,
      vaccinationFirst: vaccinationFirst ?? this.vaccinationFirst,
      vaccinationSecond: vaccinationSecond ?? this.vaccinationSecond,
      vaccinationThird: vaccinationThird ?? this.vaccinationThird,
      vaccinationDesc: vaccinationDesc ?? this.vaccinationDesc,
      health: health ?? this.health,
      active: active ?? this.active,
      smart: smart ?? this.smart,
      loud: loud ?? this.loud,
      likesEating: likesEating ?? this.likesEating,
      familyFriendly: familyFriendly ?? this.familyFriendly,
      peaceful: peaceful ?? this.peaceful,
      inteligence: inteligence ?? this.inteligence,
      wellBehaved: wellBehaved ?? this.wellBehaved,
      indipendent: indipendent ?? this.indipendent,
      fearfull: fearfull ?? this.fearfull,
      canGo: canGo ?? this.canGo,
      loadingSubmit : loadingSubmit ?? this.loadingSubmit
    );
  }
}
