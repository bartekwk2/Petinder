import 'package:Petinder/chat/chat_theme.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_bloc.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_event.dart';
import 'package:Petinder/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

Widget conversation(
    {UserApp receiverName,
    List<dynamic> messages,
    String myID,
    String photosRef,
    String notMyID,
    BuildContext context}) {
  ScrollController _scrollController = ScrollController();
  return ListView.builder(
      controller: _scrollController
        ..addListener(() {
          if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent) {
            context
                .read<SendMessageBloc>()
                .add(LoadMoreMessegesEvent(yourID: myID, friendID: notMyID));
          }
        }),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, int index) {
        final message = messages[index];
        bool isMe = message.senderID == myID;
        return Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isMe)
                    photosRef.isNotEmpty
                        ? CircleAvatar(
                            radius: 15,
                            backgroundImage: CachedNetworkImageProvider(
                                "https://petsyy.herokuapp.com/image/" +
                                    receiverName.photosRef.first),
                          )
                        : Container(
                            width: 32,
                            height: 32,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SvgPicture.asset('images/main/dog.svg'),
                              ),
                            ),
                          ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    decoration: BoxDecoration(
                        color: isMe ? MyTheme.kAccentColor : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 12 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 12),
                        )),
                    child: Text(
                      messages[index].message,
                      style: MyTheme.bodyTextMessage.copyWith(
                          color: isMe ? Colors.white : Colors.grey[900]),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!isMe)
                      SizedBox(
                        width: 40,
                      ),
                    Text(
                      message.dateOfSend,
                      style: MyTheme.bodyTextTime,
                    )
                  ],
                ),
              )
            ],
          ),
        );
      });
}
