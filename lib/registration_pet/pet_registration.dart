import 'package:Petinder/registration_pet/secondScreen/second_screen.dart';
import 'package:Petinder/registration_pet/thirdScreen/third_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'fistScreen/first_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PetRegistration extends StatefulWidget {
  PetRegistration({Key key}) : super(key: key);

  @override
  _PetRegistrationState createState() => _PetRegistrationState();
}

class _PetRegistrationState extends State<PetRegistration> {
  PageController _controller =
      PageController(initialPage: 0, viewportFraction: 0.99);
  Widget _firstScreen;
  Widget _secondScreen;
  Widget _thirdScreen;

  bool addReady = false;
  BannerAd add;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _inactiveColor = Colors.grey[100];
  List<String> _titles;
  int _curStep = 1;
  Color _activeColor = Color(0xff1A6D85);

  double lineWidth = 4.0;

  List<String> _icons = [
    "images/paw-print.svg",
    "images/femenine.svg",
    "images/heart.svg"
  ];

  @override
  void initState() {
    add = addAd();
    _firstScreen = FirstScreen();
    _secondScreen = SecondScreen();
    _thirdScreen = ThirdScreen();
    super.initState();
  }

  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Column(children: [
            Container(
                padding: EdgeInsets.only(
                  top: 52.0,
                  left: 24.0,
                  right: 24.0,
                ),
                width: _width,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: _iconViews(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_titles != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _titleViews(),
                      ),
                  ],
                )),
            Expanded(
                child: PageView(
              controller: _controller,
              onPageChanged: (page) {
                setState(() {
                  _curStep = page + 1;
                });
              },
              children: [_firstScreen, _secondScreen, _thirdScreen],
            ))
          ]),
          Align(
            alignment: Alignment.bottomCenter,
            child: decideAdd(),
          )
        ],
      ),
    );
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    _icons.asMap().forEach((i, icon) {
      var circleColor =
          (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor;

      var lineColor =
          _curStep > i + 1 ? _activeColor : Colors.grey.withOpacity(0.5);

      var iconColor =
          (i == 0 || _curStep > i + 1) ? _inactiveColor : _activeColor;

      list.add(
        //dot with icon view
        Container(
          width: 35.0,
          height: 35.0,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset(
              icon,
              color: iconColor,
              //size: 20.0,
            ),
          ),
          decoration: BoxDecoration(
            color: circleColor,
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            border: Border.all(
              color: _activeColor,
              width: 2.0,
            ),
          ),
        ),
      );

      //line between icons
      if (i != _icons.length - 1) {
        list.add(Expanded(
            child: Container(
          height: lineWidth,
          color: lineColor,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, text) {
      list.add(Text(text, style: TextStyle(color: _activeColor)));
    });
    return list;
  }

  //-------------------------

  BannerAd addAd() {
    BannerAd ad = BannerAd(
      adUnitId: "ca-app-pub-2430907631837756/7787049897",
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
}
