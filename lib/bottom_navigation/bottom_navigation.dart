import 'package:Petinder/bottom_navigation/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:Petinder/bottom_navigation/bottom_navigation_bloc/bottom_navigation_state.dart';
import 'package:Petinder/repository/location_repository.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../navigation/router.dart';
import 'bottom_navigation_bloc/bottom_navigation_event.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        LocationRepository()..determinePosition().then((value) => print(value));
        return true;
      },
      child: BlocBuilder<BotttomNavigationBloc, BottomNavigationState>(
          builder: (context, viewState) {
        int index = viewState.pageChosen;

        return Scaffold(
          body: decideScreen(index,viewState.isAdded),
          bottomNavigationBar: FFNavigationBar(
            theme: FFNavigationBarTheme(
              barBackgroundColor: Colors.white,
              selectedItemBorderColor: Colors.transparent,
              selectedItemBackgroundColor: Colors.green,
              selectedItemIconColor: Colors.white,
              selectedItemLabelColor: Colors.black,
              showSelectedItemShadow: false,
              barHeight: 70,
            ),
            selectedIndex: index == 5 ? 2 : index,
            onSelectTab: (index) {
              context
                  .read<BotttomNavigationBloc>()
                  .add(ChooseViewEvent(viewIndex: index));
            },
            items: [
              FFNavigationBarItem(
                iconData: Icons.location_on,
                label: 'Mapa',
              ),
              FFNavigationBarItem(
                iconData: Icons.add_circle_outline,
                label: 'Dodaj',
                selectedBackgroundColor: Colors.orange,
              ),
              FFNavigationBarItem(
                iconData: Icons.search,
                label: 'Szukaj',
                selectedBackgroundColor: Colors.purple,
              ),
              FFNavigationBarItem(
                iconData: Icons.swipe,
                label: 'Swipe',
                selectedBackgroundColor: Colors.blue,
              ),
              FFNavigationBarItem(
                iconData: Icons.message,
                label: 'Czat',
                selectedBackgroundColor: Colors.red,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget decideScreen(int index,bool isAdded) {
    switch (index) {
      case 0:
        return mapScreen();
        break;
      case 1:
        return addPet();
      case 2:
        return findPet();
      case 3:
        return swipeOption();
      case 4:
        return chatScreen();
      case 5:
        return findPetWithRefresh(isAdded);
      default:
        return findPet();
    }
  }
}
