import 'package:Petinder/models/message.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_bloc.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_event.dart';
import 'package:Petinder/common/common.dart';
import 'package:Petinder/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatComposer extends StatefulWidget {
  
  final UserApp receiverName;
  final List<dynamic> chats;
  final String myID;
  final String notMyID;

  ChatComposer({ this.receiverName, this.chats, this.myID,this.notMyID});
  @override
  _ChatComposerState createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
              height: 53,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Opacity(opacity: 0,child: Icon(Icons.attach_file, color: Colors.grey[500], size: 25)),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Wpisz swoją wiadomość ...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        UserMessage newMessage = UserMessage(
                            message: textEditingController.text,
                            senderID: widget.myID,
                            receiverID: widget.notMyID,
                            dateOfSend: Common.getCurrentDate());

                        textEditingController.text = '';
                        FocusScope.of(context).unfocus();

                        context
                            .read<SendMessageBloc>()
                            .add(MessageSendingEvent(message: newMessage));
                      },
                      child: Icon(Icons.send_outlined,
                          color: Colors.grey[500], size: 25))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
