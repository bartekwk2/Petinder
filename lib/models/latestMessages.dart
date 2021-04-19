class Friends {
  LastMsg lastMsg;
  String sId;
  FriendRef friendRef;

  Friends({this.lastMsg, this.sId, this.friendRef});

  Friends.fromJson(Map<String, dynamic> json) {
    lastMsg =
        json['lastMsg'] != null ? new LastMsg.fromJson(json['lastMsg']) : null;
    sId = json['_id'];
    friendRef = json['friendRef'] != null
        ? new FriendRef.fromJson(json['friendRef'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lastMsg != null) {
      data['lastMsg'] = this.lastMsg.toJson();
    }
    data['_id'] = this.sId;
    if (this.friendRef != null) {
      data['friendRef'] = this.friendRef.toJson();
    }
    return data;
  }

  @override
  String toString() =>
      'Friends(lastMsg: $lastMsg, sId: $sId, friendRef: $friendRef)';
}

class LastMsg {
  String message;
  String senderID;
  String receiverID;
  String dateOfSend;
  bool hasSeen;

  LastMsg(
      {this.message,
      this.senderID,
      this.receiverID,
      this.dateOfSend,
      this.hasSeen});

  LastMsg.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    senderID = json['senderID'];
    hasSeen = json['hasSeen'];
    receiverID = json['receiverID'];
    dateOfSend = json['dateOfSend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['senderID'] = this.senderID;
    data['hasSeen'] = this.hasSeen;
    data['receiverID'] = this.receiverID;
    data['dateOfSend'] = this.dateOfSend;
    return data;
  }

  @override
  String toString() {
    return 'LastMsg(message: $message, senderID: $senderID, receiverID: $receiverID, dateOfSend: $dateOfSend, hasSeen: $hasSeen)';
  }
}

class FriendRef {
  List<String> photosRef;
  String sId;
  String name;
  bool isActive;
  String lastActive;

  FriendRef(
      {this.photosRef, this.sId, this.name, this.isActive, this.lastActive});

  FriendRef.fromJson(Map<String, dynamic> json) {
    photosRef = json['photosRef'].cast<String>();
    sId = json['_id'];
    name = json['name'];
    isActive = json['isActive'];
    lastActive = json['lastActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photosRef'] = this.photosRef;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['lastActive'] = this.lastActive;
    return data;
  }

  @override
  String toString() =>
      'FriendRef(photosRef: $photosRef, sId: $sId, name: $name, isActive: $isActive, lastActive: $lastActive)';
}
