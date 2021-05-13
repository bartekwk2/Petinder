import 'package:Petinder/bottom_navigation/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:Petinder/bottom_navigation/bottom_navigation_bloc/bottom_navigation_state.dart';
import 'package:Petinder/common/common.dart';
import 'package:Petinder/di/injection_container.dart';
import 'package:Petinder/pet_main/refresh_pet_main_bloc.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_bloc.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_event.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_state.dart';
import 'package:Petinder/registration_pet/utils/custom_dialog_box.dart';
import 'package:Petinder/registration_pet/utils/make_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BotttomNavigationBloc, BottomNavigationState>(
        builder: (context, bottomNavigationState) {
      return BlocConsumer<RegistrationPetBloc, RegistrationPetState>(
          listener: (context, registrationState) {
        if (registrationState.canGo) {
          context.read<RegistrationPetBloc>().add(RefreshCanGoEvent());
          inject<RefreshPetMainBloc>().newRefresh(true);
        }
      }, builder: (context, registrationState) {
        return ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            makeTitle("Zdrowie"),
            healthChooser(registrationState),
            SizedBox(
              height: 20,
            ),
            makeTitle("Charakter"),
            characterChooser(registrationState),
            SizedBox(
              height: 10,
            ),
            submitButton(registrationState),
            SizedBox(
              height: 30,
            ),
          ],
        );
      });
    });
  }

  Widget submitButton(RegistrationPetState registrationState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            String decideIfDone = decideWhatIsEmpty(registrationState);
            if (decideIfDone.isEmpty) {
              context.read<RegistrationPetBloc>().add(SubmitAddingPetEvent());
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String emptySteps = decideWhatIsEmpty(registrationState);
                    return CustomDialogBox(
                      title: "Błąd dodawania",
                      descriptions: "Uzupełnij: $emptySteps",
                      text: "Ok",
                    );
                  });
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(5, 5),
                  blurRadius: 10,
                )
              ],
            ),
            child: Center(
              child: Text(
                'Gotowe',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  String decideWhatIsEmpty(RegistrationPetState registrationState) {
    String emptySteps = "";
    if (registrationState.adress.isEmpty) {
      emptySteps += Common.addComaIfNotEmpty(emptySteps);
      emptySteps += "lokalizację";
    }
    if (registrationState.images.isEmpty) {
      emptySteps += Common.addComaIfNotEmpty(emptySteps);
      emptySteps += "zdjęcia";
    }
    if (registrationState.petName.isEmpty) {
      emptySteps += Common.addComaIfNotEmpty(emptySteps);
      emptySteps += "imię";
    }
    if (registrationState.specieChosen == -1) {
      emptySteps += Common.addComaIfNotEmpty(emptySteps);
      emptySteps += "gatunek";
    }
    if (registrationState.petDesc.isEmpty) {
      emptySteps += Common.addComaIfNotEmpty(emptySteps);
      emptySteps += "opis";
    }
    if (registrationState.genderChosen == -1) {
      emptySteps += Common.addComaIfNotEmpty(emptySteps);
      emptySteps += "płeć";
    }
    if (registrationState.originChosen == -1) {
      emptySteps += Common.addComaIfNotEmpty(emptySteps);
      emptySteps += "pochodzenie";
    }
    return emptySteps;
  }

  Widget characterChooser(RegistrationPetState registrationState) {
    List<Widget> character = List<Widget>.generate(
        Common.imagesWithDesc.length,
        (index) => _ratingItem(
            Common.imagesWithDesc[index], index, registrationState));

    character.insert(
      4,
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: makeTitle("Zachowanie"),
          ),
        ],
      ),
    );

    return Column(mainAxisSize: MainAxisSize.min, children: [...character]);
  }

  Widget healthChooser(RegistrationPetState registrationState) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        height: 65,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(0.0, 1.0),
                blurRadius: 4.0,
              ),
            ]),
        child: Center(
          child: RatingBar.builder(
            initialRating: registrationState.health,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 38,
            itemPadding: EdgeInsets.symmetric(horizontal: 6.0),
            itemBuilder: (context, _) => SvgPicture.asset(
              'images/dogHeart.svg',
              color: Color(0xff800020),
            ),
            onRatingUpdate: (rating) {
              context
                  .read<RegistrationPetBloc>()
                  .add(ChooseHealthLevelEvent(level: rating));
            },
          ),
        ),
      ),
    );
  }

  Widget _ratingItem(List<String> character, int index,
      RegistrationPetState registrationState) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 00, 35, 20),
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(0.0, 1.0),
                blurRadius: 4.0,
              ),
            ]),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 4.0,
                    ),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(character.first),
                  SizedBox(
                    height: 10,
                  ),
                  SvgPicture.asset(
                    character.last,
                    width: 30,
                    height: 30,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 3,
            ),
            Expanded(
              child: RatingBar.builder(
                initialRating: decideCharacterState(registrationState, index),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => SvgPicture.asset(
                  'images/award.svg',
                  color: Colors.blue,
                ),
                onRatingUpdate: (rating) {
                  decideCharacterEvent(index, rating);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void decideCharacterEvent(int index, double rating) {
    switch (index) {
      case 0:
        context
            .read<RegistrationPetBloc>()
            .add(ChooseActiveLevelEvent(level: rating));
        break;
      case 1:
        context
            .read<RegistrationPetBloc>()
            .add(ChooseLoudLevelEvent(level: rating));
        break;
      case 2:
        context
            .read<RegistrationPetBloc>()
            .add(ChooseLikesEatingLevelEvent(level: rating));
        break;
      case 3:
        context
            .read<RegistrationPetBloc>()
            .add(ChooseFamilyFriendlyLevelEvent(level: rating));
        break;
      case 4:
        context
            .read<RegistrationPetBloc>()
            .add(ChooseSmartLevelEvent(level: rating));
        break;
      case 5:
        context
            .read<RegistrationPetBloc>()
            .add(ChooseWellBehavedLevelEvent(level: rating));
        break;
      case 6:
        context
            .read<RegistrationPetBloc>()
            .add(ChooseFearfullLevelEvent(level: rating));
        break;
      case 7:
        context
            .read<RegistrationPetBloc>()
            .add(ChoosePeacefulLevelEvent(level: rating));
        break;
      case 8:
        context
            .read<RegistrationPetBloc>()
            .add(ChooseIndipendentLevelEvent(level: rating));
        break;
    }
  }

  double decideCharacterState(
      RegistrationPetState registrationPetState, int index) {
    switch (index) {
      case 0:
        return registrationPetState.active;
      case 1:
        return registrationPetState.loud;
      case 2:
        return registrationPetState.likesEating;
      case 3:
        return registrationPetState.familyFriendly;
      case 4:
        return registrationPetState.smart;
      case 5:
        return registrationPetState.wellBehaved;
      case 6:
        return registrationPetState.fearfull;
      case 7:
        return registrationPetState.peaceful;
      case 8:
        return registrationPetState.indipendent;
      default:
        return 3.0;
    }
  }
}
