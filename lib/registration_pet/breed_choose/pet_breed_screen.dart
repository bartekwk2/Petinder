import 'package:Petinder/registration_pet/fistScreen/pet_cart.dart';
import 'package:Petinder/repository/petNames.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'breedChooseBloc/breed_choose_bloc.dart';
import 'breedChooseBloc/breed_choose_event.dart';

class PetBreedScreen extends StatefulWidget {
  final String searchType;

  PetBreedScreen({this.searchType});
  @override
  _PetBreedScreenrState createState() => _PetBreedScreenrState();
}

class _PetBreedScreenrState extends State<PetBreedScreen> {
  PetNames petNames = PetNames();
  ScrollController _controller;
  String currentChar = "";
  List<Widget> alphabets = [];
  List<String> alphabetsLetters = [];
  Map<String, int> lettersAppearance = {};
  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()
      ..addListener(() {
        int index;
        index = alphabetsLetters.indexOf(currentChar);
        if (index == -1) {
          index = 0;
        }

        String letter = alphabetsLetters[index];
        String letterPrev;
        if (index == 0) {
          letterPrev = letter;
        } else {
          letterPrev = alphabetsLetters[index - 1];
        }
        String letterNext;
        if (index == alphabetsLetters.length - 1) {
          letterNext = letter;
        } else {
          letterNext = alphabetsLetters[index + 1];
        }

        double positionPrev = 22.0 + 130 * (lettersAppearance[letterPrev] - 1);
        double position = 22.0 + 130 * (lettersAppearance[letter] - 1);
        double positionNext = 22.0 + 130 * (lettersAppearance[letterNext] - 1);

        if (_controller.offset >= positionNext &&
            _controller.position.userScrollDirection ==
                ScrollDirection.reverse &&
            positionNext != position) {
          setState(() {
            currentChar = letterNext;
          });
        } else if (_controller.offset < position &&
            _controller.position.userScrollDirection ==
                ScrollDirection.forward &&
            positionPrev != position) {
          setState(() {
            currentChar = letterPrev;
          });
        }

        if (firstTime) {
          setState(() {
            currentChar = alphabetsLetters.first;
          });
          firstTime = false;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: FutureBuilder(
          future: petNames.getPetNames(widget.searchType),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {

              List<dynamic> pets = snapshot.data;
              pets.sort((a, b) => (a.name.toString())
                  .compareTo(b.name.toString()));

              getAlphabetsFromStringList(pets
                  .map((petName) => petName.name.toString())
                  .toList());
              return Stack(
                children: [
                  ListView.builder(
                    controller: _controller,
                    itemExtent: 130,
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      dynamic petName = pets[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(
                          15.0,
                          0,
                          15.0,
                          0,
                        ),
                        child: _petTile(petName),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 28, 10, 0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [...alphabets],
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  void getAlphabetsFromStringList(List<dynamic> originalList) {
    Map<String, int> lettersCount = {};
    for (var item in originalList) {
      if (!alphabetsLetters.contains(item[0])) {
        alphabetsLetters.add(item[0]);
      }
      lettersCount[item[0]] =
          lettersCount[item[0]] != null ? lettersCount[item[0]] + 1 : 1;
    }
    int sum = 0;
    for (var entry in lettersCount.entries) {
      sum += entry.value;
      lettersAppearance[entry.key] = sum - entry.value + 1;
    }

    List<Widget> alphabetWidget =
        alphabetsLetters.map((letter) => _getAlphabetItem(letter)).toList();

    alphabets = alphabetWidget;
  }

  Widget _getAlphabetItem(String alphabet) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            print(lettersAppearance[alphabet]);
            int order = lettersAppearance[alphabet];
            double position = 22.0 + 130 * (order - 1);
            _controller.jumpTo(position);
            currentChar = alphabet;
            print(currentChar);
          });
        },
        child: Text(
          alphabet,
          textAlign: TextAlign.end,
          style: TextStyle(
              fontSize: 15.0,
              fontWeight:
                  currentChar == alphabet ? FontWeight.w700 : FontWeight.w300),
        ),
      ),
    );
  }

  String makePetTitle(String title) {
    if (title.length < 20) {
      return title;
    } else {
      var splited = title.split(' ');
      String output;
      for (int i = 0; i < splited.length; i++) {
        if (i == 1) {
          output += splited[i] + "\n";
        } else {
          output += splited[i] + " ";
        }
      }
      return output;
    }
  }

  Widget _petTile(dynamic petName) {
    return GestureDetector(
        onTap: () {
          context.read<BreedChooseBloc>().add(PetChosenEvent(petName: petName));
          Navigator.pop(context);
        },
        child: Hero(tag: petName.name, child: PetCart(petName: petName)));
  }
}
