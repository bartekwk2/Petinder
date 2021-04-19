import 'package:Petinder/models/petNames.dart';
import 'package:equatable/equatable.dart';

abstract class BreedChooseState extends Equatable {
  const BreedChooseState();

  @override
  List<Object> get props => [];
}

class FirstScreenInitialState extends BreedChooseState {}

class PetNotChosenState extends BreedChooseState {}

class PetChosenState extends BreedChooseState {
  final PetName petName;
  PetChosenState({this.petName});
  @override
  List<Object> get props => [petName];
}
