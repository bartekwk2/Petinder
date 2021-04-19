import 'package:rxdart/rxdart.dart';

class NotificationsBloc {
  final BehaviorSubject<bool> _notificationsStreamController =
      BehaviorSubject<bool>();

  Stream<bool> get notificationsStream {
    return _notificationsStreamController;
  }

  Stream<bool> get notificationsObservable {
    return _notificationsStreamController.stream;
  }

  void newNotification(bool newMessage) {
    _notificationsStreamController.sink.add(newMessage);
  }

  void dispose() {
    _notificationsStreamController?.close();
  }
}
