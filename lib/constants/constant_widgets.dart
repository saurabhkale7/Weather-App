import 'package:flutter/material.dart';
import 'nav_constants.dart';
import 'str_constants.dart';

import '../model/database.dart';
import '../model/result.dart';
import 'font_constants.dart';

TextStyle titleWhiteFontStyle = const TextStyle(
    fontFamily: FontConstants.raleway,
    color: Colors.white,
    fontSize: 32,
    fontWeight: FontWeight.bold);

TextStyle titleBlackFontStyle = const TextStyle(
    fontFamily: FontConstants.raleway,
    color: Colors.black,
    fontSize: 28,
    fontWeight: FontWeight.bold);

TextStyle regionCountryFontStyle = const TextStyle(
    fontFamily: FontConstants.raleway,
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold);

TextStyle noDataFontStyle = const TextStyle(
    fontFamily: FontConstants.junge,
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold);

TextStyle snackBarStyle = const TextStyle(
    fontFamily: FontConstants.raleway,
    color: Colors.black,
    fontSize: 22,
    fontWeight: FontWeight.bold);

TextStyle alertTitleStyle = const TextStyle(
  fontSize: 32,
  fontFamily: FontConstants.raleway,
);

TextStyle alertContentStyle =
    const TextStyle(fontFamily: FontConstants.junge, fontSize: 20);

TextStyle headerStyle = const TextStyle(
    fontFamily: FontConstants.raleway,
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold);

TextStyle contentStyle = const TextStyle(
    fontFamily: FontConstants.junge, fontSize: 20, color: Colors.white);

TextStyle tempFontStyle = const TextStyle(
    fontFamily: FontConstants.junge, fontSize: 24, color: Colors.white);

EdgeInsets commonPadding = const EdgeInsets.fromLTRB(20, 8, 20, 8);

VisualDensity commonVisualDensity = const VisualDensity(vertical: 2);

MaterialStatePropertyAll<RoundedRectangleBorder> commonShape =
    MaterialStatePropertyAll(
  RoundedRectangleBorder(
      side: const BorderSide(color: Colors.transparent, width: 10),
      borderRadius: BorderRadius.circular(10)),
);

BoxDecoration bgImage = const BoxDecoration(
    image: DecorationImage(
  fit: BoxFit.cover,
  image: AssetImage(StrConstants.bgImage),
));

Divider commonDivider = const Divider(
  height: 5,
  color: Colors.cyan,
);

Color commonBackgroundColor = const Color(0xFFE6E6FA);

RoundedRectangleBorder roundRectBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
  side: const BorderSide(
    color: Colors.cyan,
  ),
);

SizedBox sizedBoxH10 = const SizedBox(
  height: 10,
);

SizedBox sizedBoxH20 = const SizedBox(
  height: 20,
);

Future<void> openDialog(BuildContext context, Result r) async{
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            r.msg,
            style: alertTitleStyle,
          ),
          content: Text(
            r.desc,
            style: alertContentStyle,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(StrConstants.ok)),
          ],
        );
      });
}

TextStyle tileTitleStyle = const TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.white,
  fontSize: 28,
  fontFamily: FontConstants.raleway,
);

TextStyle tileSubtitleStyle = contentStyle;

Padding getListTile(BuildContext context, Map<String, String> locData) {
  return Padding(
    padding: const EdgeInsets.only(top: 5, bottom: 5),
    child: ListTile(
      //name of location
      title: Text(
        locData[StrConstants.locKeys[0]]!,
        style: tileTitleStyle,
      ),
      subtitle: Text(
        locData[StrConstants.currentKeys[2]]! +
            StrConstants.separator +
            locData[StrConstants.currentKeys[0]]! +
            StrConstants.degCelsius,
        style: tileSubtitleStyle,
      ),
      contentPadding: commonPadding,
      visualDensity: commonVisualDensity,
      shape: roundRectBorder,
      tileColor: Colors.transparent,
      onTap: () {
        Navigator.of(context)
            .pushNamed(NavConstants.oldCityPage, arguments: locData);
      },
    ),
  );
}

ListView getListView(List<Map<String, String>> cityList) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: cityList.length,
      itemBuilder: (context, i) {
        return getListTile(context, cityList[i]);
      });
}

Center getImage(context, String condition1) {
  String condition = condition1.toLowerCase();
  double width = MediaQuery.of(context).size.width * 40 / 100;
  double height = MediaQuery.of(context).size.height * 40 / 100;

  if (condition.contains(StrConstants.cloud) ||
      condition.contains(StrConstants.overcast)) {
    return Center(
      child: Image.asset(
        StrConstants.images[0],
        width: width,
        height: height,
      ),
    );
  } else if (condition.contains(StrConstants.fog)) {
    return Center(
      child: Image.asset(
        StrConstants.images[1],
        width: width,
        height: height,
      ),
    );
  } else if (condition.contains(StrConstants.rain)) {
    return Center(
      child: Image.asset(
        StrConstants.images[2],
        width: width,
        height: height,
      ),
    );
  } else if (condition.contains(StrConstants.snow)) {
    return Center(
      child: Image.asset(
        StrConstants.images[3],
        width: width,
        height: height,
      ),
    );
  } else if (condition.contains(StrConstants.sun)) {
    return Center(
      child: Image.asset(
        StrConstants.images[4],
        width: width,
        height: height,
      ),
    );
  } else if (condition.contains(StrConstants.thunder) ||
      condition.contains(StrConstants.light)) {
    return Center(
      child: Image.asset(
        StrConstants.images[5],
        width: width,
        height: height,
      ),
    );
  } else {
    return Center(
      child: Image.asset(
        StrConstants.images[6],
        width: width,
        height: height,
      ),
    );
  }
}

Column getWeatherWidget(BuildContext context, final Map<String, String> cityData, ValueNotifier<Icon> favIcon, Size size, double heightPadding){
  return Column(
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
                    icon: value);
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
  );
}