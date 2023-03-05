class APIConstants{
  static const String url="https://weatherapi-com.p.rapidapi.com/forecast.json?q=";
  static const String days1="&days=1";
  static const String days5="&days=5";
  static const String xRapidAPIKey="X-RapidAPI-Key";
  static const String xRapidAPIKeyValue="215be57e5dmsh53f2cf44f5df368p104772jsn04bf92b6f505";
  static const String xRapidAPIHost="X-RapidAPI-Host";
  static const String xRapidAPIHostValue="weatherapi-com.p.rapidapi.com";

  static const Map<String, String> headers={
    xRapidAPIKey: xRapidAPIKeyValue,
    xRapidAPIHost: xRapidAPIHostValue
  };
}