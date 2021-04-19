import 'package:Petinder/chat/search/search_bloc/search_bloc.dart';
import 'package:Petinder/chat/search/search_bloc/search_event.dart';
import 'package:Petinder/chat/search/search_bloc/search_state.dart';
import 'package:Petinder/common/success.dart';
import 'package:Petinder/navigation/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class DisplaySearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchBody(),
    );
  }
}

class SearchBody extends StatefulWidget {
  @override
  _SearchBodyState createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String selectedTerm;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushNamed(context, RouteConstant.dashboard);
        return true;
      },
      child: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, friendState) {
        if (friendState is ClickedEndSearchState) {
          FocusScope.of(context).unfocus();
        } else if (friendState is AddingFriendSuccessState) {
          showSuccess(context, "Pomylnie dodanao znajomego",'Dodawanie udane!');
        }
      }, builder: (context, friendState) {
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: FloatingSearchBar(
                transitionDuration: const Duration(milliseconds: 400),
                transitionCurve: Curves.easeInOut,
                controller: controller,
                body: FloatingSearchBarScrollNotifier(
                  child: searchResults(friendState),
                ),
                transition: CircularFloatingSearchBarTransition(),
                automaticallyImplyBackButton: false,
                physics: BouncingScrollPhysics(),
                title: Row(
                  children: [
                    GestureDetector(
                        onTap: () async {
                          await Navigator.pushNamed(
                              context, RouteConstant.dashboard);
                        },
                        child: Icon(Icons.arrow_back)),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      selectedTerm ?? 'Wyszukaj tutaj',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                hint: 'Wprowadź tutaj tekst...',
                actions: [
                  FloatingSearchBarAction.searchToClear(),
                ],
                onQueryChanged: (query) {
                  if (query.length > 2) {
                    context
                        .read<SearchBloc>()
                        .add(FetchResultsEvent(query: query));
                  }
                },
                onSubmitted: (query) {
                  context.read<SearchBloc>().add(ClickedEndSearchEvent());
                },
                builder: (context, transition) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                        color: Colors.white,
                        elevation: 4,
                        child: Builder(
                          builder: (_) {
                            if (friendState is SearchSuccessState) {
                              if (friendState.userNames.isNotEmpty) {
                                return Container(
                                  width: double.infinity,
                                  height: 60.0 * friendState.userNames.length+20,
                                  child: ListView.builder(
                                    itemCount: friendState.userNames.length,
                                    itemBuilder: (context, index) {
                                      var photos = friendState
                                          .userNames[index].photosRef;
                                      if (photos == null) {
                                        photos = [];
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          context.read<SearchBloc>().add(
                                              ClickedEndSearchEvent(
                                                  friendChosen: friendState
                                                      .userNames[index]));
                                        },
                                        child: ListTile(
                                          leading: photos.isEmpty
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 3.0),
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    child: SvgPicture.asset(
                                                        'images/user.svg'),
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          "https://petsyy.herokuapp.com/image/${photos.first}"),
                                                ),
                                          title: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(friendState
                                                .userNames[index].name),
                                          ),
                                          trailing: const Icon(Icons.search),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return Container(
                                  width: double.infinity,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    "Nie znaleziono wyników",
                                    style: TextStyle(fontSize: 16),
                                  )),
                                );
                              }
                            } else if (friendState is ClickedEndSearchState) {
                              return Container();
                            } else {
                              return Container(
                                width: double.infinity,
                                height: 50,
                                child: Center(
                                    child: Text(
                                  "Szukanie...",
                                  style: TextStyle(fontSize: 16),
                                )),
                              );
                            }
                          },
                        )),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget submitButton(
      SearchState registrationState, Color color, String text, String userID) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            if (text == "Anuluj") {
              context.read<SearchBloc>().add(ClickedEndSearchEvent());
            } else {
              context.read<SearchBloc>().add(AddFriendEvent(friendID: userID));
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(5, 5),
                  blurRadius: 10,
                )
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  Widget searchResults(SearchState friendState) {
    return Material(
      color: Colors.white,
          child: Builder(
        builder: (_) {

          if (friendState is! ClickedEndSearchState) {
            if (friendState is SearchErrorState) {
              print("ERROR ${friendState.props}");
            }
            return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Image.asset('images/ab.jpg'),
                   SizedBox(height: 15,),
                  Text(
                    'Znajdź użytkowników',
                    style: Theme.of(context).textTheme.headline5,
                  )
                ],
              ),
            );
          } else if (friendState is ClickedEndSearchState) {
            if (friendState.friendChosen == null) {
              return Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2 ),
                child:  Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Image.asset('images/ab.jpg'),
                   SizedBox(height: 15,),
                  Text(
                    'Znajdź użytkowników',
                    style: Theme.of(context).textTheme.headline5,
                  )
                ],
              )
              );
            } else {
              var photos = friendState.friendChosen.photosRef;
              var mediaQuery = MediaQuery.of(context).size;
              if (photos == null) {
                photos = [];
              }
              return Padding(
                padding: EdgeInsets.only(
                    left: mediaQuery.width * 0.07,
                    right: mediaQuery.width * 0.07,
                    top: mediaQuery.height * 0.16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              offset: Offset(0.0, 3.0),
                              blurRadius: 8.0,
                            ),
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Wybrano użytkownika",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                fontSize: 21),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          !photos.isEmpty
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  child: CircleAvatar(
                                      backgroundImage: CachedNetworkImageProvider(
                                          "https://petsyy.herokuapp.com/image/${photos.first}")),
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  child: SvgPicture.asset('images/user.svg')),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            friendState.friendChosen.name,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 17),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: mediaQuery.width * 0.04,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                submitButton(
                                    friendState,
                                    Colors.red.withOpacity(0.8),
                                    "Anuluj",
                                    friendState.friendChosen.sId),
                                submitButton(
                                    friendState,
                                    Colors.green.withOpacity(0.8),
                                    "Dodaj",
                                    friendState.friendChosen.sId),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
