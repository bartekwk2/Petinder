import 'package:rxdart/rxdart.dart';

class RefreshPetMainBloc {
  final BehaviorSubject<bool> _refreshsStreamController =
      BehaviorSubject<bool>();

  Stream<bool> get refreshsStream {
    return _refreshsStreamController;
  }

  Stream<bool> get refreshsObservable {
    return _refreshsStreamController.stream;
  }

  void newRefresh(bool newMessage) {
    _refreshsStreamController.sink.add(newMessage);
  }

  void dispose() {
    _refreshsStreamController?.close();
  }
}