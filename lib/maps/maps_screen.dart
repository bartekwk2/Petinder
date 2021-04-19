import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:Petinder/maps/maps_bloc/maps_event.dart';
import 'package:Petinder/models/pet.dart';
import 'package:Petinder/navigation/router.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:Petinder/maps/maps_bloc/maps_bloc.dart';
import 'package:Petinder/maps/maps_bloc/maps_state.dart';
import 'package:Petinder/maps/slider_thumb_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'maps_bloc/maps_repository.dart';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController _controller;
  PageController pageController;
  MapsState mapsState;
  ui.Image image;
  int prevPage;
  Timer _debounce;

  @override
  void initState() {
    loadImage("images/co.png").then((value) => {image = value});
    pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (pageController.page.toInt() != prevPage) {
      prevPage = pageController.page.toInt();
      moveCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapsBloc, MapsState>(builder: (context, mapsState) {
      this.mapsState = mapsState;
      return mapsState.myPosition.isNotEmpty
          ? Scaffold(
              body: SafeArea(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height - 50.0,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: true,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(mapsState.myPosition["lat"],
                              mapsState.myPosition["long"]),
                          zoom: getZoomLevel(mapsState.distance)),
                      markers: Set.from(mapsState.allMarkers),
                      onMapCreated: (controller) {
                        _controller = controller;
                        cameraZoom();
                        context.read<MapsBloc>().add(DistanceChangedEventFetch(
                            controller: pageController));
                      },
                      circles: mapsState.circle,
                    ),
                  ),
                  mapsState.pets.length > 0
                      ? Positioned(
                          bottom: 20.0,
                          child: Container(
                            height: 200.0,
                            width: MediaQuery.of(context).size.width,
                            child: PageView.builder(
                              controller: pageController,
                              itemCount: mapsState.pets.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _petsListItem(
                                    index, mapsState.pets[index]);
                              },
                            ),
                          ),
                        )
                      : SizedBox(),
                  Positioned(
                      top: 52,
                      right: 120,
                      left: 120,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                offset: Offset(0.0, 4.0),
                                blurRadius: 10.0,
                              ),
                            ]),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "${mapsState.distance.toInt()} km",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                  Positioned(
                    top: 20,
                    right: 30,
                    left: 30,
                    child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                offset: Offset(0.0, 4.0),
                                blurRadius: 10.0,
                              ),
                            ]),
                        child: SliderTheme(
                          data: SliderThemeData(
                              thumbShape: (SliderThumbImage(image)),
                              trackHeight: 1,
                              thumbColor: Colors.black,
                              activeTrackColor: Colors.black),
                          child: Slider(
                            onChanged: (double value) {
                              context.read<MapsBloc>().add(
                                  DistanceChangedEventSlider(distance: value));
                              if (_debounce?.isActive ?? false)
                                _debounce.cancel();
                              _debounce =
                                  Timer(const Duration(milliseconds: 200), () {
                                context.read<MapsBloc>().add(
                                    DistanceChangedEventFetch(
                                        controller: pageController));
                              });
                              cameraZoom();
                            },
                            value: mapsState.distance,
                            min: 0,
                            max: 100,
                            label: "${mapsState.distance.round()}",
                          ),
                        )),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 58.0),
                      child: Container(
                        height: 200,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                offset: Offset(0.0, 4.0),
                                blurRadius: 10.0,
                              ),
                            ]),
                        child: Column(
                          children: [
                            petOriginButton(0),
                            petOriginButton(1),
                            petOriginButton(2),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ))
          : Center(
              child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  color: Colors.white));
    });
  }

  Widget petOriginButton(int index) {
    return Expanded(
      child: InkWell(
        onTap: () {
          context.read<MapsBloc>().add(
              CategoryClickedEvent(index: index, controller: pageController));
        },
        child: Container(
            width: 80,
            decoration: BoxDecoration(
              borderRadius: index == 1 ? null : decideBorderRadius(index),
              color: mapsState.originChosen.contains(index)
                  ? decideColor(index)
                  : Colors.white.withAlpha(1),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Text(
                    originChosen(index).replaceFirst(", ", ""),
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                      width: 30,
                      height: 30,
                      child: SvgPicture.asset(assetOriginChosen(index),
                          semanticsLabel: 'first'),
                    ),
                  ),
                  index != 2
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Divider(
                            height: 2.5,
                            color: Colors.black,
                          ),
                        )
                      : SizedBox()
                ],
              ),
            )),
      ),
    );
  }

  _petsListItem(int index, Pet pet) {
    var breed = pet.petBreed;
    if (breed == null) {
      breed = "";
    }
    return AnimatedBuilder(
      animation: pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (pageController.position.haveDimensions) {
          value = pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 425.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            var petData = {"pet": pet,'swipe' : false};
            Navigator.of(context)
                .pushNamed(RouteConstant.profileDetail, arguments: petData);
          },
          child: Stack(children: [
            Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 15.0,
                ),
                width: 275.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0.0, 4.0),
                        blurRadius: 10.0,
                      ),
                    ]),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 45),
                      child: Column(children: [
                        featureElement("images/petProfile/hourglass2.svg",
                            "${pet.age} lat", 105),
                        SizedBox(
                          height: 10,
                        ),
                        featureElement(
                            "images/petProfile/gender.svg",
                            "${genderChosen(pet.gender).replaceFirst(", ", "")}",
                            105),
                        SizedBox(
                          height: 10,
                        ),
                        featureElement("images/petProfile/worldwide.svg",
                            "${pet.city}, ${pet.locationString}", 10),
                        SizedBox(
                          height: 10,
                        ),
                        featureElement(
                            "images/petProfile/paw.svg",
                            "${specieChosen(pet.typeOfPet).replaceFirst(", ", "")} $breed",
                            10),
                      ]),
                    ))),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 80, top: 30),
                child: Text(pet.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: "GothamRounded",
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
                height: 110.0,
                width: 110.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            "https://petsyy.herokuapp.com/image/${pet.imageRefs.first}"),
                        fit: BoxFit.cover))),
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: decideColor(pet.typeOfPetOwner),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      assetOriginChosen(pet.typeOfPetOwner),
                      width: 20,
                      height: 20,
                      color: Colors.black87.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            )
          ])),
    );
  }

  Widget featureElement(String asset, String feature, double padding) {
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            asset,
            color: Colors.black,
            width: 20,
            height: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            feature,
            style: TextStyle(fontSize: 15, fontFamily: "GothamRounded"),
          ),
        ],
      ),
    );
  }

  moveCamera() {
    var position =
        mapsState.pets[pageController.page.toInt()].location.coordinates;
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position[1], position[0]),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  cameraZoom() {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            mapsState.myPosition["lat"],
            mapsState.myPosition["long"],
          ),
          zoom: getZoomLevel(mapsState.distance),
        ),
      ),
    );
  }

  Future<ui.Image> loadImage(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  double getZoomLevel(double radius) {
    double scale = radius * 1000 / 500;
    double zoomLevel = (16 - log(scale) / log(2));
    return zoomLevel;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
