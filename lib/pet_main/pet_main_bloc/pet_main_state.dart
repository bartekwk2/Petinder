class PetMainState {
  final int specieChosen;
  final String breedChosen;
  final int genderChosen;
  final double ageChosenUpper;
  final double ageChosenLower;
  final int originChosen;
  final Map<String, int> chosen;
  final List<String> character;
  final List<String> characterChosen;
  final String filtersChosen;
  final String queryBody;
  final bool filterExit;
  final bool filtersSame;

  factory PetMainState.empty() {
    return PetMainState(
        filtersChosen: "",
        specieChosen: -1,
        breedChosen: "",
        genderChosen: -1,
        originChosen: -1,
        ageChosenLower: 0,
        ageChosenUpper: 25,
        character: [
          'Aktywny',
          'Głośny',
          'Żarłoczny',
          'Rodzinny',
          'Mądry',
          'Tresowany',
          'Strachliwy',
          'Łagodny',
          'Samodzielny'
        ],
        chosen: {
          'Aktywny': 0,
          'Głośny': 0,
          'Żarłoczny': 0,
          'Rodzinny': 0,
          'Mądry': 0,
          'Tresowany': 0,
          'Strachliwy': 0,
          'Łagodny': 0,
          'Samodzielny': 0,
        },
        queryBody: "{}",
        filterExit: false,
        filtersSame: false,
        characterChosen: []);
  }

  PetMainState(
      {this.filtersSame,
      this.queryBody,
      this.specieChosen,
      this.breedChosen,
      this.genderChosen,
      this.originChosen,
      this.ageChosenLower,
      this.ageChosenUpper,
      this.characterChosen,
      this.chosen,
      this.filterExit,
      this.filtersChosen,
      this.character});

  PetMainState copyWith(
      {int specieChosen,
      String filtersChosen,
      String breedChosen,
      int genderChosen,
      double ageChosenUpper,
      int problemWithRefreshingHelp,
      double ageChosenLower,
      int originChosen,
      Map<String, int> chosen,
      String queryBody,
      List<String> character,
      bool filterExit,
      bool filtersSame,
      List<String> characterChosen}) {
    return PetMainState(
        filtersSame: filtersSame ?? this.filtersSame,
        queryBody: queryBody ?? this.queryBody,
        filtersChosen: filtersChosen ?? this.filtersChosen,
        specieChosen: specieChosen ?? this.specieChosen,
        breedChosen: breedChosen ?? this.breedChosen,
        genderChosen: genderChosen ?? this.genderChosen,
        originChosen: originChosen ?? this.originChosen,
        ageChosenLower: ageChosenLower ?? this.ageChosenLower,
        ageChosenUpper: ageChosenUpper ?? this.ageChosenUpper,
        chosen: chosen ?? this.chosen,
        filterExit: filterExit ?? this.filterExit,
        character: character ?? this.character,
        characterChosen: characterChosen ?? this.characterChosen);
  }

  @override
  String toString() {
    return 'PetMainState(specieChosen: $specieChosen, breedChosen: $breedChosen, genderChosen: $genderChosen, ageChosenUpper: $ageChosenUpper, ageChosenLower: $ageChosenLower, originChosen: $originChosen, chosen: $chosen, character: $character, characterChosen: $characterChosen,filtersChosen : $filtersChosen,queryBody : $queryBody,filterExit : $filterExit, filtersSame : $filtersSame)';
  }
}
