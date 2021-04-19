class UserMessage {
  String sId;
  String message;
  String senderID;
  String receiverID;
  String dateOfSend;

  UserMessage(
      {this.sId,
      this.message,
      this.senderID,
      this.receiverID,
      this.dateOfSend});

  UserMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    message = json['message'];
    senderID = json['senderID'];
    receiverID = json['receiverID'];
    dateOfSend = json['dateOfSend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['message'] = this.message;
    data['senderID'] = this.senderID;
    data['receiverID'] = this.receiverID;
    data['dateOfSend'] = this.dateOfSend;
    return data;
  }

  @override
  String toString() {
    return 'UserMessage(sId: $sId, message: $message, senderID: $senderID, receiverID: $receiverID, dateOfSend: $dateOfSend)';
  }
}
