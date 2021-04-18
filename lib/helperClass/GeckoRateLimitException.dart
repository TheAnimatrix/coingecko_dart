
class GeckoRateLimitException implements Exception{
  static const int GECKO_REQ_PER_MINUTE = 100;
  String errorMessage = "";

  GeckoRateLimitException() {
    errorMessage = "CoinGecko_Dart : 100 Requests/Minute Exceeded!!";
  }

  @override
  String toString() {
    return errorMessage;
  }
}
