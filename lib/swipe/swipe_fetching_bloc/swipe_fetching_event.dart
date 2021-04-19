
import 'package:equatable/equatable.dart';

abstract class SwipeFetchingEvent extends Equatable {
  const SwipeFetchingEvent();
  @override
  List<Object> get props => [];
}

class InitialEvent extends SwipeFetchingEvent {}

class FetchPetsEvent extends SwipeFetchingEvent {
  final double longitude;
  final double latitude;
  final double distance;
  final int limit;
  final int page;
  final String id;
  FetchPetsEvent(
      {this.longitude,
      this.latitude,
      this.distance,
      this.limit,
      this.page,
      this.id});
  @override
  List<Object> get props => [longitude, latitude, distance, limit, page, id];
}

class AddToFavoriteOrRejectedEvent extends SwipeFetchingEvent {
  final String sId;
  final String petType;
  final String petRef;
  AddToFavoriteOrRejectedEvent({this.sId, this.petType, this.petRef});
  @override
  List<Object> get props => [sId, petType, petRef];
}

class SwipeLeftEvent extends SwipeFetchingEvent {}

class SwipeRightEvent extends SwipeFetchingEvent {}

class SwipingEnabledEvent extends SwipeFetchingEvent {}

class SwipingDisableEvent extends SwipeFetchingEvent {}

class NoMorePetsEvent extends SwipeFetchingEvent {}
