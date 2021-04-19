import 'package:equatable/equatable.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';

abstract class SendMessageState extends Equatable {
  const SendMessageState();
  @override
  List<Object> get props => [];
}

class TurnOnCommunicationState extends SendMessageState {
  final SocketIO socketIO;
  TurnOnCommunicationState({this.socketIO});
  @override
  List<Object> get props => [socketIO];
}

class LoadingState extends SendMessageState {}

class LoadChatScreenState extends SendMessageState {
  final List<dynamic> chats;
  final dynamic receiver;
  LoadChatScreenState({this.chats, this.receiver});
  @override
  List<Object> get props => [chats, receiver];
}

class LoadingErrorState extends SendMessageState {}
