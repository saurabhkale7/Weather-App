import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/constants/str_constants.dart';

import '../constants/constant_widgets.dart';
import '../model/api_reponse.dart';
import '../model/result.dart';

Future<bool> isDeviceWithInternet() async {
  bool activeConnection = false;

  try {
    final List<InternetAddress> result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      activeConnection = true;
    }
  } on SocketException catch (_) {
      activeConnection = false;
  }

  return activeConnection;
}

Future<Result> determinePosition() async {
  Position? currentPosition;
  bool serviceEnabled;
  LocationPermission permission;

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return const Result(
          msg : StrConstants.locPerm,
          desc : StrConstants.givePerm);
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return const Result(
        msg : StrConstants.locPerm,
        desc : StrConstants.locPermDeny);
  }

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return const Result(
        msg : StrConstants.loc, desc : StrConstants.turnOnLoc);
  }

  if(!await isDeviceWithInternet()){
    return const Result(
        msg : StrConstants.internet, desc : StrConstants.connectWithInternet);
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  // await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //     .then((value) {
  //   _currentPosition = value;
  // });

  currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

  return Result(
      msg : StrConstants.success,
      desc : "${currentPosition.latitude},${currentPosition.longitude}");
}

Widget getActualData(BuildContext context, APIResponse citiesResponse){
  if (citiesResponse.msg
      .compareTo(StrConstants.info) ==
      0) {
    if (citiesResponse.data.isEmpty) {
      return Row(
        children: [
          Expanded(
              child: Center(
                child: Text(
                  StrConstants.noFavCities,
                  style: noDataFontStyle,
                ),
              )),
        ],
      );
    }

    //when data is not empty but internet connection is not there
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Align(
    //     alignment: Alignment.topRight,
    //     child: Text(
    //       StrConstants.conWithInternet,
    //       style: snackBarStyle,
    //     ),
    //   ),
    //   backgroundColor: Colors.white,
    //   duration: const Duration(seconds: 4),
    // ));

    WidgetsBinding.instance.addPostFrameCallback((_){
      openDialog(context, Result(msg: citiesResponse.desc, desc: StrConstants.conWithInternet));
    });

    return getListView(citiesResponse.data);
  }

  else if(citiesResponse.msg
      .compareTo(StrConstants.success)!=0){
    openDialog(context, Result(msg: citiesResponse.msg, desc: citiesResponse.desc));
    return Row(
      children: [
        Expanded(
            child: Center(
              child: Text(
                StrConstants.couldNotFetch,
                style: noDataFontStyle,
              ),
            )),
      ],
    );
  }

  else{
    return getListView(citiesResponse.data);
  }
}