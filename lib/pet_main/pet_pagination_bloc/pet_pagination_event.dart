import 'package:equatable/equatable.dart';

abstract class PetPaginationEvent extends Equatable {
  const PetPaginationEvent();

  @override
  List<Object> get props => [];
}

class LoadNextPageEvent extends PetPaginationEvent {
  final String fetchingQuery;
  final bool isFiltered;
  final bool isFromScroll;
  final bool isFirstTime;
  LoadNextPageEvent(
      {this.fetchingQuery,
      this.isFiltered,
      this.isFromScroll,
      this.isFirstTime});

  @override
  List<Object> get props =>
      [fetchingQuery, isFiltered, isFromScroll, isFirstTime];
}

class ReloadPetsEvent extends PetPaginationEvent {
  final bool isAdded;
  ReloadPetsEvent({this.isAdded});

  @override
  List<Object> get props => [isAdded];
}

class ClearPetsEvent extends PetPaginationEvent {}
