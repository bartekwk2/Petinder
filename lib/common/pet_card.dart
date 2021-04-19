import 'package:Petinder/models/pet.dart';
import 'package:Petinder/pet_main/pet_main_bloc/pet_main_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PetCard extends StatelessWidget {
  final Pet pet;

  PetCard({this.pet});
  @override
  Widget build(BuildContext context) {
    var breed = pet.petBreed;
    if (breed == null) {
      breed = "";
    }
    return Material(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0.0, 1.0),
                  blurRadius: 2.0,
                ),
              ]),
          height: 210.0,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.width * 0.35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0)),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            "https://petsyy.herokuapp.com/image/${pet.imageRefs.first}"),
                        fit: BoxFit.cover)),
              ),
              Positioned(
                  right: 20,
                  bottom: 20,
                  child: Container(
                    width: 80,
                    height: 80,
                    child: SvgPicture.asset(
                      'images/petProfile/pawprints.svg',
                      color: Colors.black.withAlpha(15),
                    ),
                  )),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.39,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 17,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.12,
                          ),
                          Text(pet.name,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: "GothamRounded",
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      featureElement(
                          'images/petProfile/hourglass2.svg', "${pet.age} lat"),
                      SizedBox(
                        height: 7,
                      ),
                      featureElement('images/petProfile/gender.svg',
                          "${genderChosen(pet.gender).replaceFirst(", ", "")}"),
                      SizedBox(
                        height: 7,
                      ),
                      featureElement('images/petProfile/pet-house.svg',
                          "${originChosen(pet.typeOfPetOwner).replaceFirst(", ", "")}"),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 15,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6,
                      ),
                      featureElement('images/petProfile/paw.svg',
                          "${specieChosen(pet.typeOfPet).replaceFirst(", ", "")} $breed"),
                      SizedBox(
                        height: 7,
                      ),
                      featureElement('images/petProfile/worldwide.svg',
                          "${pet.city}, ${pet.locationString}"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget featureElement(String asset, String feature) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          asset,
          color: Colors.black,
          width: 20,
          height: 20,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          feature,
          style: TextStyle(fontSize: 17, fontFamily: "GothamRounded"),
        )
      ],
    );
  }
}
