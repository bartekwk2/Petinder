import 'dart:convert';
import 'package:Petinder/chat/search/search_bloc/search_event.dart';
import 'package:Petinder/chat/search/search_bloc/search_repository.dart';
import 'package:Petinder/chat/search/search_bloc/search_state.dart';
import 'package:Petinder/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({this.searchRepository}) : super(SearchInitialState());

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
    Stream<SearchEvent> events,
    TransitionFunction<SearchEvent, SearchState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is FetchResultsEvent) {
      yield* _mapLoadNextPageToState(event);
    } else if (event is ClickedEndSearchEvent) {
      yield* _clickedEndSearch(event);
    } else if (event is AddFriendEvent) {
      yield* _addFriendEvent(event);
    }
  }

  Stream<SearchState> _addFriendEvent(AddFriendEvent event) async* {
    int code = await searchRepository.addFriend(event.friendID);
    if (code == 200) {
      yield AddingFriendSuccessState();
    } else {
      yield SearchErrorState(error: "Błąd dodawania użytkownika");
    }
  }

  Stream<SearchState> _mapLoadNextPageToState(FetchResultsEvent event) async* {
    yield SearchLoadingState(message: 'Ładowanie znajomych');
    final response = await searchRepository.getResults(query: event.query);
    if (response is http.Response) {
      if (response.statusCode == 200) {
        var userNames = jsonDecode(response.body)["pet"].map((val) {
          return UserApp.fromJson(val);
        }).toList();
        yield SearchSuccessState(
          userNames: userNames,
        );
      } else {
        yield SearchErrorState(error: response.body);
      }
    } else if (response is String) {
      yield SearchErrorState(error: response);
    }
  }

  Stream<SearchState> _clickedEndSearch(ClickedEndSearchEvent event) async* {
    yield ClickedEndSearchState(friendChosen: event.friendChosen);
  }
}
