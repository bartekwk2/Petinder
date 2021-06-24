import 'dart:math';
import 'package:Petinder/models/character.dart';
import 'package:Petinder/navigation/router.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_bloc.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_event.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_state.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_bloc.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_event.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_state.dart';
import 'package:Petinder/registration_pet/utils/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

/*
String getYourID() {
  String authID = inject<AuthRepository>().id;
  String googleAuthID = inject<GoogleSignInRepository>().id;
  String id;
  if (authID.isEmpty) {
    id = googleAuthID;
  } else {
    id = authID;
  }
  return id;
}

void clearYourID() {
  inject<AuthRepository>().id = "";
  inject<GoogleSignInRepository>().id = "";
}
*/

Widget petCategory(
    Category category, int index, BuildContext context, bool isAdding,
    {RegistrationPetState registrationState, PetMainState petMainState}) {
  return GestureDetector(
    onTap: () {
      _decidePetChoose(index, context, isAdding,
          registrationState: registrationState, petMainState: petMainState);
      isAdding
          ? context
              .read<RegistrationPetBloc>()
              .add(ChooseSpecieEvent(specieIndex: index))
          : context
              .read<PetMainBloc>()
              .add(ChooseSpecieEventFilter(specieIndex: index));

      if (!isAdding) {
        if (petMainState.specieChosen == index) {
          context
              .read<PetMainBloc>()
              .add(ChooseSpecieEventFilter(specieIndex: -1));
        }
      }
    },
    child: Container(
      width: 100.0,
      child: Column(
        children: [
          Card(
            color: isAdding
                ? registrationState.specieChosen == index
                    ? Colors.green
                    : null
                : petMainState.specieChosen == index
                    ? Colors.green
                    : null,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              width: 80.0,
              height: 80.0,
              child: Center(
                child: SvgPicture.asset(
                  category.icon,
                  height: 45.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(category.name,
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF746F67),
              ))
        ],
      ),
    ),
  );
}

void _decidePetChoose(int index, BuildContext context, bool isAdding,
    {RegistrationPetState registrationState, PetMainState petMainState}) {
  if (!isAdding) {
    if (index == petMainState.specieChosen) {
      return;
    }
  }
  switch (index) {
    case 0:
      Navigator.of(context).pushNamed(RouteConstant.petBreedChooseRoute,
          arguments: {'searchType': 'dog'});
      break;
    case 1:
      Navigator.of(context).pushNamed(RouteConstant.petBreedChooseRoute,
          arguments: {'searchType': 'cat'});
      break;
    default:
      break;
  }
}

Widget ageSlider(BuildContext context, bool isAdding,
    {RegistrationPetState registrationState, PetMainState petMainState}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 21),
    child: Container(
      height: 90,
      child: Stack(children: [
        Container(
            height: 30,
            child: isAdding
                ? SfSlider(
                    min: 0.0,
                    max: 25.0,
                    value: registrationState.ageChosen,
                    interval: 5,
                    showTicks: true,
                    showLabels: true,
                    enableTooltip: true,
                    minorTicksPerInterval: 1,
                    labelFormatterCallback: (actualValue, formattedText) {
                      if (actualValue == 0) {
                        return '1-';
                      } else if (actualValue == 25) {
                        return '25+';
                      } else {
                        return formattedText;
                      }
                    },
                    tooltipTextFormatterCallback: (actualValue, formattedText) {
                      String value = (actualValue.round()).toString();

                      if (value == '0') {
                        return '1-';
                      } else if (value == '25') {
                        return '25+';
                      } else {
                        return value;
                      }
                    },
                    onChanged: (dynamic value) {
                      context
                          .read<RegistrationPetBloc>()
                          .add(ChooseAgeEvent(age: value));
                    },
                  )
                : SfRangeSlider(
                    min: 0.0,
                    max: 25.0,
                    values: SfRangeValues(petMainState.ageChosenLower,
                        petMainState.ageChosenUpper),
                    interval: 5,
                    showTicks: true,
                    showLabels: true,
                    enableTooltip: true,
                    minorTicksPerInterval: 1,
                    labelFormatterCallback: (actualValue, formattedText) {
                      if (actualValue == 0) {
                        return '1-';
                      } else if (actualValue == 25) {
                        return '25+';
                      } else {
                        return formattedText;
                      }
                    },
                    tooltipTextFormatterCallback: (actualValue, formattedText) {
                      String value = (actualValue.round()).toString();
                      if (value == '0') {
                        return '1-';
                      } else if (value == '25') {
                        return '25+';
                      } else {
                        return value;
                      }
                    },
                    onChanged: (SfRangeValues values) {
                      context.read<PetMainBloc>().add(ChooseAgeEventFilter(
                          ageLower: values.start, ageHigher: values.end));
                    },
                  )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('images/s11.svg',
                      semanticsLabel: 'first'),
                ),
                Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('images/s2.svg',
                      semanticsLabel: 'first'),
                ),
                Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('images/s3.svg',
                      semanticsLabel: 'first'),
                ),
                Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('images/s4.svg',
                      semanticsLabel: 'first'),
                ),
              ],
            ),
          ),
        )
      ]),
    ),
  );
}

