import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/str_constants.dart';
import 'dart:core';

class CityWeatherDatabase {
  static CityWeatherDatabase cityWeatherDBObj = CityWeatherDatabase();
  late final Box cityBox = Hive.box(StrConstants.cities);

  List<Map<String, String>> getFavouriteCities() {
    List<Map<String, String>> cityList = [];

    if (cityBox.keys.isNotEmpty) {
      for (Map<dynamic, dynamic> city in cityBox.values) {
        Map<String, String> c = {};

        for (var key in city.keys) {
          c[key.toString()] = city[key].toString();
        }

        cityList.add(c);
      }

      cityList = cityList.where((Map<String, String> city) => city[StrConstants
          .isFavourite]?.compareTo(StrConstants.yes) == 0)
          .toList();

      debugPrint("in get fav cities = ${cityBox.values.length}");
    }

    return cityList.reversed.toList();
  }

  List<Map<String, String>> getRecentCities() {
    List<Map<String, String>> cityList = [];

    if (cityBox.values.isNotEmpty) {

      for (Map<dynamic, dynamic> city in cityBox.values) {
        Map<String, String> c = {};

        for (var key in city.keys) {
          c[key.toString()] = city[key].toString();
        }

        cityList.add(c);
      }

      debugPrint("in get recent cities = ${cityBox.values.length}");

      if (cityList.length <= 10) {
        return cityList.reversed.toList();
      } else {
        return cityList.reversed.take(10).toList();
      }
    }

    return cityList;
  }

  Future<void> createItem(Map<String, String> newItem) async {
    await cityBox.add(newItem);
  }

  Map<String, dynamic> readItem(Box box, int key) {
    final item = box.get(key);
    return item;
  }

  Future<void> updateItem(int itemKey, Map<String, String> item) async {
    await cityBox.put(itemKey, item);
  }

  void updateFavourites(List<Map<String, String>> cityList) {
    for (Map<String, String> cityData in cityList) {
      for (int key in cityBox.keys) {
        Map<dynamic, dynamic> city = cityBox.get(key);

        if (city[StrConstants.locKeys[0]].toString().toLowerCase().compareTo(
            cityData[StrConstants.locKeys[0]]!.toLowerCase()) == 0 && city[StrConstants.isFavourite].toString().compareTo(StrConstants.yes)==0) {
          debugPrint("in update favs");
          updateItem(key, cityData);
        }
      }
    }
    // }
    // for (Map<dynamic, dynamic> city in cityBox.values) {
    //   for (var key in city.keys) {
    //     if (key.toString().compareTo() == 0)
    //       c[key.toString()] = city[key].toString();
    //   }
    // }

    // for (int i in cityBox.keys
    //     .toList()
    //     .reversed) {
    //   if (cityBox.get(i)[StrConstants.isFavourite].toString().compareTo(
    //       StrConstants.yes) == 0) {
    //     updateItem(i, cityList[cityListIndex]);
    //     cityListIndex++;
    //   }
    // }
  }

  void updateRecent(List<Map<String, String>> cityList) {
    for (Map<String, String> cityData in cityList) {
      for (int key in cityBox.keys) {
        Map<dynamic, dynamic> city = cityBox.get(key);

        if (city[StrConstants.locKeys[0]].toString().toLowerCase().compareTo(
            cityData[StrConstants.locKeys[0]]!.toLowerCase()) == 0 && city[StrConstants.isFavourite].toString().compareTo(StrConstants.yes)!=0) {
          debugPrint("in update recents");
          updateItem(key, cityData);
        }
      }
    }

    // for (int i in cityBox.keys
    //     .toList()
    //     .reversed) {
    //   if (cityBox.get(i)[StrConstants.isFavourite].toString().compareTo(
    //       StrConstants.yes) != 0) {
    //     updateItem(i, cityList[cityListIndex]);
    //     cityListIndex++;
    //   }
    // }
  }

  Future<void> deleteItem(String cityName) async {
    debugPrint("Citybox keys length = ${cityBox.keys.length}");

    if (cityBox.keys.isNotEmpty) {

      for(int mainKey in cityBox.keys){
        Map<dynamic, dynamic> city = cityBox.get(mainKey);

        if(city[StrConstants.locKeys[0]].toString().toLowerCase().compareTo(cityName.toLowerCase())==0){
          //city[StrConstants.isFavourite].toString().compareTo(StrConstants.yes)==0

          debugPrint("In if of delete item");
          await cityBox.delete(mainKey);
        }
      }

      // for (Map<dynamic, dynamic> city in cityBox.values) {
      //   for (String key in city.keys) {
      //     debugPrint(city[key].toString());
      //     if (key.toString().compareTo(StrConstants.locKeys[0]) == 0 &&
      //         city[key].toString().toLowerCase().compareTo(
      //             cityName.toLowerCase()) == 0) {
      //       debugPrint("In if of delete item");
      //       await cityBox.delete(key);
      //     }
      //   }
      // }
    }
  }
}

/*
/ final data = cityBox.keys.map((key) {
    //   final value = cityBox.get(key);
    //   return value["is_favourite"] ? {
    //     "key": key,
    //     "name": value["name"],
    //     "quantity": value['quantity']
    //   }:{};
    // }).toList();
* for (var key in cityBox.keys) {
      final city = cityBox.get(key);
      if (city[StrConstants.isFavourite] == StrConstants.yes) {
        cityList.add({
          StrConstants.key: key,
          //name
          StrConstants.locKeys[0]: city[StrConstants.locKeys[0]],
          //region
          StrConstants.locKeys[1]: city[StrConstants.locKeys[0]],
          //country
          StrConstants.locKeys[2]: city[StrConstants.locKeys[2]],
          //temperature
          StrConstants.currentKeys[0]: city[StrConstants.currentKeys[0]],
          //is_day
          StrConstants.currentKeys[1]: city[StrConstants.currentKeys[1]],
          //condition
          StrConstants.currentKeys[2]: city[StrConstants.currentKeys[2]],
          //icon
          StrConstants.currentKeys[3]: city[StrConstants.currentKeys[3]],
          //wind_kph
          StrConstants.currentKeys[4]: city[StrConstants.currentKeys[4]],
          //pressure_mb
          StrConstants.currentKeys[5]: city[StrConstants.currentKeys[5]],
          //humidity
          StrConstants.currentKeys[6]: city[StrConstants.currentKeys[6]],
          //cloud
          StrConstants.currentKeys[7]: city[StrConstants.currentKeys[7]],
          //feelslike_c
          StrConstants.currentKeys[8]: city[StrConstants.currentKeys[8]],
          //uv index
          StrConstants.currentKeys[9]: city[StrConstants.currentKeys[9]]
        });
      }
    }*/
