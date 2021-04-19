import 'package:Petinder/common/pet_card.dart';
import 'package:Petinder/favourite/favourtie_pet_repository.dart';
import 'package:Petinder/navigation/router.dart';
import 'package:flutter/material.dart';

class FavouritePetScreen extends StatefulWidget {
  @override
  _FavouritePetState createState() => _FavouritePetState();
}

class _FavouritePetState extends State<FavouritePetScreen>
    with SingleTickerProviderStateMixin {
  Future<List<dynamic>> pets;
  TabController _tabController;
  FavouritePetRepository favouritePetRepository;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    favouritePetRepository = FavouritePetRepository();
    pets = favouritePetRepository.getPetsByType("Own");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75.0),
          child: AppBar(
            backgroundColor: Colors.black,
            leading: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back)),
            ),
            bottom: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black54,
              tabs: <Tab>[
                Tab(
                  child: Text(
                    "Polubione",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Tab(
                  child: Text(
                    "Własne",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
              controller: _tabController,
            ),
            title: null,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [getPets("Liked"), getPets("Own")],
        ));
  }

  Widget getPets(String type) {
    return FutureBuilder<dynamic>(
        future: favouritePetRepository.getPetsByType(type),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> petsData = snapshot.data;
            return Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ListView.builder(
                itemCount: petsData.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      var pet = petsData[index];
                      var arguments = {"pet": pet, 'swipe': false};
                      Navigator.of(context).pushNamed(
                          RouteConstant.profileDetail,
                          arguments: arguments);
                    },
                    child: Hero(
                      tag: petsData[index].name,
                      child: PetCard(
                        pet: petsData[index],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
