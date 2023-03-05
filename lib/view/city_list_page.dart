import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/constants/constant_widgets.dart';
import 'package:weatherapp/constants/nav_constants.dart';
import 'package:weatherapp/constants/str_constants.dart';
import 'package:weatherapp/controller/methods.dart';
import 'package:weatherapp/model/result.dart';
import 'package:weatherapp/state_management/weather_provider.dart';

import '../model/database.dart';

class CityList extends StatefulWidget {
  const CityList({Key? key}) : super(key: key);

  @override
  State<CityList> createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  ValueNotifier<bool> hasCalledProvider = ValueNotifier(false);

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<FavouriteCitiesProvider>(context, listen: false)
          .getFavouriteCities();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<RecentCitiesProvider>(context, listen: false)
          .getRecentCities();
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    double widthPadding = size.width * 5 / 100;
    double heightPadding = size.height * 5 / 100;
    return SafeArea(
      child: Container(
        decoration: bgImage,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(NavConstants.addCityPage);
              },
            ),
            //title: Text(DateTime.now().toLocal().toString(), style: TextStyle(fontFamily: FontConstants.roboto, fontSize: 24, fontWeight: FontWeight.bold),),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: () {
                return Future.delayed(
                  const Duration(seconds: 1),
                      () {
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          Provider.of<FavouriteCitiesProvider>(context, listen: false)
                              .getFavouriteCities();
                        });
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          Provider.of<RecentCitiesProvider>(context, listen: false)
                              .getRecentCities();
                        });
                        hasCalledProvider.value=false;
                        setState(() {});
                      },
                );
            },

            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: widthPadding, right: widthPadding),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //data of location
                    ValueListenableBuilder(
                        valueListenable: hasCalledProvider,
                        builder:
                            (BuildContext context1, bool value, Widget? child) {
                          return !value
                              ? const SizedBox()
                              : Consumer<LocationDataProvider>(
                              builder: (context1, value, child) {
                                if (value.isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (value.weatherApiResponse.msg
                                    .compareTo(StrConstants.success) !=
                                    0) {
                                  openDialog(
                                      context,
                                      Result(
                                          msg: value.weatherApiResponse.msg,
                                          desc: value.weatherApiResponse.desc));
                                  return const SizedBox();
                                }

                                Map<String, String> locData =
                                value.weatherApiResponse.data[0];

                                CityWeatherDatabase.cityWeatherDBObj.deleteItem(locData[StrConstants.locKeys[0]]!);
                                locData[StrConstants.isFavourite]=StrConstants.no;
                                CityWeatherDatabase.cityWeatherDBObj.createItem(locData);

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      StrConstants.loc,
                                      style: titleWhiteFontStyle,
                                    ),
                                    commonDivider,
                                    sizedBoxH10,
                                    getListTile(context, locData),
                                  ],
                                );
                              });
                        }),
                    sizedBoxH20,

                    //data of favourite cities
                    Text(
                      StrConstants.favourites,
                      style: titleWhiteFontStyle,
                    ),
                    commonDivider,
                    sizedBoxH10,
                    Consumer<FavouriteCitiesProvider>(
                        builder: (context, value, child) {
                          if (value.areFavouriteCitiesLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return getActualData(context, value.favouriteCitiesResponse);

                        }),
                    sizedBoxH20,

                    Text(
                      StrConstants.recent,
                      style: titleWhiteFontStyle,
                    ),
                    commonDivider,
                    sizedBoxH10,
                    Consumer<RecentCitiesProvider>(
                        builder: (context, value, child) {
                          if (value.areRecentCitiesLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return getActualData(context, value.recentCitiesResponse);

                        }),
                    sizedBoxH20,
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: TextButton(
            //backgroundColor: Colors.white,
            style: ButtonStyle(
              backgroundColor: const MaterialStatePropertyAll(Colors.white),
              shape: commonShape,
              //elevation: MaterialStatePropertyAll(50),
            ),
            child: Text(StrConstants.getWeatherAtMyLocation, style: titleBlackFontStyle),
            onPressed: () async {
              Result locResult = await determinePosition();

              if (locResult.msg.compareTo(StrConstants.success) != 0) {
                openDialog(context, locResult);
                return;
              }

              hasCalledProvider.value = true;

              //when we have permission, location and internet
              Provider.of<LocationDataProvider>(context, listen: false)
                  .getLocationWeatherData(locResult.desc, true);
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}