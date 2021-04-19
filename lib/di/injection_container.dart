import 'package:Petinder/bottom_navigation/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:Petinder/bottom_navigation/bottom_navigation_bloc/bottom_navigation_repository.dart';
import 'package:Petinder/chat/messages_income_bloc.dart';
import 'package:Petinder/chat/search/search_bloc/search_bloc.dart';
import 'package:Petinder/chat/search/search_bloc/search_repository.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_repository.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_bloc.dart';
import 'package:Petinder/maps/maps_bloc/maps_bloc.dart';
import 'package:Petinder/maps/maps_bloc/maps_repository.dart';
import 'package:Petinder/navigation/router.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_bloc.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_repository.dart';
import 'package:Petinder/pet_main/pet_pagination_bloc/pet_pagination_bloc.dart';
import 'package:Petinder/pet_main/pet_pagination_bloc/pet_pagination_repository.dart';
import 'package:Petinder/pet_main/refresh_pet_main_bloc.dart';
import 'package:Petinder/pet_profile/pet_profile_bloc/pet_profile_bloc.dart';
import 'package:Petinder/pet_profile/pet_profile_bloc/pet_profile_repository.dart';
import 'package:Petinder/registration_pet/breed_choose/breedChooseBloc/breed_choose_bloc.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_bloc.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_repository.dart';
import 'package:Petinder/swipe/swipe_fetching_bloc/swipe_fetching_bloc.dart';
import 'package:Petinder/swipe/swipe_fetching_bloc/swipe_fetching_repository.dart';
import 'package:Petinder/welcome/auth/auth_bloc/auth_bloc.dart';
import 'package:Petinder/welcome/auth/auth_bloc/auth_repository.dart';
import 'package:Petinder/welcome/google_sign_in_repository.dart';

import 'package:get_it/get_it.dart';

final inject = GetIt.instance;

Future<void> init() async {
  inject.registerLazySingleton(() => SearchRepository());
  inject.registerFactory(() => SearchBloc(searchRepository: inject()));
  inject.registerLazySingleton(() => BreedChooseBloc());
  inject.registerLazySingleton(() => AppRouter());
  inject.registerLazySingleton(() => ChatRepository());
  inject.registerFactory(() => SendMessageBloc(chatRepository: inject()));
  inject.registerLazySingleton(() => SwipeRepository());
  inject.registerFactory(() => SwipeFetchingBloc(swipeRepository: inject()));
  inject.registerLazySingleton(() => RegistrationPetRepository());
  inject.registerLazySingleton(
      () => RegistrationPetBloc(registrationPetRepository: inject()));

  inject.registerLazySingleton(() => PetMainRepository());
  inject.registerLazySingleton(() => PetMainBloc(petMainRepository: inject()));
  inject.registerLazySingleton(() => PetPaginationRepository());
  inject.registerLazySingleton(
      () => PetPaginationBloc(paginationRepository: inject()));
  inject.registerLazySingleton(() => MapsRepository());
  inject.registerFactory(() => MapsBloc(mapsRepository: inject()));
  inject.registerLazySingleton(() => NotificationsBloc());
  inject.registerLazySingleton(() => RefreshPetMainBloc());
  inject.registerLazySingleton(() => GoogleSignInRepository());
  inject.registerLazySingleton(() => AuthRepository());
  inject.registerFactory(() => AuthBloc(authRepository: inject()));
  inject.registerLazySingleton(() => BottomNavigationRepository());
  inject.registerLazySingleton(
      () => BotttomNavigationBloc(bottomNavigationRepository: inject()));
  inject.registerLazySingleton(() => PetProfileRepository());
  inject.registerFactory(() => PetProfileBloc(petProfileRepository: inject()));
}
