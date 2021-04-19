import 'package:Petinder/registration_pet/registrationBloc/registration_pet_event.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_repository.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class RegistrationPetBloc extends Bloc<RegisterPetEvent, RegistrationPetState> {
  final RegistrationPetRepository registrationPetRepository;

    @override
  Stream<Transition<RegisterPetEvent, RegistrationPetState>> transformEvents(
    Stream<RegisterPetEvent> events,
    TransitionFunction<RegisterPetEvent, RegistrationPetState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) => event is! SubmitAddingPetEvent);
    final debounceStream = events
        .where((event) => event is SubmitAddingPetEvent)
        .throttleTime(Duration(milliseconds: 2000));
    return super.transformEvents(
      MergeStream([nonDebounceStream, debounceStream]),
      transitionFn,
    );
  }

  RegistrationPetBloc({this.registrationPetRepository})
      : super(RegistrationPetState.empty());
  @override
  Stream<RegistrationPetState> mapEventToState(RegisterPetEvent event) async* {
    if (event is FetchLocationEvent) {
      var myLocationBox = Hive.box("Location");
      dynamic position = myLocationBox.get("positionMap");

      if (position.isEmpty) {
        position = await registrationPetRepository.determinePosition();
      }
      String adress = await registrationPetRepository.getAddressFromCoordinates(
          Coordinates(position["lat"], position["long"]));
      yield state.copyWith(adress: adress, coordinates: position);
    } else if (event is AddImageEvent) {
      yield state.copyWith(
          images: state.images..add(event.newImage),
          imagesPath: state.imagesPath..add(event.newImagePath));
    } else if (event is AddPetNameEvent) {
      yield state.copyWith(petName: event.petName);
    } else if (event is ChooseSpecieEvent) {
      yield state.copyWith(specieChosen: event.specieIndex);
    } else if (event is ChooseBreedEvent) {
      yield state.copyWith(breedChosen: event.breedName);
    } else if (event is AddPetDescEvent) {
      yield state.copyWith(petDesc: event.petDesc);
    } else if (event is AddLocationEvent) {
      yield state.copyWith(location: event.location);
    } else if (event is ChooseGenderEvent) {
      yield state.copyWith(genderChosen: event.genderEvent);
    } else if (event is ChooseAgeEvent) {
      yield state.copyWith(ageChosen: event.age);
    } else if (event is ChooseOriginEvent) {
      yield state.copyWith(originChosen: event.originEvent);
    } else if (event is MarkVaccinationFirstEvent) {
      yield state.copyWith(vaccinationFirst: event.isMarked);
    } else if (event is MarkVaccinationSecondEvent) {
      yield state.copyWith(vaccinationSecond: event.isMarked);
    } else if (event is MarkVaccinationThirdEvent) {
      yield state.copyWith(vaccinationThird: event.isMarked);
    } else if (event is AddvaccinationDescEvent) {
      yield state.copyWith(vaccinationDesc: event.vaccinationDesc);
    } else if (event is ChooseHealthLevelEvent) {
      yield state.copyWith(health: event.level);
    } else if (event is ChooseActiveLevelEvent) {
      yield state.copyWith(active: event.level);
    } else if (event is ChooseSmartLevelEvent) {
      yield state.copyWith(smart: event.level);
    } else if (event is ChooseLoudLevelEvent) {
      yield state.copyWith(loud: event.level);
    } else if (event is ChooseLikesEatingLevelEvent) {
      yield state.copyWith(likesEating: event.level);
    } else if (event is ChooseFamilyFriendlyLevelEvent) {
      yield state.copyWith(familyFriendly: event.level);
    } else if (event is ChoosePeacefulLevelEvent) {
      yield state.copyWith(peaceful: event.level);
    } else if (event is ChooseInteligenceLevelEvent) {
      yield state.copyWith(inteligence: event.level);
    } else if (event is ChooseWellBehavedLevelEvent) {
      yield state.copyWith(wellBehaved: event.level);
    } else if (event is ChooseIndipendentLevelEvent) {
      yield state.copyWith(indipendent: event.level);
    } else if (event is ChooseFearfullLevelEvent) {
      yield state.copyWith(fearfull: event.level);
    } else if (event is SubmitAddingPetEvent) {
      String petID = await registrationPetRepository.submitPetAdding(state);
      bool canGo =
          await registrationPetRepository.uploadImages(state.imagesPath, petID);
      yield state.copyWith(canGo: canGo);
    } else if (event is RefreshCanGoEvent) {
      yield state.copyWith(canGo: false);
    }
  }
}
