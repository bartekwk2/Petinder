class PetProfileState {
  final bool isFavourite;
  final bool isOwnOrDisliked;
  final bool isFetched;
  final bool canGoToChat;
  final bool deletionOk;
  final dynamic userData;

  factory PetProfileState.empty() {
    return PetProfileState(
        isFavourite: false,
        isOwnOrDisliked: false,
        canGoToChat: false,
        deletionOk: false,
        isFetched: false,
        userData: "");
  }

  PetProfileState(
      {this.isFavourite,
      this.isOwnOrDisliked,
      this.isFetched,
      this.userData,
      this.deletionOk,
      this.canGoToChat});

  PetProfileState copyWith(
      {bool isFavourite,
      bool isOwnOrDisliked,
      bool isFetched,
      bool deletionOk,
      bool canGoToChat,
      dynamic userData}) {
    return PetProfileState(
        deletionOk: deletionOk ?? this.deletionOk,
        canGoToChat: canGoToChat ?? this.canGoToChat,
        isFavourite: isFavourite ?? this.isFavourite,
        isOwnOrDisliked: isOwnOrDisliked ?? this.isOwnOrDisliked,
        isFetched: isFetched ?? this.isFetched,
        userData: userData ?? this.userData);
  }

  @override
  String toString() =>
      'PetProfileState(isFavourite: $isFavourite, isOwnOrDisliked: $isOwnOrDisliked, isFetched: $isFetched, userData: $userData, canGoToChat : $canGoToChat)';
}