Widget genderChooser(BuildContext context, bool isAdding,
    {RegistrationPetState registrationState, PetMainState petMainState}) {
  List<Widget> gender = List<Widget>.generate(
      2,
      (index) => GestureDetector(
            onTap: () {
              isAdding
                  ? context
                      .read<RegistrationPetBloc>()
                      .add(ChooseGenderEvent(genderEvent: index))
                  : context
                      .read<PetMainBloc>()
                      .add(ChooseGenderEventFilter(genderEvent: index));

              if (!isAdding) {
                if (petMainState.genderChosen == index) {
                  context
                      .read<PetMainBloc>()
                      .add(ChooseGenderEventFilter(genderEvent: -1));
                }
              }
            },
            child: Column(
              children: [
                Container(
                  width: 65.0,
                  height: 65.0,
                  decoration: BoxDecoration(
                      color: isAdding
                          ? index == registrationState.genderChosen
                              ? Colors.green
                              : Colors.white
                          : index == petMainState.genderChosen
                              ? Colors.green
                              : Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 4.0,
                        ),
                      ]),
                  child: index == 0
                      ? Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: SvgPicture.asset(
                            'images/man.svg',
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: SvgPicture.asset('images/woman.svg'),
                        ),
                ),
                          SizedBox(
            height: 10,
          ),
          Text(index==0?"Samiec":"Samica",
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF746F67),
              ))
              ],
            ),
          ));

  gender.insert(
      1,
      SizedBox(
        width: 30,
      ));

  return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [...gender]);
}

Widget ownerTypeChooser(BuildContext context, bool isAdding,
    {RegistrationPetState registrationState, PetMainState petMainState}) {
  List<Widget> type = List<Widget>.generate(
      3,
      (index) => GestureDetector(
            onTap: () {
              isAdding
                  ? context
                      .read<RegistrationPetBloc>()
                      .add(ChooseOriginEvent(originEvent: index))
                  : context
                      .read<PetMainBloc>()
                      .add(ChooseOriginEventFilter(originEvent: index));

              if (!isAdding) {
                if (petMainState.originChosen == index) {
                  context
                      .read<PetMainBloc>()
                      .add(ChooseOriginEventFilter(originEvent: -1));
                }
              }
            },
            child: Column(
              children: [
                Container(
                    width: 75.0,
                    height: 75.0,
                    decoration: BoxDecoration(
                        color: isAdding
                            ? index == registrationState.originChosen
                                ? Colors.green
                                : Colors.white
                            : index == petMainState.originChosen
                                ? Colors.green
                                : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 4.0,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: SvgPicture.asset(
                        'images/r$index.svg',
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Text(decideOwnerTypeText(index),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF746F67),
                    ))
              ],
            ),
          ));

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [...type]),
  );
}

