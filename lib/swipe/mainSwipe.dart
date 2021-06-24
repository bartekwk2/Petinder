import 'package:Petinder/models/pet.dart';
import 'package:Petinder/navigation/router.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_repository.dart';
import 'package:Petinder/swipe/swipe_fetching_bloc/swipe_fetching_bloc.dart';
import 'package:Petinder/swipe/swipe_fetching_bloc/swipe_fetching_event.dart';
import 'package:Petinder/swipe/swipe_fetching_bloc/swipe_fetching_repository.dart';
import 'package:Petinder/swipe/swipe_fetching_bloc/swipe_fetching_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SwipeScreen extends StatefulWidget {
  @override
  _ExampleHomePageState createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<SwipeScreen>
    with TickerProviderStateMixin {
  CardController controller;
  SwipeRepository repository;
  int countPages = 1;
  List<dynamic> pets;
  String id = Hive.box("IsLogin").get("id");
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    _interstitialAd = InterstitialAd(
      adUnitId: "ca-app-pub-2430907631837756/4586171487",
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isInterstitialAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
          ad.dispose();
        },
        onAdClosed: (_) {},
      ),
    );
    _interstitialAd.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F0),
      body: BlocConsumer<SwipeFetchingBloc, SwipeFetchingState>(
          listener: (context, swipeState) {
        if (swipeState is FetchPetsState) {
          pets = swipeState.pets;
          if (_isInterstitialAdReady) {
            _interstitialAd.show();
          }
        } else if (swipeState is SwipingDisableState) {
          fetchMorePets(context);
        }
      }, builder: (context, swipeState) {
        return _renderSwipeScreen(swipeState);
      }),
    );
  }

  Widget _renderSwipeScreen(SwipeFetchingState swipeState) {
    return Stack(children: [
      swipeState is NoMorePetsState ? noMorePets() : petCards(swipeState),
      Positioned(
          left: 0,
          right: 0,
          bottom: 23,
          child: getBottomSheet(controller, swipeState)),
      buildLikeBadge(swipeState),
    ]);
  }

  Widget petCards(SwipeFetchingState swipeState) {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: TinderSwapCard(
          orientation: AmassOrientation.TOP,
          totalNum: _decideCardsCount(swipeState),
          stackNum: 4,
          swipeEdge: 5.0,
          maxWidth: MediaQuery.of(context).size.width * 0.90,
          maxHeight: MediaQuery.of(context).size.width * 1.2,
          minWidth: MediaQuery.of(context).size.width * 0.75,
          minHeight: MediaQuery.of(context).size.width * 1.19,
          //
          cardBuilder: (context, index) {
            Pet pet = pets[index];
            var breed = pet.petBreed;
            if (breed == null) {
              breed = "";
            }
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteConstant.profileDetail,
                    arguments: {'pet': pet, 'swipe': true});
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Hero(
                          tag: index,
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        "https://petsyy.herokuapp.com/image/${pet.imageRefs.first}"),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.47,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(-1.0, 1.0),
                                    blurRadius: 1.0,
                                  ),
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1.0, 0.0),
                                    blurRadius: 1.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 20, 0, 0),
                                  child: Text(
                                    "${pet.name}, ${pet.age}",
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontFamily: "GothamRounded",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 17, 0, 0),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'images/petProfile/paw.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${specieChosen(pet.typeOfPet).replaceFirst(", ", "")} $breed",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "GothamRounded"),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'images/petProfile/pet-house.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${originChosen(pet.typeOfPetOwner).replaceFirst(", ", "")}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "GothamRounded"),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'images/drei.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${pet.city}, ${pet.locationString}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "GothamRounded"),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Container(
                          width: 90,
                          height: 90,
                          child: SvgPicture.asset(
                            'images/petProfile/paws.svg',
                            color: Colors.black.withAlpha(15),
                          ),
                        ),
                      )
                    ],
                  )),
            );
          },
          //
          cardController: controller = CardController(),
          swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
            if (swipeState is! NoMorePetsState) {
              if (align.x < 0) {
                context.read<SwipeFetchingBloc>().add(SwipeLeftEvent());
              } else if (align.x > 0) {
                context.read<SwipeFetchingBloc>().add(SwipeRightEvent());
              }
            }
          },
          swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
            context.read<SwipeFetchingBloc>().add(SwipingEnabledEvent());

            if (orientation == CardSwipeOrientation.LEFT) {
              Pet pet = pets[index];
              context.read<SwipeFetchingBloc>().add(
                  AddToFavoriteOrRejectedEvent(
                      sId: id, petType: "Disliked", petRef: pet.sId));
            } else if (orientation == CardSwipeOrientation.RIGHT) {
              Pet pet = pets[index];
              context.read<SwipeFetchingBloc>().add(
                  AddToFavoriteOrRejectedEvent(
                      sId: id, petType: "Liked", petRef: pet.sId));
            }

            if (index + 1 == pets.length) {
              context.read<SwipeFetchingBloc>().add(SwipingDisableEvent());
            }
          },
        ),
      ),
    );
  }

  Widget noMorePets() {
    double size = MediaQuery.of(context).size.width / 1.1;

    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Brak nowych ogłoszeń",
            style: TextStyle(fontSize: 28),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Wróć za jakiś czas",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
          ),
          Container(
            width: size,
            height: size,
            child: Lottie.asset('images/anim2.json'),
          )
        ],
      ),
    );
  }

  Widget getBottomSheet(
    CardController controller,
    SwipeFetchingState swipeState,
  ) {
    double width = MediaQuery.of(context).size.width / 8.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(item_icons.length, (index) {
          return InkWell(
            onTap: () {
              if (swipeState is! NoMorePetsState) {
                if (index == 0) {
                  context.read<SwipeFetchingBloc>().add(SwipeLeftEvent());
                  controller.triggerLeft();
                } else {
                  context.read<SwipeFetchingBloc>().add(SwipeRightEvent());
                  controller.triggerRight();
                }
              }
            },
            child: Container(
              width: item_icons[index]['size'],
              height: item_icons[index]['size'],
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ]),
              child: Center(
                child: SvgPicture.asset(
                  item_icons[index]['icon'],
                  width: item_icons[index]['icon_size'],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  int _decideCardsCount(SwipeFetchingState state) {
    if (state is FetchPetsState) {
      print(state.pets.length);
      return state.pets.length;
    } else if (state is NoMorePetsState || state is SwipingDisableState) {
      return 0;
    } else {
      return pets?.length ?? 0;
    }
  }

  Widget buildLikeBadge(SwipeFetchingState state) {
    if (state is SwipeLeftState || state is SwipeRightState) {
      bool isSwipingLeft = state is SwipeLeftState;
      double height = MediaQuery.of(context).size.height / 8.5;
      final color = isSwipingLeft ? Colors.pink : Colors.green;
      final angle = isSwipingLeft ? -0.3 : 0.3;
      return Positioned(
        top: height,
        right: isSwipingLeft ? null : 20,
        left: isSwipingLeft ? 20 : null,
        child: Transform.rotate(
          angle: angle,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 2),
            ),
            child: Text(
              isSwipingLeft ? 'NIE LUBIĘ' : 'LUBIĘ',
              style: TextStyle(
                color: color,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void fetchMorePets(BuildContext context) {
    var myLocationBox = Hive.box("Location");
    dynamic position = myLocationBox.get("positionMap");
    context.read<SwipeFetchingBloc>().add(FetchPetsEvent(
        longitude: position["long"],
        latitude: position["lat"],
        distance: 800,
        limit: 8,
        page: countPages,
        id: id));
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }
}

const List item_icons = [
  {"icon": "images/close_icon.svg", "size": 58.0, "icon_size": 25.0},
  {"icon": "images/like_icon.svg", "size": 57.0, "icon_size": 27.0},
];
