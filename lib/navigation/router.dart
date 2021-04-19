import 'package:Petinder/bottom_navigation/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:Petinder/bottom_navigation/bottom_navigation_bloc/bottom_navigation_event.dart';
import 'package:Petinder/chat/search/search_view.dart';
import 'package:Petinder/chat/search/search_bloc/search_bloc.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_bloc.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_event.dart';
import 'package:Petinder/chat/message_detail/views/chat_room.dart';
import 'package:Petinder/chat/message_all/chatMain.dart';
import 'package:Petinder/di/injection_container.dart';
import 'package:Petinder/favourite/favourite_pet.dart';
import 'package:Petinder/maps/maps_bloc/maps_bloc.dart';
import 'package:Petinder/maps/maps_bloc/maps_event.dart';
import 'package:Petinder/maps/maps_screen.dart';
import 'package:Petinder/models/pet.dart';
import 'package:Petinder/pet_main/filter.dart';
import 'package:Petinder/pet_main/pet_main.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_bloc.dart';
import 'package:Petinder/pet_main/pet_pagination_bloc/pet_pagination_bloc.dart';
import 'package:Petinder/pet_main/pet_pagination_bloc/pet_pagination_event.dart';
import 'package:Petinder/pet_profile/pet_profile.dart';
import 'package:Petinder/pet_profile/pet_profile_bloc/pet_profile_bloc.dart';
import 'package:Petinder/pet_profile/pet_profile_bloc/pet_profile_event.dart';
import 'package:Petinder/registration_pet/breed_choose/breedChooseBloc/breed_choose_bloc.dart';
import 'package:Petinder/registration_pet/pet_registration.dart';
import 'package:Petinder/registration_pet/breed_choose/pet_breed_screen.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_bloc.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_event.dart';
import 'package:Petinder/registration_pet/secondScreen/popup_card.dart';
import 'package:Petinder/registration_pet/utils/hero_dialog_route.dart';
import 'package:Petinder/swipe/mainSwipe.dart';
import 'package:Petinder/swipe/swipe_fetching_bloc/swipe_fetching_bloc.dart';
import 'package:Petinder/swipe/swipe_fetching_bloc/swipe_fetching_event.dart';
import 'package:Petinder/welcome/auth/auth_bloc/auth_bloc.dart';
import 'package:Petinder/welcome/auth/auth_bloc/auth_event.dart';
import 'package:Petinder/welcome/auth/auth_screen.dart';
import 'package:Petinder/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../bottom_navigation/bottom_navigation.dart';

class AppRouter {
  final BreedChooseBloc _breedChooseBloc = inject<BreedChooseBloc>();
  final SendMessageBloc _sendMessageBloc = inject<SendMessageBloc>();
  final SwipeFetchingBloc _swipeFetchingBloc = inject<SwipeFetchingBloc>();
  final RegistrationPetBloc _registrationPetBloc =
      inject<RegistrationPetBloc>();
  final PetMainBloc _petMainBloc = inject<PetMainBloc>();
  final PetPaginationBloc _petPaginationBloc = inject<PetPaginationBloc>();
  final MapsBloc _mapsBloc = inject<MapsBloc>();
  final SearchBloc _searchBloc = inject<SearchBloc>();
  final AuthBloc _authBloc = inject<AuthBloc>();
  final BotttomNavigationBloc _botttomNavigationBloc =
      inject<BotttomNavigationBloc>();
  final PetProfileBloc _petProfileBloc = inject<PetProfileBloc>();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case (RouteConstant.addPet):
        return MaterialPageRoute(builder: (_) => addPet());
      case (RouteConstant.petBreedChooseRoute):
        final Map arguments = settings.arguments as Map;
        String searchType = arguments['searchType'];
        return MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider.value(
                value: _breedChooseBloc,
                child: PetBreedScreen(
                  searchType: searchType,
                )));
      case (RouteConstant.chatDetailRoute):
        final Map arguments = settings.arguments as Map;
        String friendID = arguments['friendID'];
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: _sendMessageBloc
                  ..add(LoadChatScreenEvent(
                      yourID: Hive.box("IsLogin").get("id"),
                      friendID: friendID)),
                child: ChatRoom(
                  notMyID: friendID,
                )));
      case (RouteConstant.swipeScreen):
        return MaterialPageRoute(builder: (_) => swipeOption());
      case (RouteConstant.profileDetail):
        final Map arguments = settings.arguments as Map;
        Pet pet = arguments['pet'];
        bool swipe = arguments['swipe'];
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _petProfileBloc
                    ..add(PetProfileInitialEvent(
                        myID: Hive.box("IsLogin").get("id"),
                        petID: pet.sId,
                        userID: pet.userID)),
                  child: PetProfilePage(
                    pet: pet,
                    isSwipe: swipe,
                  ),
                ));

      case (RouteConstant.vaccinateDetail):
        return HeroDialogRoute(
          builder: (_) => BlocProvider.value(
            value: _registrationPetBloc,
            child: Center(
              child: TodoPopupCard(),
            ),
          ),
        );

      case (RouteConstant.loginScreen):
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: _authBloc..add(DecideIfLoginEvent(isLogin: true)),
                child: AuthScreen()));
      case (RouteConstant.registerScreen):
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: _authBloc..add(DecideIfLoginEvent(isLogin: false)),
                child: AuthScreen()));

      case (RouteConstant.petMain):
        return MaterialPageRoute(builder: (_) => findPet());

      case (RouteConstant.petMainWithoutRefresh):
        return MaterialPageRoute(builder: (_) => findPetWithoutRebuild());

      case (RouteConstant.homeRoute):
        return MaterialPageRoute(builder: (_) => WelcomeScreen());

      case (RouteConstant.searchScreen):
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: _searchBloc, child: DisplaySearchScreen()));

      case (RouteConstant.petMainFilter):
        return MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => MultiBlocProvider(providers: [
                  BlocProvider.value(value: _breedChooseBloc),
                  BlocProvider.value(value: _petMainBloc)
                ], child: PetMainFilter()));

      case (RouteConstant.mapsScreen):
        return MaterialPageRoute(builder: (_) => mapScreen());

      case (RouteConstant.dashboard):
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: _botttomNavigationBloc..add(InitialNavigationEvent()),
                child: MyHomePage()));

      case (RouteConstant.chatMain):
        return MaterialPageRoute(builder: (_) => chatScreen());
      case (RouteConstant.yourPet):
        return MaterialPageRoute(builder: (_) => yourPetsScreen());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }

  void dispose() {
    _registrationPetBloc.close();
    _breedChooseBloc.close();
    _sendMessageBloc.close();
    _swipeFetchingBloc.close();
    _petMainBloc.close();
    _petPaginationBloc.close();
    _mapsBloc.close();
    _searchBloc.close();
    _authBloc.close();
    _botttomNavigationBloc.close();
    _petProfileBloc.close();
  }
}

