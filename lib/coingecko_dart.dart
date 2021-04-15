library coingecko_dart;

import 'package:dio/dio.dart';

import 'dataClasses/Coin.dart';

/**
 * unused for now
 */
class CGHttpResponse {
  var statusCode,
      statusMessage,
      data,
      raw /* raw is response.toString() */,
      headers,
      isRedirect,
      redirects,
      requestOptions;

  CGHttpResponse.fromDioResponse(Response response) {
    this.statusCode = response.statusCode;
    this.statusMessage = response.statusMessage;
    this.data = response.data;
    this.headers = response.headers;
    this.isRedirect = response.isRedirect;
    this.redirects = response.redirects;
    this.requestOptions = response.requestOptions;
  }
}

const int RESPONSE_INIT_CODE = -1;

///When a response is observed with statusCode = -1 then it's essentially saying "this is just an initialized response"
class CoinGeckoResult {
  Response _httpResponse = Response(
      statusCode: RESPONSE_INIT_CODE, requestOptions: RequestOptions(path: ""));
  List<Coin> coinList = [];
  CoinGeckoResult(Response httpResponse) {
    this._httpResponse = httpResponse;
  }

  bool get isSuccess => _httpResponse.statusCode == 200;
  bool get isUsed => _httpResponse.statusCode != RESPONSE_INIT_CODE;
  Response get httpResponse => _httpResponse;
}

class CoinGeckoApi {
  Dio? dio;

  ///KONO DIO DAA *cough* *cough*... JOJO REFERENCE *cough* *cough*
  CoinGeckoResult progressiveResult = CoinGeckoResult(Response(
      statusCode: RESPONSE_INIT_CODE,
      requestOptions: RequestOptions(path: "")));

  /**
   * ***Init() Initialize API***
   * 
   * used to initialize the http client
   * * [connectTimeout] specified in ms controls how long before connection request is timed out
   * * [receiveTimeout] specified in ms controls how long before server sends response once request is accepted
   */
  static CoinGeckoApi init(
      {int connectTimeout = 5000, int receiveTimeout = 10000}) {
    return CoinGeckoApi(
        connectTimeout: connectTimeout, receiveTimeout: receiveTimeout);
  }

  CoinGeckoApi({int connectTimeout = 5000, int receiveTimeout = 10000}) {
    var options = BaseOptions(
      baseUrl: 'http://api.coingecko.com/api/v3',
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );
    dio = Dio(options);
  }

  /**
   * * Coingecko API ( **GET** /ping )
   * 
   * used to check Coingecko Server API status
   */
  Future<CoinGeckoResult> ping() async {
    Response response = await dio!
        .get("/ping", options: Options(contentType: 'application/json'));
    progressiveResult = CoinGeckoResult(response);
    return progressiveResult;
  }

  // ! SIMPLE

  // ! COINS

  // ? /coins/list

  Future<CoinGeckoResult> listCoins({bool includePlatformFlag = false}) async {
    Response response = await dio!.get("/coins/list",
        queryParameters: {"include_platform": includePlatformFlag},
        options: Options(contentType: 'application/json'));
    progressiveResult = CoinGeckoResult(response);
    _updateCoinListFromResponse();
    return progressiveResult;
  }


  //contract
  //exchanges(beta)
  //events
  //exchange rates
  //trending
  //global


  //helpers
  // ? for /coin/list
  void _updateCoinListFromResponse() {
    if (progressiveResult.httpResponse.statusCode == 200) {
      List<dynamic> coinListJson = progressiveResult.httpResponse.data;
      List<Coin> newCoinList = [];
      for (dynamic coinJson in coinListJson) {
        newCoinList.add(Coin.fromJson(coinJson));
      }
      progressiveResult.coinList = newCoinList;
    } else {
      //do nothing?
    }
  }


}
