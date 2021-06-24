import 'dart:convert';
import 'package:Petinder/chat/message_all/message_all_repository.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_repository.dart';
import 'package:Petinder/models/message.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_bloc.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_event.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_state.dart';
import 'package:Petinder/navigation/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../chat_theme.dart';
import 'package:flutter/material.dart';
import 'chat_composer.dart';
import 'conversation.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({Key key, this.notMyID}) : super(key: key);
  final String notMyID;
  final String myID = Hive.box("IsLogin").get("id");

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  SocketIO socketIO;
  @override
  void dispose() async {
    socketIO.unSubscribe("receive_message");
    socketIO.disconnect();
    Future.delayed(Duration.zero, () async {
      makeLastMessageSeen(widget.myID, widget.notMyID)
          .then((value) => print("tutaj $value"));
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, RouteConstant.dashboard);
        return true;
      },
      child: BlocBuilder<SendMessageBloc, SendMessageState>(
          builder: (context, petNameState) {
        if (petNameState is LoadChatScreenState) {
          return _renderChatView(
              context, petNameState.chats, petNameState.receiver);
        } else if (petNameState is TurnOnCommunicationState) {
          socketIO = petNameState.socketIO;
          listenForMessagess(petNameState.socketIO);
          return Center(
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              color: Colors.white,
            ),
          );
        } else {
          return Center(
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              color: Colors.white,
            ),
          );
        }
      }),
    );
  }

  Widget _renderChatView(
      BuildContext context, List<dynamic> chats, dynamic receiver) {
    String text = receiver.name;
    if (text.contains("@")) {
      text = text.split("@").first;
    }
    var photosRef = receiver.photosRef;
    if (photosRef == null) {
      photosRef = "";
    } else if (photosRef.isEmpty) {
      photosRef = "";
    } else {
      photosRef = photosRef.first;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff171719),
        toolbarHeight: 80,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            photosRef.isNotEmpty
                ? CircleAvatar(
                    radius: 25,
                    backgroundImage: CachedNetworkImageProvider(
                        "https://petsyy.herokuapp.com/image/" + photosRef),
                  )
                : Container(
                    width: 50,
                    height: 50,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('images/main/dog.svg'),
                      ),
                    ),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: MyTheme.chatSenderName,
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.trip_origin,
                      color: receiver.isActive ? Colors.green : Colors.red,
                      size: 12,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      receiver.isActive
                          ? 'dostępny'
                          : inactiveTime(receiver.lastActive),
                      style: MyTheme.bodyText1.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          Opacity(
            opacity: 0,
                      child: IconButton(
                icon: Icon(
                  Icons.videocam_outlined,
                  size: 28,
                ),
                onPressed: () {}),
          ),
          Opacity(
            opacity: 0,
                      child: IconButton(
                icon: Icon(
                  Icons.call,
                  size: 28,
                ),
                onPressed: () {
                  setState(() {});
                }),
          )
        ],
        elevation: 0,
      ),
      backgroundColor: Color(0xff171719),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: conversation(
                      receiverName: receiver,
                      messages: chats,
                      myID: widget.myID,
                      notMyID: widget.notMyID,
                      photosRef: photosRef,
                      context: context),
                ),
              ),
            ),
            ChatComposer(
              chats: chats,
              myID: widget.myID,
              notMyID: widget.notMyID,
            )
          ],
        ),
      ),
    );
  }

  String inactiveTime(String lastActive) {
    String time = decideTime(lastActive);
    if (time == "teraz") {
      return time;
    } else {
      return "$time temu";
    }
  }

  void listenForMessagess(SocketIO socketIO) {
    socketIO.subscribe('receive_message', (jsonData) async {
      Map<String, dynamic> data = json.decode(jsonData);
      UserMessage incomeMessage = UserMessage(
          dateOfSend: data['dateOfSend'] ?? "dzisiaj",
          message: data['content'],
          senderID: data['senderChatID'],
          receiverID: data['receiverChatID']);
      if (incomeMessage.senderID == widget.notMyID) {
        context
            .read<SendMessageBloc>()
            .add(MessageReceivedEvent(message: incomeMessage));
      }
    });
    socketIO.connect();
  }
}
