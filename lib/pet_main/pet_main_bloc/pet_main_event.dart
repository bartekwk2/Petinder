import 'package:equatable/equatable.dart';

abstract class PetMainEvent extends Equatable {
  const PetMainEvent();

  @override
  List<Object> get props => [];
}

class ChooseSpecieEventFilter extends PetMainEvent {
  final int specieIndex;
  ChooseSpecieEventFilter({this.specieIndex});
  @override
  List<Object> get props => [specieIndex];
}

class ChooseBreedEventFilter extends PetMainEvent {
  final String breedName;
  ChooseBreedEventFilter({this.breedName});
  @override
  List<Object> get props => [breedName];
}

class ChooseGenderEventFilter extends PetMainEvent {
  final int genderEvent;
  ChooseGenderEventFilter({this.genderEvent});
  @override
  List<Object> get props => [genderEvent];
}

class ChooseAgeEventFilter extends PetMainEvent {
  final double ageLower;
  final double ageHigher;
  ChooseAgeEventFilter({this.ageLower, this.ageHigher});
  @override
  List<Object> get props => [ageHigher, ageLower];
}

class ChooseOriginEventFilter extends PetMainEvent {
  final int originEvent;
  ChooseOriginEventFilter({this.originEvent});
  @override
  List<Object> get props => [originEvent];
}

class AddPetCharacter extends PetMainEvent {
  final String petCharacter;
  AddPetCharacter({this.petCharacter});
  @override
  List<Object> get props => [petCharacter];
}

class RemovePetCharacter extends PetMainEvent {
  final String petCharacter;
  RemovePetCharacter({this.petCharacter});
  @override
  List<Object> get props => [petCharacter];
}

class UpdatePetCharacter extends PetMainEvent {
  final String petCharacter;
  final int index;
  UpdatePetCharacter({this.petCharacter, this.index});
  @override
  List<Object> get props => [petCharacter, index];
}

class PetFiltersEvent extends PetMainEvent {
  final String filtersChosen;
  PetFiltersEvent({this.filtersChosen});
  @override
  List<Object> get props => [filtersChosen];
}

class QueryBodyEvent extends PetMainEvent {
  final String queryBody;
  QueryBodyEvent({this.queryBody});
  @override
  List<Object> get props => [queryBody];
}

class SubmitFilteringPetEvent extends PetMainEvent {}
