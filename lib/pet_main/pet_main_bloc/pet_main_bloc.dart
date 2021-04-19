import 'package:Petinder/pet_main/pet_main_bloc/pet_main_event.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_repository.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class PetMainBloc extends Bloc<PetMainEvent, PetMainState> {
  final PetMainRepository petMainRepository;

  PetMainBloc({this.petMainRepository}) : super(PetMainState.empty());
  @override
  Stream<PetMainState> mapEventToState(PetMainEvent event) async* {
    if (event is ChooseSpecieEventFilter) {
      yield state.copyWith(specieChosen: event.specieIndex);
    } else if (event is ChooseBreedEventFilter) {
      yield state.copyWith(breedChosen: event.breedName);
    } else if (event is ChooseGenderEventFilter) {
      yield state.copyWith(genderChosen: event.genderEvent);
    } else if (event is PetFiltersEvent) {
      yield state.copyWith(filtersChosen: event.filtersChosen);
    } else if (event is ChooseAgeEventFilter) {
      yield state.copyWith(
          ageChosenLower: event.ageLower, ageChosenUpper: event.ageHigher);
    } else if (event is ChooseOriginEventFilter) {
      yield state.copyWith(originChosen: event.originEvent);
    } else if (event is AddPetCharacter) {
      state.copyWith(
          characterChosen: state.characterChosen..add(event.petCharacter),
          character: state.character..remove(event.petCharacter));
    } else if (event is RemovePetCharacter) {
      state.copyWith(
          characterChosen: state.characterChosen..remove(event.petCharacter),
          character: state.character..add(event.petCharacter));
    } else if (event is UpdatePetCharacter) {
      var characterChosen = state.characterChosen;
      var chosen = state.chosen;
      var character = state.character;
      chosen[event.petCharacter] = event.index;
      if (!characterChosen.contains(event.petCharacter)) {
        characterChosen.add(event.petCharacter);
      } else {
        character.remove(event.petCharacter);
      }
      yield state.copyWith(
          character: character,
          chosen: chosen,
          characterChosen: characterChosen);
    } else if (event is SubmitFilteringPetEvent) {
      var myLocationBox = Hive.box("Location");
      dynamic myLocation = myLocationBox.get("positionMap");
      var myLat = myLocation["lat"];
      var myLong = myLocation["long"];
      var queryBody =
          petMainRepository.getPetsNearByWithQuery(myLong, myLat, 800, state);
      bool areTheSame = false;
      if (state.queryBody == queryBody) {
        areTheSame = true;
      } else {
        areTheSame = false;
      }
      yield state.copyWith(
          queryBody: queryBody, filterExit: true, filtersSame: areTheSame);
      String chosen = petMainRepository.convertChosenToString(state);
      yield state.copyWith(filtersChosen: chosen, filterExit: false);
    }
  }
}
