import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsState {
  final List<dynamic> pets;
  final List<int> originChosen;
  final double distance;
  final Map<String, dynamic> myPosition;
  final List<Marker> allMarkers;
  final Set<Circle> circle;
 

  factory MapsState.empty() {
    return MapsState(
        pets: [],
        originChosen: [0,1,2],
        distance: 20,
        myPosition: {},
        circle: {},
        allMarkers: []);
  }

  MapsState(
      {this.distance,
      this.originChosen,
      this.pets,
      this.circle,
      this.myPosition,
      this.allMarkers});

  MapsState copyWith(
      {List<dynamic> pets,
      List<int> originChosen,
      double distance,
      PageController pageController,
      Set<Circle> circle,
      Map<String, dynamic> myPosition,
      List<Marker> allMarkers}) {
    return MapsState(
        pets: pets ?? this.pets,
        circle: circle ?? this.circle,
        originChosen: originChosen ?? this.originChosen,
        distance: distance ?? this.distance,
        myPosition: myPosition ?? this.myPosition,
        allMarkers: allMarkers ?? this.allMarkers);
  }

  @override
  String toString() {
    return 'MapsState(pets: $pets, originChosen: $originChosen, distance: $distance, myPosition: $myPosition, allMarkers :$allMarkers, circle: $circle)';
  }
}
