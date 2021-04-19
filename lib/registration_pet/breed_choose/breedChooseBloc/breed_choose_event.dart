import 'package:Petinder/models/petNames.dart';
import 'package:equatable/equatable.dart';

abstract class BreedChooseEvent extends Equatable {
  const BreedChooseEvent();

  @override
  List<Object> get props => [];
}

class PetNotChosenEvent extends BreedChooseEvent{
}

class PetChosenEvent extends BreedChooseEvent {
  final PetName petName;
    PetChosenEvent({this.petName});
    @override
  List<Object> get props => [petName];
}
