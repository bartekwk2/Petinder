import 'package:Petinder/common/common.dart';
import 'package:Petinder/navigation/router.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_bloc.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_state.dart';
import 'package:Petinder/registration_pet/secondScreen/popup_card.dart';
import 'package:Petinder/registration_pet/utils/customCheckbox.dart';
import 'package:Petinder/registration_pet/utils/custom_rect_tween.dart';
import 'package:Petinder/registration_pet/utils/hero_dialog_route.dart';
import 'package:Petinder/registration_pet/utils/make_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationPetBloc, RegistrationPetState>(
        builder: (context, registrationState) {
      return Scaffold(
        body: ListView(
            physics: AlwaysScrollableScrollPhysics(),
          children: [
            makeTitle("Płeć"),
            genderChooser(context,true,registrationState: registrationState),
            SizedBox(
              height: 30,
            ),
            makeTitle("Wiek"),
            ageSlider(context,true,registrationState: registrationState),
            SizedBox(
              height: 40,
            ),
            makeTitle("Pochodzenie"),
            ownerTypeChooser(context,true,registrationState: registrationState),
            SizedBox(
              height: 40,
            ),
            vaccinateCard(registrationState),
            SizedBox(
              height: 80,
            ),
          ],
        ),
      );
    });
  }



  Widget vaccinateCard(RegistrationPetState registrationState) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteConstant.vaccinateDetail);
      },
      child: Hero(
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin, end: end);
        },
        tag: 'tag',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Material(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 170,
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'images/vaccine.svg',
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              "Szczepienia",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 1,
                          color: Colors.black.withOpacity(0.9),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ...vaccinateInfo(
                            "Książeczka szczepień", 0, registrationState),
                        ...vaccinateInfo(
                            "Wcześniej szczepiony", 1, registrationState),
                        ...vaccinateInfo(
                            "Szczepienia aktualne ", 2, registrationState),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> vaccinateInfo(
      String text, int index, RegistrationPetState registrationState) {
    return [
      const SizedBox(
        height: 8,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 15),
          ),
          CustomCheckbox(
            state: registrationState,
            index: index,
            size: 20,
            iconSize: 15,
            selectedColor: Colors.blue,
            selectedIconColor: Colors.white,
          ),
        ],
      ),
    ];
  }

  void onCheckBoxClicked() {
    Navigator.of(context).push(
      HeroDialogRoute(
        builder: (context) => Center(
          child: TodoPopupCard(),
        ),
      ),
    );
  }
}
