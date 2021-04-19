class PetPaginationState {
  final String message;
  final String error;
  final List<dynamic> pets;
  final bool newQuery;
  final bool isLoading;
  final bool isError;
  final bool noMorePets;
  final bool firstTime;
  final bool showSheet;
  final bool isAdded;

  PetPaginationState(
      {this.error,
      this.isLoading,
      this.message,
      this.noMorePets,
      this.pets,
      this.isError,
      this.firstTime,
      this.showSheet,
      this.isAdded,
      this.newQuery});

  factory PetPaginationState.empty() {
    return PetPaginationState(
        message: "",
        error: "",
        pets: [],
        noMorePets: false,
        firstTime: true,
        newQuery: false,
        isAdded: false,
        isLoading: false,
        showSheet: false,
        isError: false);
  }

  PetPaginationState copyWith({
    String message,
    String error,
    bool noMorePets,
    List<dynamic> pets,
    bool newQuery,
    bool showSheet,
    bool isLoading,
    bool firstTime,
    bool isError,
    bool isAdded,
  }) {
    return PetPaginationState(
      message: message ?? this.message,
      error: error ?? this.error,
      isAdded: isAdded ?? this.isAdded,
      noMorePets: noMorePets ?? this.noMorePets,
      pets: pets ?? this.pets,
      showSheet: showSheet ?? this.showSheet,
      firstTime: firstTime ?? this.firstTime,
      newQuery: newQuery ?? this.newQuery,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }

  @override
  String toString() {
    return 'PetPaginationState(message: $message, error: $error, pets: $pets, newQuery: $newQuery, isLoading: $isLoading, isError: $isError, noMorePets $noMorePets,firstTime: $firstTime)';
  }
}
