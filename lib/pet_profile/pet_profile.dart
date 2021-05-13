import 'package:Petinder/common/common.dart';
import 'package:Petinder/di/injection_container.dart';
import 'package:Petinder/models/pet.dart';
import 'package:Petinder/navigation/router.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_repository.dart';
import 'package:Petinder/pet_main/refresh_pet_main_bloc.dart';
import 'package:Petinder/pet_profile/pet_profile_bloc/pet_profile_bloc.dart';
import 'package:Petinder/pet_profile/pet_profile_bloc/pet_profile_event.dart';
import 'package:Petinder/pet_profile/pet_profile_bloc/pet_profile_state.dart';
import 'package:Petinder/registration_pet/utils/custom_checkbox2.dart';
import 'package:Petinder/registration_pet/utils/make_title.dart';
import 'package:Petinder/repository/loginStatus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

class PetProfilePage extends StatefulWidget {
  final Pet pet;
  final bool isSwipe;

  PetProfilePage({this.pet, this.isSwipe});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<PetProfilePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _heightFactorAnimation;
  double collapsedheightFactor = 0.55;
  double expandedheightFactor = 0.35;
  bool isAnimationCompleted = false;
  int currentPage = 0;
  double screenHeight = 0;
  ScrollController _controllerScroll;
  Pet pet;
  String myId = "";

