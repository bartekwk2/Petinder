import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class FetchResultsEvent extends SearchEvent {
  final String query;
  FetchResultsEvent({this.query});
  @override
  List<Object> get props => [query];
}

class ClickedEndSearchEvent extends SearchEvent {
  final dynamic friendChosen;
  ClickedEndSearchEvent({this.friendChosen});
  @override
  List<Object> get props => [friendChosen];
}

class AddFriendEvent extends SearchEvent {
  final dynamic friendID;
  AddFriendEvent({this.friendID});
  @override
  List<Object> get props => [friendID];
}


