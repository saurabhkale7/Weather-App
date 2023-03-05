import 'package:flutter/material.dart';
import 'package:weatherapp/constants/nav_constants.dart';
import 'package:weatherapp/constants/str_constants.dart';

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

void openDialog(BuildContext context, Result r) async {
  showDialog(
      context: context,
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
                onPressed: () => Navigator.of(context).pop(),
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

TextStyle tileSubtitleStyle = const TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontFamily: FontConstants.junge,
);

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
      onTap: (){
        Navigator.of(context).pushNamed(NavConstants.oldCityPage, arguments: locData);
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
  String condition=condition1.toLowerCase();

  if (condition.contains("cloud") || condition.contains("overcast")) {
    return Center(
      child: Image.asset(
        StrConstants.images[0],
        width: MediaQuery.of(context).size.width * 40 / 100,
        height: MediaQuery.of(context).size.height * 40 / 100,
      ),
    );
  } else if (condition.contains("fog")) {
    return Center(
      child: Image.asset(
        StrConstants.images[1],
        width: MediaQuery.of(context).size.width * 40 / 100,
        height: MediaQuery.of(context).size.height * 40 / 100,
      ),
    );
  } else if (condition.contains("rain")) {
    return Center(
      child: Image.asset(
        StrConstants.images[2],
        width: MediaQuery.of(context).size.width * 40 / 100,
        height: MediaQuery.of(context).size.height * 40 / 100,
      ),
    );
  } else if (condition.contains("snow")) {
    return Center(
      child: Image.asset(
        StrConstants.images[3],
        width: MediaQuery.of(context).size.width * 40 / 100,
        height: MediaQuery.of(context).size.height * 40 / 100,
      ),
    );
  } else if (condition.contains("sun")) {
    return Center(
      child: Image.asset(
        StrConstants.images[4],
        width: MediaQuery.of(context).size.width * 40 / 100,
        height: MediaQuery.of(context).size.height * 40 / 100,
      ),
    );
  } else if (condition.contains("thunder") || condition.contains("light")) {
    return Center(
      child: Image.asset(
        StrConstants.images[5],
        width: MediaQuery.of(context).size.width * 40 / 100,
        height: MediaQuery.of(context).size.height * 40 / 100,
      ),
    );
  } else {
    return Center(
      child: Image.asset(
        StrConstants.images[6],
        width: MediaQuery.of(context).size.width * 40 / 100,
        height: MediaQuery.of(context).size.height * 40 / 100,
      ),
    );
  }
}
