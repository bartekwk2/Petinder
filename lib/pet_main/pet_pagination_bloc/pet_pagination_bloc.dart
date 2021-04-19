import 'dart:async';
import 'dart:convert';
import 'package:Petinder/models/pet.dart';
import 'package:Petinder/pet_main/pet_pagination_bloc/pet_pagination_event.dart';
import 'package:Petinder/pet_main/pet_pagination_bloc/pet_pagination_repository.dart';
import 'package:Petinder/pet_main/pet_pagination_bloc/pet_pagination_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class PetPaginationBloc extends Bloc<PetPaginationEvent, PetPaginationState> {
  final PetPaginationRepository paginationRepository;
  int page = 1;
  String query = "{}";
  bool newQuery = false;
  bool isFiltered = false;

  @override
  Stream<Transition<PetPaginationEvent, PetPaginationState>> transformEvents(
    Stream<PetPaginationEvent> events,
    TransitionFunction<PetPaginationEvent, PetPaginationState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 400)),
      transitionFn,
    );
  }

  PetPaginationBloc({this.paginationRepository})
      : super(PetPaginationState.empty());

  @override
  Stream<PetPaginationState> mapEventToState(PetPaginationEvent event) async* {
    if (event is LoadNextPageEvent) {
      yield* _mapLoadNextPageToState(event);
    } else if (event is ClearPetsEvent) {
      yield state.copyWith(pets: []);
    } else if (event is ReloadPetsEvent) {
      print("isAdded ${event.isAdded}");
      yield state.copyWith(isAdded: event.isAdded, showSheet: true);
      newQuery = true;
      page = 1;
      yield* _fetchPets();
    }
  }

  Stream<PetPaginationState> _mapLoadNextPageToState(
      LoadNextPageEvent event) async* {
    bool firstTime = event.isFirstTime;

    if (event.isFiltered != null) {
      isFiltered = event.isFiltered;
      if (isFiltered) {
        query = event.fetchingQuery;
      } else {
        query = "{}";
      }
    }

    if (firstTime && state.firstTime == false) {
      print("A");
      //yield state.copyWith(isLoading: false, isError: false, firstTime: false);
    } else {
      print("B");
      if (event.isFromScroll) {
        newQuery = false;
      } else {
        newQuery = true;
        page = 1;
      }
      yield state.copyWith(
          message: 'Ładowanie zwierzaków', isLoading: true, isError: false);
      yield* _fetchPets();
    }
  }

  Stream<PetPaginationState> _fetchPets() async* {
    dynamic response;
    var myLocationBox = Hive.box("Location");
    dynamic myLocation = myLocationBox.get("positionMap");
    var myLat = myLocation["lat"];
    var myLong = myLocation["long"];
    print("QUERY $query");
    if (query == "{}") {
      response =
          await paginationRepository.getPets(myLong, myLat, 800, 8, page);
    } else {
      response = await paginationRepository.getPetsWithQuery(query, page, 8);
    }
    if (response is http.Response) {
      if (response.statusCode == 200) {
        var pets = jsonDecode(response.body)["pet"].map((pet) {
          var petOutput = Pet.fromJson(pet);
          var lat = petOutput.location.coordinates[1];
          var long = petOutput.location.coordinates[0];
          petOutput.locationString =
              paginationRepository.distanceBetween(lat, long, myLat, myLong);
          return petOutput;
        }).toList();

        var petsState = state.pets;
        if (newQuery) {
          petsState.clear();
        }
        petsState.addAll(pets);
        if (pets.isEmpty) {
          yield state.copyWith(
              noMorePets: true,
              isLoading: false,
              showSheet: false,
              isError: false,
              pets: petsState,
              firstTime: false);
          yield state.copyWith(
              noMorePets: false,
              isLoading: false,
              showSheet: false,
              isError: false,
              firstTime: false);
        } else {
          yield state.copyWith(
            isLoading: false,
            showSheet: false,
            isError: false,
            newQuery: newQuery,
            pets: petsState,
          );
          yield state.copyWith(
              newQuery: false,
              isLoading: false,
              showSheet: false,
              isError: false,
              firstTime: false);
        }
        page++;
      } else {
        yield state.copyWith(
            error: response.body,
            isLoading: false,
            showSheet: false,
            isError: true,
            firstTime: false);
      }
    } else if (response is String) {
      yield state.copyWith(
          error: response,
          isLoading: false,
          isError: true,
          firstTime: false,
          showSheet: false);
    }
  }
}
