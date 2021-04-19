import 'package:equatable/equatable.dart';

abstract class SwipeFetchingState extends Equatable {
  const SwipeFetchingState();
  @override
  List<Object> get props => [];
}

class InitialSwipeState extends SwipeFetchingState {}

class ErrorSwipeState extends SwipeFetchingState {}

class FetchPetsState extends SwipeFetchingState {
  final List<dynamic> pets;
  FetchPetsState({this.pets});
}

class SwipeLeftState extends SwipeFetchingState {}

class SwipeRightState extends SwipeFetchingState {}

class SwipingEnabledState extends SwipeFetchingState {}

class SwipingDisableState extends SwipeFetchingState {}

class NoMorePetsState extends SwipeFetchingState {}
