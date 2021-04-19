class BottomNavigationState {
  final int pageChosen;
  final dynamic user;
  final String country;
  final dynamic positionMap;
  final String city;
  final bool isAdded;

  factory BottomNavigationState.empty() {
    return BottomNavigationState(
      isAdded : false,pageChosen: 2, city: "", country: "", positionMap: {});
  }

  BottomNavigationState(
      {this.pageChosen, this.user, this.country, this.city, this.positionMap,this.isAdded});

  BottomNavigationState copyWith(
      {int pageChosen,
      dynamic user,
      String country,
      bool isAdded,
      String city,
      dynamic positionMap}) {
    return BottomNavigationState(
        pageChosen: pageChosen ?? this.pageChosen,
        isAdded : isAdded ?? this.isAdded,
        country: country ?? this.country,
        city: city ?? this.city,
        positionMap: positionMap ?? this.positionMap,
        user: user ?? this.user);
  }

  @override
  String toString() {
    return 'BottomNavigationState(pageChosen: $pageChosen, user: $user. country: $country, city: $city, positionMap: $positionMap )';
  }
}