//------------------------------------






String getPetFeature(String polish, Character character) {
  String word = "";
  switch (polish) {
    case "Aktywny":
      word = character.active.numberDecimal.toString();
      break;
    case "Głośny":
      word = character.loud.numberDecimal.toString();
      break;
    case "Żarłoczny":
      word = character.likesEating.numberDecimal.toString();
      break;
    case "Rodzinny":
      word = character.familyFriendly.numberDecimal.toString();
      break;
    case "Mądry":
      word = character.smart.numberDecimal.toString();
      break;
    case "Tresowany":
      word = character.wellBehaved.numberDecimal.toString();
      break;
    case "Strachliwy":
      word = character.fearfull.numberDecimal.toString();
      break;
    case "Łagodny":
      word = character.peaceful.numberDecimal.toString();
      break;
    case "Samodzielny":
      word = character.indipendent.numberDecimal.toString();
      break;
    case "Zdrowy":
      word = character.health.numberDecimal.toString();
      break;
  }
  return word;
}

String decideVaccinateText(int index) {
  if (index == 0) {
    return "książeczka szczepień";
  } else if (index == 1) {
    return "wcześniej szczepiony";
  } else {
    return "szczepienia aktualne";
  }
}

String decideGender(int index) {
  if (index == 0) {
    return "samiec";
  } else {
    return "samica";
  }
}

String decideOwnerTypeText(int index) {
  if (index == 0) {
    return "Hodowla";
  } else if (index == 1) {
    return "Domowe";
  } else {
    return "Schronisko";
  }
}

class Common {
  static const images = {
    'Aktywny': "images/jeden.svg",
    'Głośny': "images/dwa.svg",
    'Żarłoczny': "images/three.svg",
    'Rodzinny': "images/four.svg",
    'Mądry': "images/five.svg",
    'Tresowany': "images/six.svg",
    'Strachliwy': "images/seven.svg",
    'Łagodny': "images/eight.svg",
    'Samodzielny': "images/nine.svg",
  };

  static const imagesWithDesc = {
    0: ['Aktywny', "images/jeden.svg"],
    1: ['Głośny', "images/dwa.svg"],
    2: ['Żarłoczny', "images/three.svg"],
    3: ['Rodzinny', "images/four.svg"],
    4: ['Mądry', "images/five.svg"],
    5: ['Tresowany', "images/six.svg"],
    6: ['Strachliwy', "images/seven.svg"],
    7: ['Łagodny', "images/eight.svg"],
    8: ['Samodzielny', "images/nine.svg"],
  };

  static List welcomeScreens = [
    {"image": "images/unoR.jpg", "color": 0xfffcdb8b, "indicolor": 0xff905300},
    {"image": "images/dosR.jpg", "color": 0xfffc6fb5, "indicolor": 0xff8C0944},
    {"image": "images/tresR.jpg", "color": 0xffF6CEC7, "indicolor": 0xff896059},
    {
      "image": "images/quatroR.jpg",
      "color": 0xffADD9FF,
      "indicolor": 0xff14416A
    },
  ];

  static String addComaIfNotEmpty(String word) {
    if (word.isNotEmpty) {
      return ", ";
    } else {
      return "";
    }
  }

  static String getCurrentDate() {
    DateTime now = DateTime.now();
    String month = checkLength(now.month.toString().padLeft(2, '0'));
    String day = checkLength(now.day.toString().padLeft(2, '0'));
    String hour = checkLength(now.hour.toString());
    String minute = checkLength(now.minute.toString());
    String convertedDateTime =
        "${now.year.toString()}-$month-$day $hour:$minute";
    return convertedDateTime;
  }

  static String checkLength(String elOfDate) {
    if (elOfDate.length == 1) {
      return "0$elOfDate";
    } else {
      return elOfDate;
    }
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
