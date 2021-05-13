import 'dart:io';
import 'package:Petinder/common/common.dart';
import 'package:Petinder/registration_pet/breed_choose/breedChooseBloc/breed_choose_bloc.dart';
import 'package:Petinder/registration_pet/breed_choose/breedChooseBloc/breed_choose_event.dart';
import 'package:Petinder/registration_pet/breed_choose/breedChooseBloc/breed_choose_state.dart';
import 'package:Petinder/registration_pet/fistScreen/pet_cart.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_bloc.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_event.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_state.dart';
import 'package:Petinder/registration_pet/utils/category.dart';
import 'package:Petinder/registration_pet/utils/make_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();

  const FirstScreen() : super();
}

class _FirstScreenState extends State<FirstScreen> {
  int currentPage = 0;
  final picker = ImagePicker();
  FocusNode _focusNode;
  FocusNode _focusNode2;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode2 = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationPetBloc, RegistrationPetState>(
        builder: (context, registrationState) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              locationWidget(registrationState),
              Container(
                height: MediaQuery.of(context).size.height * 0.37,
                width: double.infinity,
                child: PageView.builder(
                  itemBuilder: (context, index) {
                    return Opacity(
                      opacity: currentPage == index ? 1.0 : 0.8,
                      child: index <= registrationState.images.length - 1
                          ? imagesCard(registrationState.images[index])
                          : loadMoreCard(context),
                    );
                  },
                  itemCount: registrationState.images.length + 1,
                  controller:
                      PageController(initialPage: 0, viewportFraction: 0.60),
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              updateIndicators(registrationState),
              SizedBox(
                height: 25,
              ),
              _nameForm(context, registrationState),
              SizedBox(
                height: 35,
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
                    return petCategory(category, index, context, true,
                        registrationState: registrationState);
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              BlocBuilder<BreedChooseBloc, BreedChooseState>(
                builder: (context, state) {
                  if (state is PetChosenState &&
                      (registrationState.specieChosen == 0 ||
                          registrationState.specieChosen == 1)) {
                    context
                        .read<RegistrationPetBloc>()
                        .add(ChooseBreedEvent(breedName: state.petName.name));
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Hero(
                                  tag: state.petName.name,
                                  child: PetCart(petName: state.petName)),
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
                        .read<RegistrationPetBloc>()
                        .add(ChooseBreedEvent(breedName: ""));
                    return SizedBox(
                      height: 0,
                    );
                  }
                },
              ),
              makeTitle("Opis"),
              _descForm(context, registrationState),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget locationWidget(RegistrationPetState registrationPetState) {
    return registrationPetState.adress.isNotEmpty
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 5,
                child: Text(
                  registrationPetState.adress,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        : SizedBox();
  }

  Widget _nameForm(
      BuildContext context, RegistrationPetState registrationState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: TextFormField(
          initialValue: registrationState.petName,
          focusNode: _focusNode,
          onTap: _requestFocus,
          onChanged: (value) {
            context
                .read<RegistrationPetBloc>()
                .add(AddPetNameEvent(petName: value));
          },
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                'images/dog-tag.svg',
                width: 5,
                height: 5,
              ),
            ),
            labelText: "Wprowadź imię ",
            labelStyle: _focusNode.hasFocus
                ? TextStyle(color: Colors.black, fontSize: 16)
                : TextStyle(color: Color(0xff7B7B7B), fontSize: 14),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          validator: (val) {
            if (val.length == 0) {
              return "Email cannot be empty";
            } else {
              return null;
            }
          },
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  Widget _descForm(
      BuildContext context, RegistrationPetState registrationState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
        child: TextFormField(
          initialValue: registrationState.petDesc,
          maxLines: 10,
          focusNode: _focusNode2,
          onTap: _requestFocus2,
          onChanged: (value) {
            context
                .read<RegistrationPetBloc>()
                .add(AddPetDescEvent(petDesc: value));
          },
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: !_focusNode2.hasFocus ? "Wprowadź opis" : "",
            labelText: _focusNode2.hasFocus ? "Wprowadź opis" : "",
            labelStyle: _focusNode2.hasFocus
                ? TextStyle(color: Colors.black, fontSize: 16)
                : TextStyle(color: Color(0xff7B7B7B), fontSize: 14),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Color(0xff1A6D85)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          validator: (val) {
            if (val.length == 0) {
              return "Email cannot be empty";
            } else {
              return null;
            }
          },
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _requestFocus2() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode2);
    });
  }

  Widget imagesCard(File image) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(72, 76, 82, 0.16),
                offset: Offset(0, 20),
                blurRadius: 10.0),
          ],
          image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget loadMoreCard(context) {
    return InkWell(
      onTap: () {
        showPicker(context);
      },
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.blue,
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(72, 76, 82, 0.16),
                  offset: Offset(0, 20),
                  blurRadius: 10.0),
            ],
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  'images/petPhoto.svg',
                  width: 120,
                  height: 120,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Dodaj zdjęcie \n twojego pupila",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'GothamRounded'),
                      textAlign: TextAlign.center,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget updateIndicators(RegistrationPetState registrationState) {
    List<Widget> dots = List<Widget>.generate(
        registrationState.images.length + 1,
        (index) => Container(
              width: 7.0,
              height: 7.0,
              margin: EdgeInsets.symmetric(horizontal: 6.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index ? Colors.red : Color(0xFFA6AEBD),
              ),
            ));

    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: [...dots]);
  }

  void imgFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        context.read<RegistrationPetBloc>().add(AddImageEvent(
            newImage: File(pickedFile.path), newImagePath: pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  void imgFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        context.read<RegistrationPetBloc>().add(AddImageEvent(
            newImage: File(pickedFile.path), newImagePath: pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Z dysku'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  Divider(
                    color: Colors.black,
                    height: 2,
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Z kamery'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
