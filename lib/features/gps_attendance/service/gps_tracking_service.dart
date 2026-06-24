import 'package:geolocator/geolocator.dart';

class GpsService {

  Future<bool> checkPermission() async {

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission ==
        LocationPermission.denied) {

      permission =
      await Geolocator.requestPermission();
    }

    return permission ==
        LocationPermission.always ||
        permission ==
            LocationPermission.whileInUse;
  }

  Future<bool> isGpsEnabled() async {
    return await Geolocator
        .isLocationServiceEnabled();
  }

  Stream<Position> getPositionStream() {

    return Geolocator.getPositionStream(
      locationSettings:
      const LocationSettings(
        accuracy:
        LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }
}