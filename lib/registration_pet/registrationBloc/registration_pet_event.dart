import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class RegisterPetEvent extends Equatable {
  const RegisterPetEvent();

  @override
  List<Object> get props => [];
}

class FetchLocationEvent extends RegisterPetEvent {}

class AddImageEvent extends RegisterPetEvent {
  final File newImage;
  final String newImagePath;
  AddImageEvent({this.newImage,this.newImagePath});
  @override
  List<Object> get props => [newImage,newImagePath];
}

class AddPetNameEvent extends RegisterPetEvent {
  final String petName;
  AddPetNameEvent({this.petName});
  @override
  List<Object> get props => [petName];
}

class ChooseSpecieEvent extends RegisterPetEvent {
  final int specieIndex;
  ChooseSpecieEvent({this.specieIndex});
  @override
  List<Object> get props => [specieIndex];
}

class ChooseBreedEvent extends RegisterPetEvent {
  final String breedName;
  ChooseBreedEvent({this.breedName});
  @override
  List<Object> get props => [breedName];
}

class AddPetDescEvent extends RegisterPetEvent {
  final String petDesc;
  AddPetDescEvent({this.petDesc});
  @override
  List<Object> get props => [petDesc];
}

class AddLocationEvent extends RegisterPetEvent {
  final String location;
  AddLocationEvent({this.location});
  @override
  List<Object> get props => [location];
}

class ChooseGenderEvent extends RegisterPetEvent {
  final int genderEvent;
  ChooseGenderEvent({this.genderEvent});
  @override
  List<Object> get props => [genderEvent];
}

class ChooseAgeEvent extends RegisterPetEvent {
  final double age;
  ChooseAgeEvent({this.age});
  @override
  List<Object> get props => [age];
}

class ChooseOriginEvent extends RegisterPetEvent {
  final int originEvent;
  ChooseOriginEvent({this.originEvent});
  @override
  List<Object> get props => [originEvent];
}

class MarkVaccinationFirstEvent extends RegisterPetEvent {
  final bool isMarked;
  MarkVaccinationFirstEvent({this.isMarked});
  @override
  List<Object> get props => [isMarked];
}

class MarkVaccinationSecondEvent extends RegisterPetEvent {
  final bool isMarked;
  MarkVaccinationSecondEvent({this.isMarked});
  @override
  List<Object> get props => [isMarked];
}

class MarkVaccinationThirdEvent extends RegisterPetEvent {
  final bool isMarked;
  MarkVaccinationThirdEvent({this.isMarked});
  @override
  List<Object> get props => [isMarked];
}

class AddvaccinationDescEvent extends RegisterPetEvent {
  final String vaccinationDesc;
  AddvaccinationDescEvent({this.vaccinationDesc});
  @override
  List<Object> get props => [vaccinationDesc];
}

class ChooseHealthLevelEvent extends RegisterPetEvent {
  final double level;
  ChooseHealthLevelEvent({this.level});
  @override
  List<Object> get props => [level];
}

class ChooseActiveLevelEvent extends RegisterPetEvent {
  final double level;
  ChooseActiveLevelEvent({this.level});
  @override
  List<Object> get props => [level];
}

class ChooseSmartLevelEvent extends RegisterPetEvent {
  final double level;
  ChooseSmartLevelEvent({this.level});
  @override
  List<Object> get props => [level];
}

class ChooseLoudLevelEvent extends RegisterPetEvent {
  final double level;
  ChooseLoudLevelEvent({this.level});
  @override
  List<Object> get props => [level];
}

class ChooseLikesEatingLevelEvent extends RegisterPetEvent {
  final double level;
  ChooseLikesEatingLevelEvent({this.level});
  @override
  List<Object> get props => [level];
}

class ChooseFamilyFriendlyLevelEvent extends RegisterPetEvent {
  final double level;
  ChooseFamilyFriendlyLevelEvent({this.level});
  @override
  List<Object> get props => [level];
}

class ChoosePeacefulLevelEvent extends RegisterPetEvent {
  final double level;
  ChoosePeacefulLevelEvent({this.level});
  @override
  List<Object> get props => [level];
}

class ChooseInteligenceLevelEvent extends RegisterPetEvent {
  final double level;
  ChooseInteligenceLevelEvent({this.level});
  @override
  List<Object> get props => [level];
}

class ChooseWellBehavedLevelEvent extends RegisterPetEvent {
  final double level;
  ChooseWellBehavedLevelEvent({this.level});
  @override
  List<Object> get props => [level];
}

class ChooseIndipendentLevelEvent extends RegisterPetEvent {
  final double level;
  ChooseIndipendentLevelEvent({this.level});
  @override
  List<Object> get props => [level];
}

class ChooseFearfullLevelEvent extends RegisterPetEvent {
  final double level;
  ChooseFearfullLevelEvent({this.level});
  @override
  List<Object> get props => [level];
}

class SubmitAddingPetEvent extends RegisterPetEvent {}

class RefreshCanGoEvent extends RegisterPetEvent {}
