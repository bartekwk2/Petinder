import 'dart:convert';
import 'package:Petinder/common/common.dart';
import 'package:Petinder/models/user.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:http/http.dart' as http;
import '../../../models/message.dart';

class ChatRepository {
  SocketIO socketIO;

  SocketIO init(String myId) {
    socketIO = SocketIOManager().createSocketIO(
        'https://petsyy.herokuapp.com/', '/',
        query: 'chatID=$myId');
    socketIO.init();

    return socketIO;
  }

  void sendMessage(String text, String myId, String notMyId) {
    socketIO.sendMessage(
      'send_message',
      json.encode({
        'receiverChatID': notMyId,
        'senderChatID': myId,
        'content': text,
        'dateOfSend': Common.getCurrentDate()
      }),
    );
  }

  Future<List<dynamic>> getMessages(
      String senderID, String receiverID, int page, int limit) async {
    var response = await http.get(
      "https://petsyy.herokuapp.com/getMessages?userSenderID=$senderID&userReceiverID=$receiverID&page=$page&limit=$limit",
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      try {
        var messages = json.decode(response.body)["conversation"];
        if (messages.isNotEmpty) {
          var messagesOut = messages[0]["messages"].map((val) {
            return UserMessage.fromJson(val);
          }).toList();
          return messagesOut;
        } else {
          return [];
        }
      } catch (e) {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<dynamic> getReceiverData(String receiverID) async {
    var response = await http.get(
      "https://petsyy.herokuapp.com/getUserData?id=$receiverID",
      headers: {"Content-Type": "application/json"},
    );
    var user = UserApp.fromJson(json.decode(response.body)["user"]);
    return user;
  }
}

Future<int> makeLastMessageSeen(String myId, String notMyId) async {
  var response = await http.put(
      "https://petsyy.herokuapp.com/makeLastMessageSeen",
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": myId, "friendID": notMyId}));
  return response.statusCode;
}
