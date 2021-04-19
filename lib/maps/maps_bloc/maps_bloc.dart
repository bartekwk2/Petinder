
import 'package:Petinder/maps/maps_bloc/maps_event.dart';
import 'package:Petinder/maps/maps_bloc/maps_repository.dart';
import 'package:Petinder/maps/maps_bloc/maps_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

class MapsBloc extends Bloc<MapsEvent, MapsState> {
  final MapsRepository mapsRepository;

  MapsBloc({this.mapsRepository}) : super(MapsState.empty());
  @override
  Stream<MapsState> mapEventToState(MapsEvent event) async* {
    if (event is CategoryClickedEvent) {
      if (state.originChosen.contains(event.index)) {
        yield state.copyWith(
            originChosen: state.originChosen..remove(event.index));
      } else {
        yield state.copyWith(
            originChosen: state.originChosen..add(event.index));
      }
      dynamic pets = await mapsRepository.getPetsNearBy(
          state.myPosition["long"],
          state.myPosition["lat"],
          state.distance,
          state.originChosen);
      List<Marker> markers =
          await mapsRepository.addMarkers(pets, event.controller);
      yield state.copyWith(pets: pets, allMarkers: markers);
    } else if (event is DistanceChangedEventFetch) {
      dynamic pets = await mapsRepository.getPetsNearBy(
          state.myPosition["long"],
          state.myPosition["lat"],
          state.distance,
          state.originChosen);
      List<Marker> markers =
          await mapsRepository.addMarkers(pets, event.controller);
      yield state.copyWith(pets: pets, allMarkers: markers);
    } else if (event is DistanceChangedEventSlider) {
      state.circle.clear();
      yield state.copyWith(
          distance: event.distance,
          circle: state.circle
            ..add(
                addCircle(state.myPosition["lat"], state.myPosition["long"])));
    } else if (event is FetchMyLocationEvent) {
      await mapsRepository.setCustomMapPin();
        var myLocationBox = Hive.box("Location");
        dynamic position = myLocationBox.get("positionMap");
      if (position.isEmpty) {
        position = await mapsRepository.determinePosition();
      }
      yield state.copyWith(
          myPosition: position,
          circle: state.circle
            ..add(addCircle(position["lat"], position["long"])));
    }
  }

  Circle addCircle(double lat, double long) {
    return Circle(
        circleId: CircleId(
          "A",
        ),
        center: LatLng(lat, long),
        radius: state.distance * 1000,
        fillColor: Colors.white10.withOpacity(0.3),
        strokeWidth: 3,
        strokeColor: Colors.redAccent);
  }
}
