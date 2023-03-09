import 'package:flutter/material.dart';

import '../constants/constant_widgets.dart';
import '../constants/nav_constants.dart';
import '../constants/str_constants.dart';
import '../model/database.dart';

class OldCityPage extends StatefulWidget {
  const OldCityPage({Key? key, required this.cityData}) : super(key: key);
  final Map<String, String> cityData;

  @override
  State<OldCityPage> createState() => _OldCityPageState(cityData: cityData);
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

    if (cityData[StrConstants.isFavourite]!.compareTo(StrConstants.yes) ==
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
                    child: getWeatherWidget(context, cityData, favIcon, size, heightPadding),
                  ),
                ),
        ),
      ),
    );
  }
}
