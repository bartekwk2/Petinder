import 'package:Petinder/models/message.dart';
import 'package:equatable/equatable.dart';

abstract class SendMessageEvent extends Equatable {
  const SendMessageEvent();

  @override
  List<Object> get props => [];
}

class InitialLoadingEvent extends SendMessageEvent {}

class LoadMoreMessegesEvent extends SendMessageEvent {
  final String yourID;
  final String friendID;
  LoadMoreMessegesEvent({this.yourID, this.friendID});
  @override
  List<Object> get props => [yourID, friendID];
}

class LoadChatScreenEvent extends SendMessageEvent {
  final String yourID;
  final String friendID;
  LoadChatScreenEvent({this.yourID, this.friendID});
  @override
  List<Object> get props => [yourID, friendID];
}

class MessageSendingEvent extends SendMessageEvent {
  final UserMessage message;
  MessageSendingEvent({this.message});
  @override
  List<Object> get props => [message];
}

class MessageReceivedEvent extends SendMessageEvent {
  final UserMessage message;
  MessageReceivedEvent({this.message});
  @override
  List<Object> get props => [message];
}
