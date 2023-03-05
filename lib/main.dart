
import 'package:flutter/material.dart';

//import 'package:location/location.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weatherapp/constants/nav_constants.dart';
import 'package:weatherapp/constants/str_constants.dart';
import 'package:weatherapp/navigation/customroute.dart';

Future<void> main() async {
  await Hive.initFlutter();
  //debugPrint("hi");
  await Hive.deleteBoxFromDisk(StrConstants.cities);
  await Hive.openBox(StrConstants.cities);
  //debugPrint("hello");
  Box cityBox = Hive.box(StrConstants.cities);
  // cityBox.add({
  //   "name": "Canberra",
  //   "region": "Australian Capital Territory",
  //   "country": "Australia",
  //   "temp_c": "21",
  //   "is_day": "0",
  //   "text": "Clear",
  //   "wind_kph": "24.1",
  //   "pressure_mb": "1013",
  //   "humidity": "73",
  //   "cloud": "0",
  //   "feelslike_c": "21",
  //   "uv": "1",
  //   "is_favourite": "yes"
  // });
  // cityBox.add({
  //   "name": "New Jersey",
  //   "region": "Australian Capital Territory",
  //   "country": "Australia",
  //   "temp_c": "21",
  //   "is_day": "0",
  //   "text": "Clear",
  //   "wind_kph": "24.1",
  //   "pressure_mb": "1013",
  //   "humidity": "73",
  //   "cloud": "0",
  //   "feelslike_c": "21",
  //   "uv": "1",
  //   "is_favourite": "no"
  // });

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key, required this.products}) : super(key: key);
  const MyApp({Key? key}) : super(key: key);

  //final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: StrConstants.weatherApp,
      initialRoute: NavConstants.splashScreenPage,
      onGenerateRoute: CustomRoute.generateRoute,
    );
  }
}