Widget addPet() {
  return MultiBlocProvider(providers: [
    BlocProvider.value(value: inject<BreedChooseBloc>()),
    BlocProvider.value(
        value: inject<RegistrationPetBloc>()..add(FetchLocationEvent()))
  ], child: PetRegistration());
}

Widget findPet() {
  return MultiBlocProvider(providers: [
    BlocProvider.value(
        value: inject<PetPaginationBloc>()
          ..add(LoadNextPageEvent(
            isFromScroll: false,
            isFirstTime: true,
          ))),
    BlocProvider.value(value: inject<PetMainBloc>())
  ], child: PetMainScreen());
}

Widget findPetWithRefresh(bool isAdded) {
  return MultiBlocProvider(providers: [
    BlocProvider.value(
        value: inject<PetPaginationBloc>()
          ..add(ReloadPetsEvent(isAdded: isAdded))),
    BlocProvider.value(value: inject<PetMainBloc>())
  ], child: PetMainScreen());
}

Widget findPetWithoutRebuild() {
  return MultiBlocProvider(providers: [
    BlocProvider.value(value: inject<PetPaginationBloc>()),
    BlocProvider.value(value: inject<PetMainBloc>())
  ], child: PetMainScreen());
}

Widget swipeOption() {
  var myLocationBox = Hive.box("Location");
  dynamic position = myLocationBox.get("positionMap");
  var id = Hive.box("IsLogin").get("id");
  return BlocProvider.value(
    value: inject<SwipeFetchingBloc>()
      ..add(FetchPetsEvent(
          longitude: position["long"],
          latitude: position["lat"],
          distance: 800,
          limit: 8,
          page: 1,
          id: id)),
    child: SwipeScreen(),
  );
}

Widget chatScreen() {
  return ChatMain();
}

Widget mapScreen() {
  return BlocProvider.value(
      value: inject<MapsBloc>()..add(FetchMyLocationEvent()),
      child: MapsScreen());
}

Widget yourPetsScreen() {
  return FavouritePetScreen();
}

class RouteConstant {
  RouteConstant._();
  static const String homeRoute = '/';
  static const String addPet = "/addPet";
  static const String petBreedChooseRoute = '/petBreedChoose';
  static const String chatDetailRoute = '/chatDetailRoute';
  static const String swipeScreen = '/swipeScreen';
  static const String profileDetail = '/profileDetail';
  static const String vaccinateDetail = "/vaccinateDetail";
  static const String loginScreen = "/loginScreen";
  static const String registerScreen = "/registerScreen";
  static const String dashboard = "/dashboard";
  static const String petMain = "/petMain";
  static const String petMainWithoutRefresh = "/petMainWithoutRefresh";
  static const String petMainFilter = "/petMainFilter";
  static const String mapsScreen = "/mapsScreen";
  static const String chatMain = "/chatMain";
  static const String searchScreen = "/searchScreen";
  static const String yourPet = "/yourPet";
}
