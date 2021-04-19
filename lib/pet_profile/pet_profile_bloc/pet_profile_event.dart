import 'package:equatable/equatable.dart';

abstract class PetProfileEvent extends Equatable {
  const PetProfileEvent();

  @override
  List<Object> get props => [];
}

class PetProfileInitialEvent extends PetProfileEvent {
  final String myID;
  final String petID;
  final String userID;
  PetProfileInitialEvent({this.myID, this.petID, this.userID});
  @override
  List<Object> get props => [myID, petID, userID];
}

class AddPetToFavouriteEvent extends PetProfileEvent {
  final String myID;
  final String petID;
  AddPetToFavouriteEvent({this.myID, this.petID});
  @override
  List<Object> get props => [myID, petID];
}

class RemovePetFromFavouriteEvent extends PetProfileEvent {
  final String myID;
  final String petID;
  RemovePetFromFavouriteEvent({this.myID, this.petID});
  @override
  List<Object> get props => [myID, petID];
}

class ChangePetToFavourtieEvent extends PetProfileEvent {
  final String myID;
  final String petID;
  ChangePetToFavourtieEvent({this.myID, this.petID});
  @override
  List<Object> get props => [myID, petID];
}

class CanGoToChatEvent extends PetProfileEvent {
  final String myID;
  final String userID;
  CanGoToChatEvent({this.myID, this.userID});
  @override
  List<Object> get props => [myID, userID];
}

class DeletePetEvent extends PetProfileEvent {
  final String petID;

  DeletePetEvent({this.petID});
  @override
  List<Object> get props => [petID];
}

class ClearEvent extends PetProfileEvent {}
