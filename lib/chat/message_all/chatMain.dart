import 'package:Petinder/common/common.dart';
import 'package:Petinder/di/injection_container.dart';
import 'package:Petinder/navigation/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../messages_income_bloc.dart';
import 'message_all_repository.dart';

class ChatMain extends StatefulWidget {
  @override
  _ChatMainState createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  MessageAllRepository messageAllRepository;
  Future<List<dynamic>> friends;
  Box chatBox;

  @override
  void initState() {
    super.initState();
    messageAllRepository = MessageAllRepository();
    friends = messageAllRepository.getFriends();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder<Object>(
        stream: inject<NotificationsBloc>().notificationsObservable,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("data");
            friends = messageAllRepository.getFriends();
          }
          return SafeArea(
            child: Scaffold(
              backgroundColor: Color(0xff171719),
              body: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(top: 15),
                    sliver: SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverAppBarDelegate(
                        minHeight: 65.0,
                        maxHeight: 65.0,
                        child: Container(
                          color: Color(0xff171719),
                          child: _insideAppBar(),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 20,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      height: 120,
                      child: FutureBuilder<dynamic>(
                          future: friends,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var friends = snapshot.data;
                              return ListView.builder(
                                  itemCount: friends.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    var photosRef =
                                        friends[index].friendRef.photosRef;
                                    if (photosRef == null) {
                                      photosRef = "";
                                    } else if (photosRef.isEmpty) {
                                      photosRef = "";
                                    } else {
                                      photosRef = photosRef.first;
                                    }
                                    return StoryTile(
                                      friendID: friends[index].friendRef.sId,
                                      isActive:
                                          friends[index].friendRef.isActive,
                                      imgUrl: photosRef,
                                      username: friends[index].friendRef.name,
                                    );
                                  });
                            } else {
                              return SizedBox();
                            }
                          }),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Ostatnie",
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.more_vert,
                                    color: Colors.black45,
                                  )
                                ],
                              ),
                            ),
                            FutureBuilder<dynamic>(
                                future: friends,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<dynamic> friends = snapshot.data;
                                    List<dynamic> lastMsgFriendsBefore = friends
                                        .where((element) =>
                                            element.lastMsg != null)
                                        .toList();
                                    List<dynamic> lastMsgFriends =
                                        lastMsgFriendsBefore
                                            .where((element) =>
                                                element.lastMsg.message != null)
                                            .toList()
                                              ..sort((a, b) => DateFormat(
                                                      "yyyy-MM-dd HH:mm")
                                                  .parse(b.lastMsg.dateOfSend)
                                                  .compareTo(DateFormat(
                                                          "yyyy-MM-dd HH:mm")
                                                      .parse(a.lastMsg
                                                          .dateOfSend)));

                                    return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: decidePadding(
                                                lastMsgFriends.length, height)),
                                        child: ListView.builder(
                                            itemCount: lastMsgFriends.length,
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              String senderID =
                                                  lastMsgFriends[index]
                                                      .lastMsg
                                                      .senderID;
                                              String message =
                                                  lastMsgFriends[index]
                                                      .lastMsg
                                                      .message;
                                              String name =
                                                  lastMsgFriends[index]
                                                      .friendRef
                                                      .name;
                                              dynamic photosRef =
                                                  lastMsgFriends[index]
                                                      .friendRef
                                                      .photosRef;
                                              if (photosRef == null) {
                                                photosRef = "";
                                              } else if (photosRef.isEmpty) {
                                                photosRef = "";
                                              } else {
                                                photosRef = photosRef.first;
                                              }
                                              var hasSeen =
                                                  lastMsgFriends[index]
                                                      .lastMsg
                                                      .hasSeen;
                                              if (hasSeen == null) {
                                                hasSeen = true;
                                              }
                                              if (senderID ==
                                                  Hive.box("IsLogin")
                                                      .get("id")) {
                                                hasSeen = true;
                                              }

                                              return ChatTile(
                                                isActive: lastMsgFriends[index]
                                                    .friendRef
                                                    .isActive,
                                                friendID: lastMsgFriends[index]
                                                    .friendRef
                                                    .sId,
                                                imgUrl: photosRef,
                                                name: name,
                                                lastMessage: decideSender(
                                                    message, senderID, name),
                                                haveunreadmessages: !hasSeen,
                                                lastSeenTime: decideTime(
                                                    lastMsgFriends[index]
                                                        .lastMsg
                                                        .dateOfSend),
                                              );
                                            }));
                                  } else {
                                    return Container(
                                      height: 500,
                                    );
                                  }
                                }),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }

  String decideSender(String message, String idSender, String nameOfFriend) {
    var username = makeUsername(nameOfFriend);

    if (idSender == Hive.box("IsLogin").get("id")) {
      return "ty: $message";
    } else {
      return "$username: $message";
    }
  }

  double decidePadding(int elementsCount, double height) {
    double result = (height * 0.48) - (elementsCount - 1) * 95;
    if (result.isNegative) {
      return 0.0;
    } else {
      return result;
    }
  }

  Widget _insideAppBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 3),
      child: Row(
        children: <Widget>[
          Text(
            "Wiadomości",
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.w600),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(RouteConstant.searchScreen);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color(0xff444446),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget decidePhoto(dynamic imgUrl, bool isActive, bool isFromStory) {
  return !imgUrl.isEmpty
      ? Container(
          width: 60,
          height: 60,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: CachedNetworkImage(
                  imageUrl: "https://petsyy.herokuapp.com/image/$imgUrl",
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: isActive ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ))
            ],
          ),
        )
      : Container(
          width: 60,
          height: 60,
          child: Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                child: CircleAvatar(
                    backgroundColor: isFromStory
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset('images/main/dog.svg'),
                    )),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: isActive ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ))
            ],
          ),
        );
}

String makeUsername(String name) {
  if (name.contains("@")) {
    name = name.split("@").first;
  }
  return name;
}

class StoryTile extends StatelessWidget {
  final dynamic imgUrl;
  final dynamic username;
  final bool isActive;
  final dynamic friendID;
  StoryTile(
      {@required this.imgUrl,
      @required this.username,
      this.isActive,
      @required this.friendID});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, RouteConstant.chatDetailRoute,
            arguments: {"friendID": friendID});
      },
      child: Container(
        margin: EdgeInsets.only(right: 22),
        child: Column(
          children: <Widget>[
            decidePhoto(imgUrl, isActive, true),
            SizedBox(
              height: 16,
            ),
            Text(
              makeUsername(username),
              style: TextStyle(
                  color: Color(0xff78778a),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String friendID;
  final String imgUrl;
  final String name;
  final String lastMessage;
  final bool haveunreadmessages;
  final String lastSeenTime;
  final bool isActive;
  ChatTile(
      {@required this.haveunreadmessages,
      @required this.friendID,
      @required this.lastSeenTime,
      @required this.lastMessage,
      @required this.imgUrl,
      @required this.isActive,
      @required this.name});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, RouteConstant.chatDetailRoute,
            arguments: {"friendID": friendID});
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: <Widget>[
            decidePhoto(imgUrl, isActive, false),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    makeUsername(name),
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    lastMessage,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontFamily: "Neue Haas Grotesk"),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 14,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(lastSeenTime),
                  SizedBox(
                    height: 16,
                  ),
                  haveunreadmessages
                      ? Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Color(0xffff410f),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            "N",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ))
                      : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
