library coingecko_dart;

import 'package:coingecko_dart/dataClasses/SimpleToken.dart';
import 'package:dio/dio.dart';

import 'dataClasses/Coin.dart';
import 'dataClasses/PricedCoin.dart';

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

class CoinGeckoResult<E> {
  bool isError = false;
  String errorMessage = "n/a";
  int errorCode = -1;
  E data;

  CoinGeckoResult(this.data,
      {bool isError = false, String errorMessage = "n/a", int errorCode = -1}) {
    this.isError = isError;
    this.errorCode = errorCode;
    this.errorMessage = errorMessage;
  }

  @override
  String toString() {
    return !isError
        ? "Success: $data"
        : "Error: $errorCode: $errorMessage, $data";
  }
}

class CoinGeckoApi {
  Dio? dio;

  /**
   * ***Init() Initialize API***
   * 
   * used to initialize the http client
   * * [connectTimeout] specified in ms controls how long before connection request is timed out
   * * [receiveTimeout] specified in ms controls how long before server sends response once request is accepted
   */

  CoinGeckoApi({int connectTimeout = 10000, int receiveTimeout = 10000}) {
    var options = BaseOptions(
        baseUrl: 'http://api.coingecko.com/api/v3',
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        responseType: ResponseType.json);
    dio = Dio(options);
  }

  /**
   * * Coingecko API ( **GET** /ping )
   * 
   * used to check Coingecko Server API status
   */
  Future<bool> ping() async {
    Response response = await dio!
        .get("/ping", options: Options(contentType: 'application/json'));
    return response.statusCode == 200;
  }

  // ! SIMPLE

  // ? /simple/price
  Future<CoinGeckoResult<List<PricedCoin>>> simplePrice(
      {required List<String> ids,
      required List<String> vs_currencies,
      bool includeMarketCap = false,
      bool include24hVol = false,
      bool include24hChange = false,
      bool includeLastUpdatedAt = false}) async {
    Response response = await dio!.get('/simple/price', queryParameters: {
      "ids": ids.join(','),
      "vs_currencies": vs_currencies.join(','),
      "include_market_cap": includeMarketCap,
      "include_24hr_vol": include24hVol,
      "include_24hr_change": include24hChange,
      "include_last_updated_at": includeLastUpdatedAt
    });

    if (response.statusCode == 200) {
      List<PricedCoin> newCoinList = [];
      List<String> coinIds =
          (response.data as Map<String, dynamic>).keys.toList();
      for (String id in coinIds) {
        PricedCoin pricedCoin =
            PricedCoin.fromJson(Coin(id: id), response.data[id]);
        newCoinList.add(pricedCoin);
      }
      return CoinGeckoResult(newCoinList);
    } else {
      return CoinGeckoResult([],
          errorMessage: response.data,
          errorCode: response.statusCode ?? -1,
          isError: true);
    }
  }

  // ? /simple/token_price/{id}
  /// only ethereum works for /{id} as of Apr 16 2021 [Api Limitation, not library]
  Future<CoinGeckoResult<List<SimpleToken>>> simpleTokenPrice(
      {required String id,
      required List<String> contractAddresses,
      required List<String> vs_currencies,
      bool includeMarketCap = false,
      bool include24hVol = false,
      bool include24hChange = false,
      bool includeLastUpdatedAt = false}) async {
    Response response =
        await dio!.get('/simple/token_price/$id', queryParameters: {
      "contract_addresses": contractAddresses.join(','),
      "vs_currencies": vs_currencies.join(','),
      "include_market_cap": includeMarketCap,
      "include_24hr_vol": include24hVol,
      "include_24hr_change": include24hChange,
      "include_last_updated_at": includeLastUpdatedAt
    });

    if (response.statusCode == 200) {
      List<SimpleToken> simpleTokenList = [];
      List<String> contractAddresses =
          (response.data as Map<String, dynamic>).keys.toList();
      for (String contractAddress in contractAddresses) {
        SimpleToken newToken = SimpleToken.fromJson(
            contractAddress, response.data[contractAddress]);
        simpleTokenList.add(newToken);
      }
      return CoinGeckoResult<List<SimpleToken>>(simpleTokenList);
    } else {
      return CoinGeckoResult([],
          errorMessage: response.data,
          errorCode: response.statusCode ?? -1,
          isError: true);
    }
  }

  // ? /simple/supported_vs_currencies
  Future<CoinGeckoResult<List<String>>> simpleSupportedVsCurrencies() async {
    Response response = await dio!.get('/simple/supported_vs_currencies',
        options: Options(responseType: ResponseType.json));
    if (response.statusCode == 200) {
      List<String> data = [];
      (response.data as List).forEach((element) {
        data.add(element.toString());
      });
      return CoinGeckoResult<List<String>>(data);
    } else {
      return CoinGeckoResult([],
          errorMessage: response.data,
          errorCode: response.statusCode ?? -1,
          isError: true);
    }
  }

  // ! COINS

  // ? /coins/list
  Future<CoinGeckoResult<List<Coin>>> listCoins({bool includePlatformFlag = false}) async {
    Response response = await dio!.get("/coins/list",
        queryParameters: {"include_platform": includePlatformFlag},
        options: Options(contentType: 'application/json'));

    if (response.statusCode == 200) {
      List<Coin> newCoinList = [];
      for (dynamic coinJson in response.data)
        newCoinList.add(Coin.fromJson(coinJson));
      return CoinGeckoResult<List<Coin>>(newCoinList);
    } else {
      return CoinGeckoResult([],
          errorMessage: response.data,
          errorCode: response.statusCode ?? -1,
          isError: true);
    }
  }

  //contract
  //exchanges(beta)
  //events
  //exchange rates
  //trending
  //global

}
