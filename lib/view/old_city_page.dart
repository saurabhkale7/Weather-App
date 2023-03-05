import 'package:flutter/material.dart';

import '../constants/constant_widgets.dart';
import '../constants/nav_constants.dart';
import '../constants/str_constants.dart';
import '../model/database.dart';

class OldCityPage extends StatefulWidget {
  const OldCityPage({Key? key, required this.city}) : super(key: key);
  final Map<String, String> city;

  @override
  State<OldCityPage> createState() => _OldCityPageState(cityData: city);
}

class _OldCityPageState extends State<OldCityPage> {
  _OldCityPageState({required this.cityData});

  final Map<String, String> cityData;

  ValueNotifier<Icon> favIcon =
  ValueNotifier(const Icon(Icons.favorite_border));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double widthPadding = size.width * 5 / 100;
    double heightPadding = size.height * 5 / 100;


    CityWeatherDatabase.cityWeatherDBObj
        .deleteItem(cityData[StrConstants.locKeys[0]]!);
    CityWeatherDatabase.cityWeatherDBObj.createItem(cityData);

    if (cityData[StrConstants.isFavourite]?.compareTo(StrConstants.yes) ==
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
        size: MediaQuery.of(context).size.height,
      );
    }

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
          body: SingleChildScrollView(
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
                                        //debugPrint("in onpressed");
                                        if (value.icon == Icons.favorite_border) {
                                          //debugPrint("in fav border");
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
                                          //debugPrint("in fav");
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
                ),
        ),
      ),
    );
  }
}
