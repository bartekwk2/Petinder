import 'package:equatable/equatable.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class ChooseViewEvent extends BottomNavigationEvent {
  final int viewIndex;
  final bool isAdded;
  ChooseViewEvent({this.viewIndex,this.isAdded});
  @override
  List<Object> get props => [viewIndex,isAdded];
}

class InitialNavigationEvent extends BottomNavigationEvent {}

class LogoutEvent extends BottomNavigationEvent {}
