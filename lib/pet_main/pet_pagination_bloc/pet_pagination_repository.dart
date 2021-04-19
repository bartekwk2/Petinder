import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class PetPaginationRepository {
  double scrollOffset = 0.0;
  static final PetPaginationRepository _petPaginationRepository =
      PetPaginationRepository._();

  PetPaginationRepository._();

  factory PetPaginationRepository() {
    return _petPaginationRepository;
  }

  Future<dynamic> getPets(
    double longitude,
    double latitude,
    double distance,
    int limit,
    int page,
  ) async {
    try {
      var meters = distance * 1000;
      return await http.get(
        'https://petsyy.herokuapp.com/petsNearby2?longitude=$longitude&latitude=$latitude&distance=$meters&limit=$limit&page=$page',
      );
    } catch (e) {
      return e.toString();
    }
  }

  String distanceBetween(lat, long, myLat, myLong) {
    double distance = Geolocator.distanceBetween(myLat, myLong, lat, long);
    String distanceKm = (distance / 1000).toStringAsFixed(1);
    return "$distanceKm km";
  }

  Future<dynamic> getPetsWithQuery(String body, int page, int limit) async {
    try {
      return await http.post(
          "https://petsyy.herokuapp.com/petsNearbyQueries?page=$page&limit=$limit",
          headers: {"Content-Type": "application/json"},
          body: body);
    } catch (e) {
      return e.toString();
    }
  }
}
