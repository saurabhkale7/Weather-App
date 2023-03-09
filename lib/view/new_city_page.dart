import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constant_widgets.dart';
import '../constants/nav_constants.dart';
import '../constants/str_constants.dart';
import '../model/database.dart';
import '../model/result.dart';
import '../state_management/weather_provider.dart';

class NewCityPage extends StatefulWidget {
  const NewCityPage({Key? key, required this.cityName}) : super(key: key);
  final String cityName;

  @override
  State<NewCityPage> createState() => _NewCityPageState(cityName: cityName);
}

class _NewCityPageState extends State<NewCityPage> {
  _NewCityPageState({required this.cityName});

  final String cityName;

  ValueNotifier<Icon> favIcon =
      ValueNotifier(const Icon(Icons.favorite_border));

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        Provider.of<MainCityDataProvider>(context, listen: false)
            .getCityWeatherData(cityName, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double widthPadding = size.width * 5 / 100;
    double heightPadding = size.height * 5 / 100;

    return SafeArea(
      child: Container(
        decoration: bgImage,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                // Provider.of<FavouriteCitiesProvider>(context, listen: false)
                //     .getFavouriteCities();
                // Provider.of<RecentCitiesProvider>(context, listen: false)
                //     .getRecentCities();
                // Navigator.of(context).pop();
                //Navigator.of(context).pushNamedAndRemoveUntil(NavConstants.cityListPage, ModalRoute);
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    NavConstants.cityListPage,
                    ModalRoute.withName(NavConstants.cityListPage));
              },
              icon: const Icon(Icons.arrow_back),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body:
              Consumer<MainCityDataProvider>(builder: (context, value, child) {
            if (value.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (value.weatherApiResponse.msg.compareTo(StrConstants.success) !=
                0) {
              Timer(const Duration(), () async {
                openDialog(
                    context,
                    Result(
                        msg: value.weatherApiResponse.msg,
                        desc: value.weatherApiResponse.desc
                                    .contains(StrConstants.statusCode) &&
                                value.weatherApiResponse.desc
                                    .endsWith(StrConstants.four100)
                            ? value.weatherApiResponse.desc +
                                StrConstants.noData
                            : value.weatherApiResponse.desc));
              });

              return Center(child: Text(StrConstants.noData, style: headerStyle,),);
            }
            else {
              Map<String, String> cityData = value.weatherApiResponse.data[0];
              CityWeatherDatabase.cityWeatherDBObj
                  .deleteItem(cityData[StrConstants.locKeys[0]]!);
              CityWeatherDatabase.cityWeatherDBObj.createItem(cityData);

              if (cityData[StrConstants.isFavourite]
                      ?.compareTo(StrConstants.yes) ==
                  0) {
                favIcon.value = Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: heightPadding,
                );
              } else {
                favIcon.value = Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                  size: heightPadding,
                );
              }

              return SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: widthPadding, right: widthPadding),
                  child: getWeatherWidget(context, cityData, favIcon, size, heightPadding),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
