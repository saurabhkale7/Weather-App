class StrConstants{
  static const String weatherApp="Weather App";
  static const String error = "Error";
  //static const String notGiven = "--Not given--";
  //static const String tab = "    ";
  static const String success = "Success";
  static const String tryAgain = "Something went wrong, please try again!\n";
  static const String statusCode = "Received response with status code ";
  //static const String space = " ";
  static const String emptyStr = "";
  static const String ok = "Ok";
  static const String noData = "\nNo data currently available for this location right now";
  static const String info = "Info";
  static const String clear = "Clear";
  static const String yes = "yes";
  static const String no = "no";
  static const String noInternet = "No internet connection!\n";
  static const String invalid = "Invalid uri string or incorrect format of the response\n";
  static const String serverTimeout = "Server timeout, please try again!\n";
  static const String favourites = "Favourites";
  static const String recent = "Recent";
  static const String conWithInternet = "Connect with the internet for updated data!";
  static const String noFavCities = "No favourite cities are there!";
  static const String noRecentCities = "No recent cities are there!";
  static const String couldNotFetch = "Couldn't fetch required data!";
  static const String addCity = "Add City";
  static const String provideData = "Please select at least a country to continue!";
  static const String googleWebPage = "google.com";
  static const String four100 = "400";

  static const String location = "location";
  static const String current = "current";
  static const List<String> locKeys = ["name", "region", "country"];
  static const List<String> currentKeys = ["temp_c", "is_day", "condition", "icon", "wind_kph", "pressure_mb", "humidity", "cloud", "feelslike_c", "uv"];
  static const String text = "text";
  static const String isFavourite = "is_favourite";
  static const String cities = "cities";
  //static const String key = "key";
  static const String degCelsius = "℃";
  static const String kph = " km/h";
  static const String mbar = " mbar";
  static const String percentage = "%";
  static const String separator = " | ";
  static const String windSpeed = "Wind speed";
  static const String pressure = "Pressure";
  static const String realFeel = "Real feel";
  static const String humidity = "Humidity";
  static const String chancesOfRain = "Chances of rain";
  static const String uv = "UV index";

  static const String bgImage = "assets/images/weatherbgimage.jpg";

  static const String getWeatherAtMyLocation = "Get weather at my location";
  static const String loc = "Location";
  static const String locPerm = "Location Permission";
  static const String givePerm = "Give permission to access the location to continue!";
  static const String locPermDeny = "Location permissions are permanently denied, we cannot request permissions.\nTo access this feature, go to app settings => permissions => location";
  static const String turnOnLoc= "Please turn on the location of your device!";
  static const String connectWithInternet= "Connect with the internet to get weather data at your location!";

  static const String internet = "Internet";
  static const String pressAgain = "Press again to exit!";

  static const String cloud = "cloud";
  static const String overcast = "overcast";
  static const String fog = "fog";
  static const String rain = "rain";
  static const String snow = "snow";
  static const String sun = "sun";
  static const String thunder = "thunder";
  static const String light = "light";

  static const List<String> images = <String>[
    "assets/gifs/clouds.gif",
    "assets/gifs/foggy.gif",
    "assets/gifs/rainy.gif",
    "assets/gifs/snowflake.gif",
    "assets/gifs/sun.gif",
    "assets/gifs/thunder.gif",
    "assets/gifs/wind.gif",
    "assets/gifs/splash_screen.gif",
  ];
}