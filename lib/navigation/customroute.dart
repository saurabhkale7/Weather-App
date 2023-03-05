import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/view/old_city_page.dart';
import '../state_management/weather_provider.dart';

import '../constants/nav_constants.dart';
import '../constants/str_constants.dart';
import '../view/add_city.dart';
import '../view/city_list_page.dart';
import '../view/new_city_page.dart';
import '../view/splash_screen.dart';

class CustomRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavConstants.splashScreenPage:
        return MaterialPageRoute(builder: (_)=> const SplashScreen());
      case NavConstants.cityListPage:
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) => FavouriteCitiesProvider()),
              ChangeNotifierProvider(
                  create: (context) => RecentCitiesProvider()),
              ChangeNotifierProvider(
                  create: (context) => LocationDataProvider()),
            ],
            child: const CityList(),
          ),
        );

      case NavConstants.addCityPage:
        return MaterialPageRoute(builder: (_) => const AddCity());

      case NavConstants.cityPage:
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) => MainCityDataProvider()),
            ],
            child: NewCityPage(cityName: (settings.arguments as String)),
          ),
        );

      case NavConstants.oldCityPage:
        return MaterialPageRoute(
          builder: (_) => OldCityPage(city: (settings.arguments as Map<String, String>)),
        );


    // case NavConstants.home:
      //   return MaterialPageRoute(builder: (_)=> const Home());//StrConstants.myArray[index+1][i]
      // case NavConstants.subCatPage:
      //   return MaterialPageRoute(builder: (_)=> NextPage(index: (settings.arguments as int)));
      // case NavConstants.newsPage:
      //   return MaterialPageRoute(builder: (_)=> NewsPage(newsCategory: (settings.arguments as String)));
      // case NavConstants.detailsPage:
      //   return MaterialPageRoute(builder: (_)=> Details(li: (settings.arguments as List)));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text(StrConstants.error),
            ),
            body: const Text(StrConstants.error),
          ),
        );
    }
  }
}
