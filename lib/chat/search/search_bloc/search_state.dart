import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object> get props => [];
}

class SearchInitialState extends SearchState {}

class SearchMiddleState extends SearchState {}

class SearchLoadingState extends SearchState {
  final String message;
  SearchLoadingState({this.message});
  @override
  List<Object> get props => [message];
}

class SearchErrorState extends SearchState {
  final String error;
  SearchErrorState({this.error});
  @override
  List<Object> get props => [error];
}

class SearchSuccessState extends SearchState {
  final List<dynamic> userNames;
  SearchSuccessState({this.userNames});
  @override
  List<Object> get props => [userNames];
}

class ClickedEndSearchState extends SearchState {
  final dynamic friendChosen;
  ClickedEndSearchState({this.friendChosen});
  @override
  List<Object> get props => [friendChosen];
}

class AddingFriendSuccessState extends SearchState{
  
}