  @override
  void initState() {
    super.initState();
    myId = Hive.box("isLogin").get("id");
    _controllerScroll = ScrollController();

    _controllerScroll.addListener(() {
      if (_controllerScroll.offset == 0 && _controller.value == 1) {
        _controller.reverse();
      }
    });

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _heightFactorAnimation =
        Tween<double>(begin: collapsedheightFactor, end: expandedheightFactor)
            .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, widget) {
            return getWidget();
          },
        ),
      ),
    );
  }

  Widget buildReturnButton(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: IconButton(
        color: Color(0xff4F5563),
        icon: SvgPicture.asset(
          'images/ios-back.svg',
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget getWidget() {
    pet = widget.pet;
    return BlocConsumer<PetProfileBloc, PetProfileState>(
        listener: (context, petProfileState) {
      if (petProfileState.canGoToChat) {
        context.read<PetProfileBloc>().add(ClearEvent());
        Navigator.of(context).pushNamed(RouteConstant.chatDetailRoute,
            arguments: {"friendID": pet.userID});
      } else if (petProfileState.deletionOk) {
        context.read<PetProfileBloc>().add(ClearEvent());
        Navigator.pushNamed(context, RouteConstant.dashboard);
        inject<RefreshPetMainBloc>().newRefresh(false);
      }
    }, builder: (context, petProfileState) {
      return Hero(
        tag: pet.name,
        child: Material(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              FractionallySizedBox(
                alignment: Alignment.topCenter,
                heightFactor: _heightFactorAnimation.value,
                child: PageView.builder(
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              "https://petsyy.herokuapp.com/image/${widget.pet.imageRefs[index]}",
                          fit: BoxFit.cover,
                        ),
                      ],
                    );
                  },
                  itemCount: pet.imageRefs.length,
                  controller: PageController(initialPage: 0),
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  onBottomPartTap();
                },
                onVerticalDragUpdate: _handleVerticalUpdate,
                onVerticalDragEnd: _handleVerticalEnd,
                child: FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 1.05 - _heightFactorAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: ListView(
                        physics: _controller.value < 1
                            ? NeverScrollableScrollPhysics()
                            : AlwaysScrollableScrollPhysics(),
                        controller: _controllerScroll,
                        children: [
                          updateIndicators(pet.imageRefs.length),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              pet.name,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: "GothamRounded",
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              pet.petBreed ?? " ",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "GothamRounded",
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  petDetail(decideGender(pet.gender), "gender"),
                                  SizedBox(height: 15),
                                  petDetail("${pet.age} lat", "calendar")
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  petDetail(
                                      decideOwnerTypeText(pet.typeOfPetOwner)
                                          .toLowerCase(),
                                      "pet-house"),
                                  SizedBox(height: 15),
                                  petDetail(
                                      specieChosen(pet.typeOfPet)
                                          .replaceFirst(", ", ""),
                                      "paw")
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                color: Color(0xff4FA8BC)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 23,
                                    height: 23,
                                    child: SvgPicture.asset(
                                      'images/petProfile/worldwide.svg',
                                      color: Color(0xffDDFAE1),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      "${pet.city}, ${pet.locationString} stąd",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontFamily: "GothamRounded",
                                          fontWeight: FontWeight.w300))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          makeTitle("Opis", fontSize: 23, left: 0.0),
                          Text(pet.desc,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "GothamRounded",
                                  fontWeight: FontWeight.w400)),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          makeTitle("Szczepienia", fontSize: 23, left: 0.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 100,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    vaccinateDetail(pet.vaccinateFirstCheck, 0),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    vaccinateDetail(
                                        pet.vaccinateSecondCheck, 1),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    vaccinateDetail(pet.vaccinateThirdCheck, 2)
                                  ],
                                ),
                              ),
                              Container(
                                  width: 15,
                                  height: 100,
                                  child: VerticalDivider(
                                    thickness: 2,
                                  )),
                              Container(
                                height: 100,
                                width: 130,
                                child: ListView(
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    children: [
                                      Text(pet.vaccinates,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "GothamRounded",
                                              fontWeight: FontWeight.w300)),
                                    ]),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          makeTitle("Charakter", fontSize: 23, left: 0.0),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: petCharacterAll(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          pet.userID != myId
                              ? widget.isSwipe
                                  ? lowerButton(
                                      "Wiadomość",
                                      Color(0xff4FA8BC).withOpacity(0.8),
                                      Icons.chat,
                                      petProfileState.isOwnOrDisliked)
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        decideFavouriteWidget(
                                            petProfileState.isFavourite,
                                            petProfileState.isFetched,
                                            petProfileState.isOwnOrDisliked),
                                        lowerButton(
                                            "Wiadomość",
                                            Color(0xff4FA8BC).withOpacity(0.8),
                                            Icons.chat,
                                            petProfileState.isOwnOrDisliked)
                                      ],
                                    )
                              : lowerButton("Usuń ogłoszenie", Colors.grey,
                                  Icons.delete, false),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Wyświetlenia: ${pet.numberOfViews}",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.account_circle),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  userInfo(petProfileState.userData)
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(top: 0, left: 0, child: buildReturnButton(context))
            ],
          ),
        ),
      );
    });
  }

  Widget userInfo(dynamic user) {
    if (user.isNotEmpty) {
      return Text(user,
          style: TextStyle(
              fontSize: 14,
              fontFamily: "GothamRounded",
              fontWeight: FontWeight.w600));
    } else {
      return SizedBox();
    }
  }

  Widget decideFavouriteWidget(
      bool isFavourite, bool isFetched, bool isOwnOrDisliked) {
    if (isFetched) {
      if (isFavourite) {
        return lowerButton(
            "W ulubionych", Color(0xffFF6666), Icons.favorite, isOwnOrDisliked);
      } else {
        return lowerButton("Dodaj do ulubionych", Color(0xffFF6666),
            Icons.favorite, isOwnOrDisliked);
      }
    } else {
      return SizedBox();
    }
  }

  onBottomPartTap() {
    setState(() {
      if (isAnimationCompleted) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
    isAnimationCompleted = !isAnimationCompleted;
  }

  Widget lowerButton(
      String text, Color color, IconData icon, bool isOwnOrDisliked) {
    return GestureDetector(
      onTap: () async {
        if (text == "Dodaj do ulubionych") {
          if (isOwnOrDisliked) {
            context
                .read<PetProfileBloc>()
                .add(ChangePetToFavourtieEvent(myID: myId, petID: pet.sId));
          } else {
            context
                .read<PetProfileBloc>()
                .add(AddPetToFavouriteEvent(myID: myId, petID: pet.sId));
          }
        } else if (text == "Wiadomość") {
          context
              .read<PetProfileBloc>()
              .add(CanGoToChatEvent(myID: myId, userID: pet.userID));
        } else if (text == "W ulubionych") {
          context
              .read<PetProfileBloc>()
              .add(RemovePetFromFavouriteEvent(myID: myId, petID: pet.sId));
        } else if (text == "Usuń ogłoszenie") {
          context.read<PetProfileBloc>().add(DeletePetEvent(petID: pet.sId));
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7)), color: color),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget updateIndicators(int length) {
    List<Widget> dots = List<Widget>.generate(
        length,
        (index) => Container(
              width: 7.0,
              height: 7.0,
              margin: EdgeInsets.symmetric(horizontal: 6.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index ? Colors.red : Color(0xFFA6AEBD),
              ),
            ));

    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [...dots]);
  }

  List<Widget> petCharacterAll() {
    int counter = -1;
    List<Widget> characterAll = List<Widget>.generate(2, (_) {
      List<Widget> characterColumn = [];
      for (var i = 0; i < 5; i++) {
        characterColumn.add(petCharacterDetail(counter));
        characterColumn.add(SizedBox(
          height: 10,
        ));
        counter++;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: characterColumn,
      );
    });
    return characterAll;
  }

  Widget petCharacterDetail(int index) {
    var character;
    if (index == -1) {
      character = ["Zdrowy", "images/dogHeart.svg"];
    } else {
      character = Common.imagesWithDesc[index];
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 23,
          height: 23,
          child: SvgPicture.asset(character[1]),
        ),
        SizedBox(
          width: 8,
        ),
        Text(character[0],
            style: TextStyle(
                color: Colors.black,
                fontSize: 12.5,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500)),
        SizedBox(
          width: 7,
        ),
        Row(
          children: [
            Text(
              getPetFeature(character[0], pet.character),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(
              width: 2,
            ),
            Text("/"),
            SizedBox(
              width: 2,
            ),
            Text("5.0", style: TextStyle(fontSize: 13)),
          ],
        )
      ],
    );
  }

  Widget vaccinateDetail(bool checked, int index) {
    return Row(
      children: [
        Container(
          child: CustomCheckbox2(
              size: 17,
              iconSize: 13,
              selectedColor: Colors.transparent,
              selectedIconColor: Colors.black,
              isSelected: checked),
        ),
        SizedBox(
          width: 8,
        ),
        Text(decideVaccinateText(index),
            style: TextStyle(
                fontSize: 14,
                fontFamily: "GothamRounded",
                fontWeight: FontWeight.w300))
      ],
    );
  }

  Widget petDetail(String text, String imgName) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          child: SvgPicture.asset('images/petProfile/$imgName.svg'),
        ),
        SizedBox(
          width: 10,
        ),
        Text(text,
            style: TextStyle(
                fontSize: 18,
                fontFamily: "GothamRounded",
                fontWeight: FontWeight.w400))
      ],
    );
  }

  _handleVerticalUpdate(DragUpdateDetails updateDetails) {
    double fractionDragged = updateDetails.primaryDelta / screenHeight;
    _controller.value = _controller.value - 5 * fractionDragged;
  }

  _handleVerticalEnd(DragEndDetails updateDetails) {
    if (_controller.value >= 0.5) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() async {
    super.dispose();
    pet.numberOfViews += 1;
    Future.delayed(Duration.zero, () async {
      updatePetViews(pet.sId).then((value) => print(value));
    });
    _controller.dispose();
  }
}
