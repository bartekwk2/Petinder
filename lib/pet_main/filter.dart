import 'package:Petinder/common/common.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_bloc.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_event.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_state.dart';
import 'package:Petinder/registration_pet/breed_choose/breedChooseBloc/breed_choose_bloc.dart';
import 'package:Petinder/registration_pet/breed_choose/breedChooseBloc/breed_choose_event.dart';
import 'package:Petinder/registration_pet/breed_choose/breedChooseBloc/breed_choose_state.dart';
import 'package:Petinder/registration_pet/fistScreen/pet_cart.dart';
import 'package:Petinder/registration_pet/utils/category.dart';
import 'package:Petinder/registration_pet/utils/make_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PetMainFilter extends StatefulWidget {
  @override
  _PetMainFilterState createState() => _PetMainFilterState();
}

class _PetMainFilterState extends State<PetMainFilter> {
  bool addReady = false;
  BannerAd add;
  @override
  void initState() {
    add = addAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<PetMainBloc>().add(SubmitFilteringPetEvent());
        return true;
      },
      child: BlocBuilder<PetMainBloc, PetMainState>(
          builder: (context, petMainState) {
        return Scaffold(
          appBar: buildAppBar(context),
          body: SidekickTeamBuilder<String>(
            animationDuration: Duration(milliseconds: 300),
            initialSourceList: petMainState.character,
            initialTargetList: petMainState.characterChosen,
            builder: (context, sourceBuilderDelegates, targetBuilderDelegates) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(
                    children: [
                      ListView(
                        children: <Widget>[
                          BlocBuilder<BreedChooseBloc, BreedChooseState>(
                            builder: (context, state) {
                              if (state is PetChosenState) {
                                context.read<PetMainBloc>().add(
                                    ChooseBreedEventFilter(
                                        breedName: state.petName.name));
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        makeTitle("Rasa"),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Hero(
                                              tag: state.petName.name,
                                              child: PetCart(
                                                  petName: state.petName)),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<BreedChooseBloc>()
                                                  .add(PetNotChosenEvent());
                                            },
                                            child: Align(
                                                alignment: Alignment.topRight,
                                                child: Icon(
                                                  Icons.remove_circle,
                                                  size: 24,
                                                )))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25,
                                    )
                                  ],
                                );
                              } else {
                                context
                                    .read<PetMainBloc>()
                                    .add(ChooseBreedEventFilter(breedName: ""));
                                return SizedBox(
                                  height: 0,
                                );
                              }
                            },
                          ),
                          makeTitle("Pochodzenie"),
                          ownerTypeChooser(context, false,
                              petMainState: petMainState),
                          SizedBox(
                            height: 25,
                          ),
                          makeTitle("Wiek"),
                          ageSlider(context, false, petMainState: petMainState),
                          SizedBox(
                            height: 35,
                          ),
                          makeTitle("P??e??"),
                          genderChooser(context, false,
                              petMainState: petMainState),
                          SizedBox(
                            height: 25,
                          ),
                          makeTitle("Gatunek"),
                          Container(
                            height: 140,
                            child: ListView.builder(
                              itemCount: categoryList.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var category = categoryList[index];
                                return petCategory(
                                    category, index, context, false,
                                    petMainState: petMainState);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          makeTitle("Charakter"),
                          allPetCharacterUpper(sourceBuilderDelegates),
                          allPetCharacterLower(
                              targetBuilderDelegates, petMainState),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: decideAdd(),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Color(0xffFAFAFA),
      leading: IconButton(
        color: Color(0xff4F5563),
        icon: SvgPicture.asset(
          'images/ios-back.svg',
          width: 90,
          height: 90,
        ),
        onPressed: () {
          context.read<PetMainBloc>().add(SubmitFilteringPetEvent());
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget allPetCharacterLower(
      List<SidekickBuilderDelegate<String>> targetBuilderDelegates,
      PetMainState petMainState) {
    return Center(
      child: Wrap(
        spacing: 18.0,
        runSpacing: 18.0,
        children: targetBuilderDelegates.map((builderDelegate) {
          return builderDelegate.build(
            context,
            GestureDetector(
              onTap: () {
                builderDelegate.state.move(builderDelegate.message);

                context.read<PetMainBloc>().add(
                    RemovePetCharacter(petCharacter: builderDelegate.message));
              },
              child: petCharacterLower(
                  builderDelegate.message,
                  Common.images[builderDelegate.message],
                  context,
                  petMainState),
            ),
            animationBuilder: (animation) => CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget allPetCharacterUpper(
      List<SidekickBuilderDelegate<String>> sourceBuilderDelegates) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 350.0),
      child: Transform.translate(
        offset: Offset(0, -40),
        child: Center(
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: sourceBuilderDelegates.map((builderDelegate) {
              return builderDelegate.build(
                context,
                GestureDetector(
                  onTap: () {
                    builderDelegate.state.move(builderDelegate.message);

                    context.read<PetMainBloc>().add(
                        AddPetCharacter(petCharacter: builderDelegate.message));
                  },
                  child: petCharacterUpper(
                    builderDelegate.message,
                    Common.images[builderDelegate.message],
                  ),
                ),
                animationBuilder: (animation) => CurvedAnimation(
                  parent: animation,
                  curve: FlippedCurve(Curves.easeOut),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget petCharacterLower(String text, String image, BuildContext context,
      PetMainState petMainState) {
    double width = MediaQuery.of(context).size.width;
    print(width);
    return Transform.translate(
      offset: Offset(0, -40),
      child: Material(
        type: MaterialType.transparency,
        child: Container(
            width: width * 0.8,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                shape: BoxShape.rectangle,
                color: Colors.white12.withOpacity(1.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 15.0,
                    offset: new Offset(0.0, 0.75),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(text,
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  featureChooser(text, "du??o", petMainState, 0,
                      "images/jed.png", false, width / 6.54, 31),
                  featureChooser(text, "??rednio", petMainState, 1,
                      "images/dw.png", true, width / 2.9, 31),
                  featureChooser(text, "ma??o", petMainState, 2,
                      "images/trz.png", true, width / 6.54, 31),
                ],
              ),
            )),
      ),
    );
  }

  Widget featureChooser(
      String text,
      String textCharacter,
      PetMainState petMainState,
      int index,
      String image,
      bool isRight,
      double vertical,
      double top) {
    return Positioned(
      right: isRight ? vertical : null,
      left: !isRight ? vertical : null,
      top: top,
      child: InkWell(
        onTap: () {
          context
              .read<PetMainBloc>()
              .add(UpdatePetCharacter(petCharacter: text, index: index));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              textCharacter,
              style: TextStyle(
                  backgroundColor: petMainState.chosen[text] == index
                      ? Colors.yellow.withOpacity(0.4)
                      : Colors.transparent),
            ),
            SizedBox(
              height: 4,
            ),
            Container(width: 40, height: 40, child: Image.asset(image)),
          ],
        ),
      ),
    );
  }

  Widget petCharacterUpper(String text, String image) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: 92,
        height: 77,
        padding: const EdgeInsets.only(top: 15.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(20.0),
          shape: BoxShape.rectangle,
          color: Colors.black.withOpacity(0.5),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black26,
              blurRadius: 5.0,
              offset: new Offset(5.0, 5.0),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              text,
              style: new TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
            SizedBox(height: 7),
            Container(
                height: 28,
                child: SvgPicture.asset(
                  image,
                  semanticsLabel: 'first',
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }


  //-------------------------

  BannerAd addAd() {
    BannerAd ad = BannerAd(
      adUnitId: "ca-app-pub-2430907631837756/4167562607",
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            addReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    ad.load();
    return ad;
  }

  Widget decideAdd() {
    if (addReady) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15, top: 15),
        child: Container(
          width: 320,
          height: 50,
          child: AdWidget(
            ad: add,
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  @override
  void dispose() {
    add.dispose();
    super.dispose();
  }
}
