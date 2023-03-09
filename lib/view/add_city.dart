import 'package:flutter/material.dart';
import '../constants/constant_widgets.dart';
import '../constants/nav_constants.dart';
import '../constants/str_constants.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import '../controller/methods.dart';
import '../model/result.dart';

class AddCity extends StatefulWidget {
  const AddCity({Key? key}) : super(key: key);

  @override
  State<AddCity> createState() => _AddCityState();
}

class _AddCityState extends State<AddCity> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: commonBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          StrConstants.addCity,
          style: titleBlackFontStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 600,
          child: Column(
            children: [
              SelectState(
                // style: TextStyle(color: Colors.red),
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                    stateValue = "";
                    cityValue = "";
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value;
                    cityValue = "";
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value;
                  });
                },
              ),
              // InkWell(
              //   onTap:(){
              //     print('country selected is $countryValue');
              //     print('country selected is $stateValue');
              //     print('country selected is $cityValue');
              //   },
              //   child: Text(' Check')
              // )
            ],
          )),
      floatingActionButton: TextButton(
        //backgroundColor: Colors.white,
        style: ButtonStyle(
          elevation: MaterialStatePropertyAll(10),
          backgroundColor: const MaterialStatePropertyAll(Colors.blue),
          shape: commonShape,
          //elevation: MaterialStatePropertyAll(50),
        ),
        child: Text(StrConstants.addCity, style: headerStyle),
        onPressed: () async {
          if (countryValue.isEmpty) {
            openDialog(
                context,
                const Result(
                    msg: StrConstants.info, desc: StrConstants.provideData));
            return;
          }

          if (!await isDeviceWithInternet()) {
            (() => openDialog(
                context,
                const Result(
                    msg: StrConstants.internet,
                    desc: StrConstants.noInternet)))();

            return;
          }

          () {
            Navigator.of(context).pushReplacementNamed(NavConstants.newCityPage,
                arguments: cityValue.isEmpty
                    ? (stateValue.isEmpty ? countryValue : stateValue)
                    : cityValue);
          }();
        },
      ),
    );
  }
}
