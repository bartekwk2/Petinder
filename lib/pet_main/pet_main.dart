import 'package:Petinder/bottom_navigation/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:Petinder/bottom_navigation/bottom_navigation_bloc/bottom_navigation_event.dart';
import 'package:Petinder/bottom_navigation/bottom_navigation_bloc/bottom_navigation_state.dart';
import 'package:Petinder/common/common.dart';
import 'package:Petinder/common/pet_card.dart';
import 'package:Petinder/common/success.dart';
import 'package:Petinder/di/injection_container.dart';
import 'package:Petinder/navigation/router.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_bloc.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_state.dart';
import 'package:Petinder/pet_main/pet_pagination_bloc/pet_pagination_bloc.dart';
import 'package:Petinder/pet_main/pet_pagination_bloc/pet_pagination_event.dart';
import 'package:Petinder/pet_main/pet_pagination_bloc/pet_pagination_repository.dart';
import 'package:Petinder/pet_main/pet_pagination_bloc/pet_pagination_state.dart';
import 'package:Petinder/repository/location_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PetMainScreen extends StatefulWidget {
  @override
  _PetMainScreenState createState() => _PetMainScreenState();
}

class _PetMainScreenState extends State<PetMainScreen> {
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: inject<PetPaginationRepository>().scrollOffset,
  );
  double offset = 0.0;
  bool firstTime = true;

  jumpUp() {
    _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF2F2F0),
        body: BlocConsumer<PetPaginationBloc, PetPaginationState>(
            listener: (context, petPaginationState) {
          if (petPaginationState.noMorePets) {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Nie ma więcej zwierzaków')));
          } else {
            if (petPaginationState.isLoading) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text(petPaginationState.message)));
            } else if (petPaginationState.isError) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text(petPaginationState.error)));
            } else if (petPaginationState.showSheet) {
              if (firstTime) {
                if (petPaginationState.isAdded) {
                  showSuccess(context, "Pomylnie dodanao ", 'Dodawanie udane!',
                      duration: 2);
                } else {
                  showSuccess(context, "Pomylnie usunięto ", 'Usunięcie udane!',
                      duration: 2);
                }
                firstTime = false;
              }
            }
          }
          return;
        }, builder: (context, petPaginationState) {
          return CustomScrollView(
            controller: _scrollController
              ..addListener(() {
                offset = _scrollController.offset;
                if (_scrollController.offset ==
                        _scrollController.position.maxScrollExtent &&
                    !petPaginationState.isLoading) {
                  context.read<PetPaginationBloc>().add(LoadNextPageEvent(
                      isFromScroll: true, isFirstTime: false));
                }
              }),
            slivers: [
              SliverToBoxAdapter(
                child: userInfo(context),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 15,
                ),
              ),
              SliverToBoxAdapter(child: showMap()),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 15,
                ),
              ),
              SliverToBoxAdapter(child: addPet(context)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 15,
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                  minHeight: 65.0,
                  maxHeight: 65.0,
                  child: Container(
                    decoration: BoxDecoration(color: Color(0xffDFDFDE)),
                    child: filterResults(context),
                  ),
                ),
              ),
              decideStateWidget(petPaginationState, context),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 15,
                ),
              ),
              petsFetched(petPaginationState)
            ],
          );
        }),
      ),
    );
  }

  Widget decideStateWidget(
      PetPaginationState petPaginationState, BuildContext context) {
    if (!petPaginationState.isLoading && !petPaginationState.isError) {
      Scaffold.of(context).hideCurrentSnackBar();
      return SliverToBoxAdapter(child: SizedBox());
    } else if (petPaginationState.isError && petPaginationState.pets.isEmpty) {
      return SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                context.read<PetPaginationBloc>().add(LoadNextPageEvent(
                    isFiltered: false,
                    isFromScroll: false,
                    isFirstTime: false));
              },
              icon: Icon(Icons.refresh),
            ),
            const SizedBox(height: 15),
            Text(petPaginationState.error, textAlign: TextAlign.center),
          ],
        ),
      );
    } else {
      return SliverToBoxAdapter(child: SizedBox());
    }
  }

  Widget petsFetched(PetPaginationState petPaginationState) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (
          BuildContext context,
          int index,
        ) {
          return GestureDetector(
            onTap: () {
              var pet = petPaginationState.pets[index];
              var arguments = {"pet": pet, 'swipe': false};
              Navigator.of(context)
                  .pushNamed(RouteConstant.profileDetail, arguments: arguments);
            },
            child: Hero(
              tag: petPaginationState.pets[index].name,
              child: PetCard(
                pet: petPaginationState.pets[index],
              ),
            ),
          );
        },
        childCount: petPaginationState.pets.length,
      ),
    );
  }

  Widget userInfo(BuildContext context) {
    return BlocBuilder<BotttomNavigationBloc, BottomNavigationState>(
        builder: (context, viewState) {
      String textName = "";
      var photosRef = [];
      if (viewState.user != null) {
        if (viewState.user.photosRef == null) {
          photosRef = [];
        } else {
          photosRef = viewState.user.photosRef;
        }
        String text = viewState.user.name;
        if (text.contains("@")) {
          text = text.split("@").first;
        }
        textName = text;
      }
      String textInserted = textName += " !";
      return Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 1.0),
              blurRadius: 1.0,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            photosRef.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Container(
                      width: 70,
                      height: 70,
                      child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.2),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset('images/main/dog.svg'),
                          )),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Container(
                      width: 70,
                      height: 70,
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            "https://petsyy.herokuapp.com/image/${photosRef.first}"),
                      ),
                    ),
                  ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                viewState.city.isNotEmpty
                    ? Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color(0xFF306060),
                            size: 23.0,
                          ),
                          Text(
                            ' ${viewState.city}, ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            viewState.country,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Witaj ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      textInserted,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: textInserted.length > 17 ? 14 : 19,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                context.read<BotttomNavigationBloc>().add(LogoutEvent());
                LocationRepository()
                  ..determinePosition().then((value) => print(value));
                Navigator.of(context)
                    .pushReplacementNamed(RouteConstant.homeRoute);
              },
              child: Icon(
                Icons.logout,
                size: 20,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      );
    });
  }

  Widget addPet(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteConstant.yourPet);
      },
      child: Container(
        height: 65,
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 38,
                height: 38,
                child: SvgPicture.asset('images/paws.svg')),
            SizedBox(
              width: 30,
            ),
            RichText(
              text: TextSpan(
                text: 'Zobacz',
                style: TextStyle(
                    color: Colors.black,
                    height: 1,
                    fontSize: 17,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w300),
                children: <TextSpan>[
                  TextSpan(
                      text: ' ulubione',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  TextSpan(
                      text: ' ogłoszenia',
                      style: TextStyle(fontWeight: FontWeight.w300)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showMap() {
    return BlocBuilder<BotttomNavigationBloc, BottomNavigationState>(
        builder: (context, viewState) {
      return GestureDetector(
        onTap: () {
          context
              .read<BotttomNavigationBloc>()
              .add(ChooseViewEvent(viewIndex: 0));
        },
        child: Container(
          height: 65,
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 38,
                  height: 38,
                  child: SvgPicture.asset('images/worldwide.svg')),
              SizedBox(
                width: 35,
              ),
              RichText(
                text: TextSpan(
                  text: 'Pokaż ogłoszenia',
                  style: TextStyle(
                      color: Colors.black,
                      height: 1,
                      fontSize: 17,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w300),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' na mapie',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget filterResults(BuildContext context) {
    return BlocConsumer<PetMainBloc, PetMainState>(listener: (_, petMainState) {
      if (petMainState.filterExit) {
        if (!petMainState.filtersSame) {
          jumpUp();
          bool isFiltered = petMainState.queryBody == "{}";
          context.read<PetPaginationBloc>().add(LoadNextPageEvent(
              fetchingQuery: petMainState.queryBody,
              isFiltered: !isFiltered,
              isFromScroll: false,
              isFirstTime: false));
        }
      }
    }, builder: (context, petMainState) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          children: <Widget>[
            petMainState.filtersChosen.isEmpty
                ? Text(
                    "Nie wybrano filtrów",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400),
                  )
                : Material(
                    color: Color(0xffB4B4B4).withOpacity(0.01),
                    child: Container(
                      child: Text(
                        "Wybrano filtry",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(RouteConstant.petMainFilter);
              },
              child: Row(
                children: [
                  Text(
                    "Filtruj",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Color(0xff444446),
                        borderRadius: BorderRadius.circular(12)),
                    child: Icon(
                      Icons.sort,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    if (offset != 0.0) {
      inject<PetPaginationRepository>().scrollOffset = offset;
    }
    super.dispose();
  }
}
