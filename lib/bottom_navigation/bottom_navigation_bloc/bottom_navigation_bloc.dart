import 'dart:async';
import 'package:Petinder/di/injection_container.dart';
import 'package:Petinder/pet_main/refresh_pet_main_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'bottom_navigation_event.dart';
import 'bottom_navigation_repository.dart';
import 'bottom_navigation_state.dart';

class BotttomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  final BottomNavigationRepository bottomNavigationRepository;
  StreamSubscription _streamSubscription;

  BotttomNavigationBloc({this.bottomNavigationRepository})
      : super(BottomNavigationState.empty()) {
    _streamSubscription =
        inject<RefreshPetMainBloc>().refreshsObservable.listen((bool event) {
      this.add(ChooseViewEvent(viewIndex: 5, isAdded: event));
    });
  }
  @override
  Stream<BottomNavigationState> mapEventToState(
      BottomNavigationEvent event) async* {
    if (event is ChooseViewEvent) {
      bool isAdded = event.isAdded ?? false;
      yield state.copyWith(pageChosen: event.viewIndex, isAdded: isAdded);
      var chatBox = Hive.box("Chat");
      if (event.viewIndex == 4) {
        await chatBox.put("isOpen", true);
      } else {
        await chatBox.put("isOpen", false);
      }
    } else if (event is InitialNavigationEvent) {
      Future.delayed(Duration(milliseconds: 300));
      Box locationBox = Hive.box("Location");
      await locationBox.put("newLocation", false);
      dynamic user = await bottomNavigationRepository.getUserInfo();
      dynamic myPosition = locationBox.get("positionMap");
      dynamic country = locationBox.get("country");
      dynamic city = locationBox.get("city");
      yield state.copyWith(
          positionMap: myPosition, country: country, city: city, user: user);
    } else if (event is LogoutEvent) {
      await bottomNavigationRepository.changeStatus(false);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
