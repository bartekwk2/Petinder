
import 'package:flutter_bloc/flutter_bloc.dart';

import 'breed_choose_event.dart';
import 'breed_choose_state.dart';

class BreedChooseBloc extends Bloc<BreedChooseEvent, BreedChooseState> {
  BreedChooseBloc() : super(FirstScreenInitialState());

  @override
  Stream<BreedChooseState> mapEventToState(BreedChooseEvent event) async* {
    if (event is PetChosenEvent) {
      yield* _mapPetChosenEventToState(event);
    } else if (event is PetNotChosenEvent) {
      yield* _mapPetNotChosenEventToState();
    }
  }

  Stream<BreedChooseState> _mapPetChosenEventToState(
      PetChosenEvent event) async* {
    yield PetChosenState(petName: event.petName);
  }

  Stream<BreedChooseState> _mapPetNotChosenEventToState() async* {
    yield PetNotChosenState();
  }
}
