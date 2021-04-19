import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class MapsEvent extends Equatable {
  const MapsEvent();

  @override
  List<Object> get props => [];
}

class FetchMyLocationEvent extends MapsEvent {}

class CategoryClickedEvent extends MapsEvent {
  final int index;
  final PageController controller;
  CategoryClickedEvent({this.index, this.controller});

  @override
  List<Object> get props => [index, controller];
}

class DistanceChangedEventSlider extends MapsEvent {
  final double distance;
  DistanceChangedEventSlider({
    this.distance,
  });

  @override
  List<Object> get props => [distance];
}

class DistanceChangedEventFetch extends MapsEvent {
  final PageController controller;
  DistanceChangedEventFetch({
    this.controller,
  });

  @override
  List<Object> get props => [controller];
}
