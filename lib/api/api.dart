import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:weatherapp/constants/api_constants.dart';
import 'package:weatherapp/constants/str_constants.dart';
import 'package:weatherapp/model/api_reponse.dart';
import 'package:http/http.dart' as http;

class API {
  //getFav
  static API apiObj = API();

  ///return only required data from body in the form of map
  Map<String, String> getData(final Map<String, dynamic> weatherDataResponseBody) {
    Map<String, String> cityData = {};

    //get geographical data of the location
    Map<String, dynamic> location;
    location = weatherDataResponseBody[StrConstants.location] as Map<String, dynamic>;

    for (String s in StrConstants.locKeys) {
      cityData[s] = location[s] ?? StrConstants.emptyStr;
    }

    //get today's and current hour's data of the location
    Map<String, dynamic> current;
    current = weatherDataResponseBody[StrConstants.current] as Map<String, dynamic>;

    for (String s in StrConstants.currentKeys) {
      if (s.compareTo(StrConstants.currentKeys[2]) == 0) {
        cityData[s] = (current[s] as Map<String, dynamic>)[StrConstants.text] ??
            StrConstants.clear;
      } else if (s.compareTo(StrConstants.currentKeys[3]) == 0) {
        cityData[s] = current[s] ?? StrConstants.emptyStr;
      } else {
        cityData[s] = (current[s] as num).toString();
      }
    }

    return cityData;
  }


  /// Function to get weather data of a location
  /// It fetches data and sends it to the calling method
  /// if any error occurs or receives empty data then it sends corresponding
  /// message to the calling method
  Future<APIResponse> getWeatherAt(final li) async {
    String location=li[0];
    bool daysEqualTo1=li[1];

    //create url to get weather data of a particular location
    //and for today or for next five days(including today)
    final String weatherAPIUrl = daysEqualTo1
        ? APIConstants.url + location + APIConstants.days1
        : APIConstants.url + location + APIConstants.days5;

    try {
      //parse weather api url
      final Uri weatherAPIURI = Uri.parse(weatherAPIUrl);

      //request api with the help of headers and get response
      final http.Response weatherDataResponse =
          await http.get(weatherAPIURI, headers: APIConstants.headers);

      //check if everything is ok
      if (weatherDataResponse.statusCode == 200) {
        //fetch body of the response received
        final Map<String, dynamic> weatherDataResponseBody =
            jsonDecode(weatherDataResponse.body.toString()) as Map<String, dynamic>;

        //check whether body is empty
        if (weatherDataResponseBody.isEmpty) {
          return APIResponse(
              msg: StrConstants.info,
              desc: StrConstants.noData,
              data: []);
        }

        //if body has data
        //get only required data from body in the form of map
        Map<String, String> cityData = getData(weatherDataResponseBody);

        //return weather data
        return APIResponse(
            msg: StrConstants.success,
            desc: StrConstants.emptyStr,
            data: [cityData]);

        //final v = dict["location"] as Map<String, dynamic>;
        //final v1 = v["region"] as String;
        //debugPrint(v1);
      } else {

        //if status code is not 200
        //means if we didn't receive data that we want
        return APIResponse(
            msg: StrConstants.error,
            desc: StrConstants.tryAgain +
                StrConstants.statusCode +
                weatherDataResponse.statusCode.toString(),
            data: [{}]);
      }
    }
    on FormatException catch(e){
      return APIResponse(
          msg: StrConstants.error,
          desc: StrConstants.invalid +e.toString(),
          data: [{}]);
    }on SocketException catch(e){
      return APIResponse(
          msg: StrConstants.error,
          desc: StrConstants.noInternet + e.toString(),
          data: [{}]);
    }on TimeoutException catch(e){
      return APIResponse(
          msg: StrConstants.error,
          desc: StrConstants.serverTimeout + e.toString(),
          data: [{}]);
    }
    catch (e) {
      return APIResponse(
          msg: StrConstants.error,
          desc: StrConstants.tryAgain + e.toString(),
          data: [{}]);
    }
  }
}
