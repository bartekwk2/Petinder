import 'package:Petinder/common/common.dart';
import 'package:Petinder/di/injection_container.dart';
import 'package:Petinder/navigation/router.dart';
import 'package:Petinder/welcome/google_sign_in_repository.dart';
import 'package:Petinder/welcome/utils/large_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> animation;
  var welcomeScreenIndex = 0;

  Widget child;
  PageController controllerPage =
      PageController(viewportFraction: 1, keepPage: true);
  int prevValue = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 10), vsync: this);
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
    animation = IntTween(begin: 0, end: 3).animate(curvedAnimation)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[buildSwipingCards(), buildLoginArea()],
          ),
        ),
      ),
    );
  }

  Widget buildSwipingCards() {
    return Expanded(
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          if (controllerPage.hasClients && prevValue != animation.value) {
            controllerPage.animateToPage(animation.value,
                duration: Duration(milliseconds: 600), curve: Curves.ease);
          }
          prevValue = animation.value;
          return Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 22),
                child: PageView.builder(
                    controller: controllerPage,
                    physics: BouncingScrollPhysics(),
                    onPageChanged: (page) {
                      welcomeScreenIndex = page;
                    },
                    itemCount: Common.welcomeScreens.length,
                    itemBuilder: (context, index) => homeScreenDisplay(index)),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: List.generate(
                      Common.welcomeScreens.length,
                      (index) => buildSliderIndicator(index),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Future<void> handleLocation() async {
    Box locationBox = Hive.box("Location");
    bool newLocation = locationBox.get("newLocation");
    print("JAK $newLocation");
    bool firstTime = true;
    if (newLocation) {
      Hive.box("IsLogin").put("IsLogin", true);

      Navigator.pushNamed(context, RouteConstant.dashboard);
    } else {
      locationBox.watch()
        ..listen((event) {
          if (firstTime) {
            Hive.box("IsLogin").put("IsLogin", true);
            Navigator.pushNamed(context, RouteConstant.dashboard);
            firstTime = false;
          }
        });
    }
  }

  Widget buildLoginArea() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () async {
              var id = await inject<GoogleSignInRepository>().handleSignIn();
              if (id.isNotEmpty) {
                print("b");
                await handleLocation();
              }
            },
            child: LargeButton(
              showIcon: true,
              icon: SvgPicture.asset(
                'images/google.svg',
                height: 35,
              ),
              borderColor: Colors.grey.withOpacity(0.5),
              buttonText: 'Logowanie Google',
              fillColor: Colors.white,
              buttonTextColor: Color(0xff4F5563),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteConstant.loginScreen);
            },
            child: LargeButton(
              showIcon: false,
              borderColor: Color(0xff4F5563),
              buttonText: 'Logowanie e-mailem',
              fillColor: Color(0xff4F5563),
              buttonTextColor: Colors.white,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteConstant.registerScreen);
            },
            child: Text(
              'Pierwszy raz? Zarejestruj się',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
      height: 0.45 * MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Color(0xff3B3B3B),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    );
  }

  Widget homeScreenDisplay(int index) {
    switch (index) {
      case 0:
        return Stack(
          children: [
            Image.asset(
              Common.welcomeScreens[index]["image"],
              fit: BoxFit.fill,
            ),
            Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text("Petinder",
                        style: TextStyle(
                            fontSize: 40,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600)))),
            Padding(
                padding: const EdgeInsets.only(top: 50.0, right: 6),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text("Aplikacja adopcyjna",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400))))
          ],
        );
      case 1:
        return Stack(
          children: [
            Image.asset(
              Common.welcomeScreens[index]["image"],
              fit: BoxFit.fill,
            ),
            Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text("Miejsce dla każdego zwierzaka",
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600)))),
            Padding(
                padding: const EdgeInsets.only(top: 85.0, right: 6),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text("Ze schronisk, hodowli, domowe",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400))))
          ],
        );
      case 2:
        return Stack(
          children: [
            Image.asset(
              Common.welcomeScreens[index]["image"],
              fit: BoxFit.fill,
            ),
            secondScreenText("Znajdź ", 60, 10, 20, FontWeight.w600),
            secondScreenText("wymarzonego", 20, 32, 20, FontWeight.w600),
            secondScreenText(
                "psa ,kota, chomika,", 18, 65, 16, FontWeight.w400),
            secondScreenText("królika,konia,mysz", 21, 86, 16, FontWeight.w400),
            secondScreenText("a nawet kangura", 21, 107, 16, FontWeight.w400),
          ],
        );

      case 3:
        return Stack(
          children: [
            Image.asset(
              Common.welcomeScreens[index]["image"],
              fit: BoxFit.fill,
            ),
            thirdScreenText(
                "Jedna aplikacja, wiele możliwości", 1, 0, 19, FontWeight.w600),
            thirdScreenText(
                "Skontaktuj się z właścicielem", 32, 6, 15, FontWeight.w400),
            thirdScreenText(
                "Ogłoszenia w twojej okolicy", 54, 6, 15, FontWeight.w400),
            thirdScreenText("Baw się opcją swipe", 77, 6, 15, FontWeight.w400),
          ],
        );

      default:
        return Stack(
          children: [
            Image.asset(
              Common.welcomeScreens[index]["image"],
              fit: BoxFit.fill,
            ),
          ],
        );
    }
  }

  Widget secondScreenText(String text, double right, double top,
      double fontSize, FontWeight fontWeight) {
    return Positioned(
        right: right,
        top: top,
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: fontSize,
                fontFamily: "Poppins",
                fontWeight: fontWeight)));
  }

  Widget thirdScreenText(String text, double top, double right, double fontSize,
      FontWeight fontWeight) {
    return Padding(
        padding: EdgeInsets.only(top: top, right: right),
        child: Align(
            alignment: Alignment.topCenter,
            child: Text(text,
                style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: "Poppins",
                    fontWeight: fontWeight))));
  }

  AnimatedContainer buildSliderIndicator(index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.all(3),
      height: 8,
      width: welcomeScreenIndex == index ? 25 : 8,
      decoration: BoxDecoration(
        color: welcomeScreenIndex == index
            ? Color(Common.welcomeScreens[index]["indicolor"])
            : Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
