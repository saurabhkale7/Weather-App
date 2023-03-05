import 'package:flutter/foundation.dart';
import 'package:weatherapp/api/api.dart';
import 'package:weatherapp/controller/methods.dart';
import 'package:weatherapp/model/api_reponse.dart';
import 'package:weatherapp/model/database.dart';
import '../constants/str_constants.dart';

final API weatherApiObj = API.apiObj;
List<Map<String, String>> cityList=[];

Future<APIResponse> createCitiesResponse(bool isFav) async {
  //when no records are there
  if (cityList.isEmpty) {
    return APIResponse(
        msg: StrConstants.info,
        desc: StrConstants.emptyStr,
        data: []);
  }
  //when device is not connected to the internet
  //then show old data
  else if (!await isDeviceWithInternet()) {
    return APIResponse(
        msg: StrConstants.info,
        desc: StrConstants.noInternet,
        data: cityList);
  }
  //otherwise get new data and show it
  else {
    APIResponse weatherApiResponse;
    List<Map<String, String>> newCityList = [];
    //bool isIncorrectResponse=false;

    for (Map<String, String> city in cityList) {
      //pass city name to getWeatherAt() method and fetch data for today only so true
      weatherApiResponse = await compute(
          weatherApiObj.getWeatherAt, [city[StrConstants.locKeys[0]], true]);

      //check whether response for each city is appropriate or not
      if (weatherApiResponse.msg.compareTo(StrConstants.success) != 0) {
        return APIResponse(
            msg: weatherApiResponse.msg,
            desc: weatherApiResponse.desc,
            data: cityList);
      }

      weatherApiResponse.data[0][StrConstants.isFavourite] = StrConstants.yes;
      newCityList.add(weatherApiResponse.data[0]);
    }

    if(isFav) {
      CityWeatherDatabase.cityWeatherDBObj.updateFavourites(newCityList.reversed.toList());
    } else{
      CityWeatherDatabase.cityWeatherDBObj.updateRecent(newCityList);
    }

    return APIResponse(
        msg: StrConstants.success,
        desc: StrConstants.emptyStr,
        data: newCityList);
  }
}

class FavouriteCitiesProvider extends ChangeNotifier {
  bool areFavouriteCitiesLoading = false;
  APIResponse favouriteCitiesResponse = APIResponse(msg: StrConstants.info, desc: StrConstants.emptyStr, data: []);

  void getFavouriteCities() async {
    areFavouriteCitiesLoading = true;
    notifyListeners();

    cityList = CityWeatherDatabase.cityWeatherDBObj.getFavouriteCities();
    favouriteCitiesResponse = await createCitiesResponse(true);

    areFavouriteCitiesLoading = false;
    notifyListeners();
  }
}

class RecentCitiesProvider extends ChangeNotifier {
  bool areRecentCitiesLoading = false;
  late APIResponse recentCitiesResponse = APIResponse(msg: StrConstants.info, desc: StrConstants.emptyStr, data: []);

  void getRecentCities() async {
    areRecentCitiesLoading = true;
    notifyListeners();

    cityList = CityWeatherDatabase.cityWeatherDBObj.getRecentCities();
    recentCitiesResponse = await createCitiesResponse(false);

    areRecentCitiesLoading = false;
    notifyListeners();
  }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  // }
}

class LocationDataProvider extends ChangeNotifier {
  bool isLoading = true;
  late APIResponse weatherApiResponse;

  Future<void> getLocationWeatherData(String location, bool daysEqualTo1) async {
    isLoading = true;
    notifyListeners();

    weatherApiResponse =
    await compute(weatherApiObj.getWeatherAt, [location, daysEqualTo1]);
    CityWeatherDatabase.cityWeatherDBObj.deleteItem(weatherApiResponse.data[0][StrConstants.locKeys[0]]!);

    isLoading = false;
    notifyListeners();
  }
}

class MainCityDataProvider extends ChangeNotifier {
  bool isLoading = true;
  late APIResponse weatherApiResponse;

  Future<void> getCityWeatherData(String location, bool daysEqualTo1) async {
    isLoading = true;
    notifyListeners();

    weatherApiResponse =
    await compute(weatherApiObj.getWeatherAt, [location, daysEqualTo1]);
    CityWeatherDatabase.cityWeatherDBObj.deleteItem(weatherApiResponse.data[0][StrConstants.locKeys[0]]!);
    weatherApiResponse.data[0][StrConstants.isFavourite]=StrConstants.no;

    isLoading = false;
    notifyListeners();
  }
}