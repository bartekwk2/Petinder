import 'package:Petinder/swipe/swipe_fetching_bloc/swipe_fetching_event.dart';
import 'package:Petinder/swipe/swipe_fetching_bloc/swipe_fetching_repository.dart';
import 'package:Petinder/swipe/swipe_fetching_bloc/swipe_fetching_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SwipeFetchingBloc extends Bloc<SwipeFetchingEvent, SwipeFetchingState> {
  final SwipeRepository swipeRepository;
  SwipeFetchingBloc({this.swipeRepository}) : super(InitialSwipeState());

  @override
  Stream<Transition<SwipeFetchingEvent, SwipeFetchingState>> transformEvents(
    Stream<SwipeFetchingEvent> events,
    TransitionFunction<SwipeFetchingEvent, SwipeFetchingState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) => event is! FetchPetsEvent);
    final debounceStream = events
        .where((event) => event is FetchPetsEvent)
        .debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
      MergeStream([nonDebounceStream, debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<SwipeFetchingState> mapEventToState(SwipeFetchingEvent event) async* {
    if (event is FetchPetsEvent) {
      List<dynamic> pets = await swipeRepository.getSwipePets(event.longitude,
          event.latitude, event.distance, event.limit, event.page, event.id);
      if (pets != null) {
        if (pets.isNotEmpty) {
          yield FetchPetsState(pets: pets);
        } else {
          yield NoMorePetsState();
        }
      } else {
        yield ErrorSwipeState();
      }
    } else if (event is SwipingDisableEvent) {
      yield SwipingDisableState();
    } else if (event is SwipingEnabledEvent) {
      yield SwipingEnabledState();
    } else if (event is SwipeRightEvent) {
      yield SwipeRightState();
    } else if (event is SwipeLeftEvent) {
      yield SwipeLeftState();
    } else if (event is AddToFavoriteOrRejectedEvent) {
      swipeRepository.addPet(event.sId, event.petType, event.petRef);
      yield SwipingEnabledState();
    }
  }
}
