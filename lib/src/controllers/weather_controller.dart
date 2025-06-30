import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sigma_home/firebase_options.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:weather/weather.dart';
import 'package:get/get.dart';

class WeatherController extends GetxController {
  RxDouble latitude = 0.0.obs;
  RxDouble longtitude = 0.0.obs;

  RxString locations = "".obs;
  RxString celcius = "".obs;
  RxString weatherIcon = "wi-owm-800".obs;
  RxString weatheraStatus = "".obs;

  RxBool isLoading = false.obs;

  WeatherFactory wf = WeatherFactory(
    DefaultFirebaseOptions.openWeatherAPI,
    language: Language.INDONESIAN,
  );

  @override
  void onInit() {
    super.onInit();
    getCurrentWeather();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 100,
    );

    //test apakah location service enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //location service not enabled dont continue accessing the position and requeset
      //user of the app to enable the location services
      return Future.error("location services are disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //jika ditolak kedua kalinya maka
        return Future.error("location permissions are denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        "location permission are permanently denied, we cannot request permissions.",
      );
    }

    //setelah melewati berbagai permission check lalu langsung return position sekarang
    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  Future<void> getCurrentWeather() async {
    try {
      isLoading.value = true;
      //mengambil posisi saat ini dan menyimpannya
      await determinePosition().then((position) {
        latitude.value = position.latitude;
        longtitude.value = position.longitude;
      });

      //ubah posisi menjadi lokasi
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude.value,
        longtitude.value,
      );

      List<String> lokasi = placemarks.map<String>((loc) {
        return "${loc.locality}, ${loc.subAdministrativeArea}, ${loc.administrativeArea}";
      }).toList();
      locations.value = lokasi[1];

      //mendapatkan info cuaca di lokasi saat ini
      await wf.currentWeatherByLocation(latitude.value, longtitude.value).then((
        weather,
      ) {
        celcius.value = "${weather.temperature!.celsius!.round()}°";
        weatherIcon.value = "wi-owm-${weather.weatherConditionCode}";
        weatheraStatus.value = weather.weatherDescription!;
      });
    } catch (error) {
      Get.snackbar(
        "Error!",
        error.toString(),
        backgroundColor: AppTheme.errorColor,
        colorText: AppTheme.surfaceColor,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
