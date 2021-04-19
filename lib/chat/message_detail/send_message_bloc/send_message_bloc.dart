import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_repository.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_event.dart';
import 'package:Petinder/chat/message_detail/send_message_bloc/send_message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:rxdart/rxdart.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final ChatRepository chatRepository;
  int page = 0;
  SendMessageBloc({this.chatRepository}) : super((LoadingState()));

  @override
  Stream<Transition<SendMessageEvent, SendMessageState>> transformEvents(
    Stream<SendMessageEvent> events,
    TransitionFunction<SendMessageEvent, SendMessageState> transitionFn,
  ) {
    final nonDebounceStream =
        events.where((event) => event is! LoadMoreMessegesEvent);
    final debounceStream = events
        .where((event) => event is LoadMoreMessegesEvent)
        .debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
      MergeStream([nonDebounceStream, debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<SendMessageState> mapEventToState(SendMessageEvent event) async* {
    if (event is LoadChatScreenEvent) {
      page = 0;
      SocketIO init = chatRepository.init(event.yourID);
      yield TurnOnCommunicationState(socketIO: init);
      List<dynamic> chats = await chatRepository.getMessages(
          event.yourID, event.friendID, page, 15);
      page++;
      if (chats != null) {
        dynamic receiver = await chatRepository.getReceiverData(event.friendID);
        yield LoadChatScreenState(chats: chats, receiver: receiver);
      } else {
        yield LoadingErrorState();
      }
    } else if (event is MessageSendingEvent) {
      if (state is LoadChatScreenState) {
        chatRepository.sendMessage(event.message.message,
            event.message.senderID, event.message.receiverID);
        List<dynamic> chats = (state as LoadChatScreenState).chats
          ..insert(0, event.message);
        dynamic receiver = (state as LoadChatScreenState).receiver;
        yield LoadingState();
        yield LoadChatScreenState(chats: chats, receiver: receiver);
      } else {
        yield LoadingErrorState();
      }
    } else if (event is MessageReceivedEvent) {
      if (state is LoadChatScreenState) {
        List<dynamic> chats = (state as LoadChatScreenState).chats
          ..insert(0, event.message);
        dynamic receiver = (state as LoadChatScreenState).receiver;
        yield LoadingState();
        yield LoadChatScreenState(chats: chats, receiver: receiver);
      } else {
        yield LoadingErrorState();
      }
    } else if (event is LoadMoreMessegesEvent) {
      if (state is LoadChatScreenState) {
        List<dynamic> chatsNow = await chatRepository.getMessages(
            event.yourID, event.friendID, page, 15);
        page++;
        List<dynamic> chatsPrev = (state as LoadChatScreenState).chats;
        dynamic reveiver = (state as LoadChatScreenState).receiver;
        yield LoadingState();
        yield LoadChatScreenState(
            chats: chatsPrev..addAll(chatsNow), receiver: reveiver);
      }
    }
  }
}
