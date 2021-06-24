import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart' as locationLib;

class LocationRepository {
  Future<String> determinePosition() async {
    bool serviceEnabled = false;
    LocationPermission permission;
    locationLib.Location location = locationLib.Location();

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    while (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    Map<String, double> positionMap = {
      "lat": position.latitude,
      "long": position.longitude
    };
    var locationBox = Hive.box("Location")
      ..put("newLocation", true)
      ..put("positionMap", positionMap);

    print("positionMap $positionMap");

    await getAddressFromCoordinates(
        Coordinates(position.latitude, position.longitude), locationBox);

    return "done";
  }

  Future<void> getAddressFromCoordinates(
      Coordinates coordinates, Box locationBox) async {
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    String addressLine = addresses.first.addressLine;

    var addressArray = addressLine.split(",");
    String country = addressArray.last;
    String city = addressArray[1];
    if (city.contains(" ")) {
      var words = city.split(" ");
      if (words.length > 3) {
        city = "${words[1]} ";
        words.asMap().forEach((key, value) {
          if (key > 1 && key < words.length - 1) {
            city += "${value[0]} ";
          }
          if (key == words.length - 1) {
            city += "$value ";
          }
        });
      }
    }
    city = city.trim();
    country = country.trim();
    await locationBox.put("country", country);
    await locationBox.put("city", city);
  }
}
