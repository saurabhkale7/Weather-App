import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/constants/constant_widgets.dart';
import 'package:weatherapp/constants/nav_constants.dart';
import 'package:weatherapp/constants/str_constants.dart';
import 'package:weatherapp/model/database.dart';
import 'package:weatherapp/model/result.dart';
import 'package:weatherapp/state_management/weather_provider.dart';

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
      Provider.of<MainCityDataProvider>(context, listen: false)
          .getCityWeatherData(cityName, true);
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
                Navigator.pushNamedAndRemoveUntil(context, NavConstants.cityListPage, ModalRoute.withName(NavConstants.cityListPage));
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
              openDialog(
                  context,
                  Result(
                      msg: value.weatherApiResponse.msg,
                      desc: value.weatherApiResponse.desc));
              Navigator.of(context).pop();
              return const SizedBox();
            }

            Map<String, String> cityData = value.weatherApiResponse.data[0];
            CityWeatherDatabase.cityWeatherDBObj
                .deleteItem(cityData[StrConstants.locKeys[0]]!);
            CityWeatherDatabase.cityWeatherDBObj.createItem(cityData);

            if (cityData[StrConstants.isFavourite]!
                    .compareTo(StrConstants.yes) ==
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          cityData[StrConstants.locKeys[0]]!,
                          style: titleWhiteFontStyle,
                        )),
                        ValueListenableBuilder(
                            valueListenable: favIcon,
                            builder: (context, value, widget) {
                              return IconButton(
                                  onPressed: () {
                                    debugPrint("in onpressed");
                                    if (value.icon == Icons.favorite_border) {
                                      debugPrint("in fav border");
                                      favIcon.value = Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: heightPadding,
                                      );
                                      CityWeatherDatabase.cityWeatherDBObj
                                          .deleteItem(cityData[
                                              StrConstants.locKeys[0]]!);
                                      cityData[StrConstants.isFavourite] =
                                          StrConstants.yes;
                                      CityWeatherDatabase.cityWeatherDBObj
                                          .createItem(cityData);
                                    } else {
                                      debugPrint("in fav");
                                      favIcon.value = Icon(
                                        Icons.favorite_border,
                                        color: Colors.red,
                                        size: heightPadding,
                                      );
                                      CityWeatherDatabase.cityWeatherDBObj
                                          .deleteItem(cityData[
                                              StrConstants.locKeys[0]]!);
                                      cityData[StrConstants.isFavourite] =
                                          StrConstants.no;
                                      CityWeatherDatabase.cityWeatherDBObj
                                          .createItem(cityData);
                                    }
                                  },
                                  icon: value
                              );
                            }),
                      ],
                    ),
                    Text(
                      cityData[StrConstants.locKeys[1]]! +
                          StrConstants.separator +
                          cityData[StrConstants.locKeys[2]]!,
                      style: regionCountryFontStyle,
                    ),
                    sizedBoxH20,

                    Text(
                      cityData[StrConstants.currentKeys[2]]! +
                          StrConstants.separator +
                          cityData[StrConstants.currentKeys[0]]! +
                          StrConstants.degCelsius,
                      style: tempFontStyle,
                    ),
                    sizedBoxH20,

                    getImage(context, cityData[StrConstants.currentKeys[2]]!),
                    sizedBoxH20,

                    //GridView.extent(maxCrossAxisExtent: maxCrossAxisExtent)

                    Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Center(
                                  child: Text(
                                    StrConstants.realFeel,
                                    style: headerStyle,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Center(
                                  child: Text(
                                    cityData[StrConstants.currentKeys[8]]! +
                                        StrConstants.degCelsius,
                                    style: contentStyle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: size.width * 30 / 100,
                        ),
                        Column(
                          children: [
                            Center(
                              child: Text(
                                StrConstants.humidity,
                                style: headerStyle,
                              ),
                            ),
                            Center(
                              child: Text(
                                  cityData[StrConstants.currentKeys[6]]! +
                                      StrConstants.percentage,
                                  style: contentStyle),
                            ),
                          ],
                        )
                      ],
                    ),
                    sizedBoxH20,

                    Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Center(
                                  child: Text(
                                    StrConstants.chancesOfRain,
                                    style: headerStyle,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Center(
                                  child: Text(
                                    cityData[StrConstants.currentKeys[7]]! +
                                        StrConstants.percentage,
                                    style: contentStyle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: size.width * 10 / 100,
                        ),
                        Column(
                          children: [
                            Center(
                              child: Text(
                                StrConstants.pressure,
                                style: headerStyle,
                              ),
                            ),
                            Center(
                              child: Text(
                                  cityData[StrConstants.currentKeys[5]]! +
                                      StrConstants.mbar,
                                  style: contentStyle),
                            ),
                          ],
                        )
                      ],
                    ),
                    sizedBoxH20,

                    Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Center(
                                  child: Text(
                                    StrConstants.windSpeed,
                                    style: headerStyle,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Center(
                                  child: Text(
                                    cityData[StrConstants.currentKeys[4]]! +
                                        StrConstants.kph,
                                    style: contentStyle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: size.width * 20 / 100,
                        ),
                        Column(
                          children: [
                            Center(
                              child: Text(
                                StrConstants.uv,
                                style: headerStyle,
                              ),
                            ),
                            Center(
                              child: Text(
                                  cityData[StrConstants.currentKeys[9]]!,
                                  style: contentStyle),
                            ),
                          ],
                        )
                      ],
                    ),
                    sizedBoxH20,
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
