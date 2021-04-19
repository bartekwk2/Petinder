import 'package:Petinder/pet_profile/pet_profile_bloc/pet_profile_event.dart';
import 'package:Petinder/pet_profile/pet_profile_bloc/pet_profile_repository.dart';
import 'package:Petinder/pet_profile/pet_profile_bloc/pet_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PetProfileBloc extends Bloc<PetProfileEvent, PetProfileState> {
  final PetProfileRepository petProfileRepository;

  PetProfileBloc({this.petProfileRepository}) : super(PetProfileState.empty());

  @override
  Stream<PetProfileState> mapEventToState(PetProfileEvent event) async* {
    if (event is PetProfileInitialEvent) {
      var userDataInit = petProfileRepository.getUserData(event.userID);
      var checkIfLikedInit =
          petProfileRepository.checkIfLiked(event.myID, event.petID);
      dynamic userData = await userDataInit;
      if (userData.contains("@")) {
        userData = userData.split("@").first;
      }
      List<bool> likeIndicators = await checkIfLikedInit;
      yield state.copyWith(
          userData: userData,
          isFavourite: likeIndicators[0],
          isOwnOrDisliked: likeIndicators[1],
          isFetched: true);
    } else if (event is AddPetToFavouriteEvent) {
      bool success = await petProfileRepository.addPet(event.myID, event.petID);
      if (success) {
        yield state.copyWith(isFavourite: true, isOwnOrDisliked: false);
      }
    } else if (event is ChangePetToFavourtieEvent) {
      bool success =
          await petProfileRepository.changePetToLiked(event.myID, event.petID);
      if (success) {
        yield state.copyWith(isFavourite: true, isOwnOrDisliked: false);
      }
    } else if (event is RemovePetFromFavouriteEvent) {
      bool success =
          await petProfileRepository.removePet(event.myID, event.petID);
      if (success) {
        yield state.copyWith(isFavourite: false, isOwnOrDisliked: false);
      }
    } else if (event is CanGoToChatEvent) {
      bool canGo = await petProfileRepository.addNewUserIfNeeded(
          event.myID, event.userID);
      yield state.copyWith(canGoToChat: canGo);
    } else if (event is ClearEvent) {
      yield state.copyWith(canGoToChat: false, deletionOk: false);
    } else if (event is DeletePetEvent) {
      bool canGo = await petProfileRepository.deletePet(event.petID);
      yield state.copyWith(deletionOk: canGo);
    }
  }
}
