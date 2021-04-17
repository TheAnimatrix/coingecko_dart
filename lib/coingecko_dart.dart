library coingecko_dart;

import 'package:coingecko_dart/dataClasses/FullCoin.dart';
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
  Future<CoinGeckoResult<List<Coin>>> listCoins(
      {bool includePlatformFlag = false}) async {
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

  //? /coins/markets

  ///List all supported coins price, market cap, volume, and market related data
  ///@vs_currency            *- string - target currency of market data
  ///@ids                     - string - ids of coins separated by comma
  ///@category                - string - filter by coin category, only decentralized_finance_defi and stablecoins are supported at the moment
  ///@order                   - string - sort results by field market_cap_desc, gecko_desc, gecko_asc, market_cap_asc, market_cap_desc, volume_asc, volume_desc, id_asc, id_desc
  ///@per_page                - integer- 1...250, default 100 items per page
  ///@page                    - integer- page number
  ///@sparkline               - boolean- include sparkline 7 days data (default:false)
  ///@price_change_percentage - string - Include price change percentage in 1h, 24h, 7d, 14d, 30d, 200d, 1y

  Future<CoinGeckoResult<List<FullCoin>>> getCoinMarkets(
      {required String vsCurrency,
      List<String> coinIds = const [], //null=all coins
      CoinCategories category = CoinCategories.ALL, ///filtering by category ignores coinIds.
      CoinMarketOrder order = CoinMarketOrder.MARKET_CAP_DESC, 
      int itemsPerPage = 100,
      int page = 1,
      bool sparkline = false,
      List<String> priceChangePercentage = const []
      ///possible values 1h, 24h, 7d, 14d, 30d, 200d, 1y
      }) async {
    Map<String, dynamic> queryParams = {
      'vs_currency': vsCurrency,
      'order': order.asString,
      'per_page': itemsPerPage,
      'page': page,
      'sparkline': sparkline,
    };
    if (category != CoinCategories.ALL) queryParams['category'] = category.asString;
    if (coinIds.isNotEmpty) queryParams['ids'] = coinIds.join(',');
    if (priceChangePercentage.isNotEmpty)
      queryParams['price_change_percentage'] = priceChangePercentage.join(',');
    Response response =
        await dio!.get('/coins/markets', queryParameters: queryParams);

    if (response.statusCode == 200) {
      List<FullCoin> fullDataCoinList = [];
      for(var fullCoinJson in response.data){
        fullDataCoinList.add(FullCoin.fromJson(fullCoinJson));
      }

      if(category != CoinCategories.ALL && coinIds.length>0)
        fullDataCoinList.retainWhere((element) => coinIds.contains(element.id));

      return CoinGeckoResult(fullDataCoinList);
    } else {
      return CoinGeckoResult([],
          errorCode: response.statusCode ?? -1,
          errorMessage:
              (response.statusMessage ?? "" + response.data.toString()),
          isError: true);
    }
  }

  //? /coins/{id}

  ///Get current data (name, price, market, ... including exchange tickers) for a coin
  ///@id              *-string       - coin id ex : bitcoin
  ///@localization     -boolean(d:T  - include all localized languages in response
  ///@tickers          -boolean(d:T) - include ticker data
  ///@market_data      -boolean(d:T) - include market data
  ///@community_data   -boolean(d:T) - include community data
  ///@developer_data   -boolean(d:T) - include developer data
  ///@sparkline        -boolean(d:F) - inmclude sparkline 7 days data

  getCoinData() {}

  //? /coins/{id}/tickers

  ///Get coin tickers
  ///@id                   *- string - coin id ex : bitcoin
  ///@exchange_ids          - string - exchange ids separate by comma
  ///@include_exchange_logo - boolean- true/false
  ///@page                  - 100 tickers per page, page no.
  ///@order                 - valid values: trust_score_desc (default), trust_score_asc and volume_desc
  ///@depth                 - flag to show 2% orderbook depth. valid values: true, false

  getCoinTickers() {}

  //? /coins/{id}/history

  ///Get historical data (name, price, market, stats) at a given date for a coin
  ///@id                   *- string - coin id, ex : bitcoin
  ///@date                 *- string - dd/mm/yyyy
  ///@localiation           - boolean- set false to exclude localized languages

  getCoinHistory() {}

  //? /coins/{id}/market_chart

  ///Get historical market data include price, market cap, and 24h volume (granularity auto)
  ///
  ///Minutely data will be used for duration within 1 day,
  ///Hourly data will be used for duration between 1 day and 90 days,
  ///Daily data will be used for duration above 90 days.
  ///
  ///@id                   *- string - coin id, ex: bitcoin
  ///
  ///@vs_currency          *- string - target currency (usd,jpy,etc.)
  ///
  ///@days                 *- string - data upto no. of days ago
  ///
  ///@interval              - string - interval (daily,minutely,hourly)
  //
  //Defaults to bitcoin-usd-1 day-daily
  getCoinMarketChart(
      {String id = "bitcoin",
      String vs_currency = "usd",
      int days = 1,
      String interval = "daily"}) {}

  //? /coins/{id}/market_chart/range
  ///Get historical market data include price, market cap, and 24h volume (granularity auto)
  ///
  ///Minutely data will be used for duration within 1 day, Hourly data will
  ///be used for duration between 1 day and 90 days,
  ///Daily data will be used for duration above 90 days.
  ///
  ///@id                  *- string - coin id, ex : bitcoin
  ///
  ///@vs_currency         *- string - target currency
  ///
  ///@from                *- string - from unix timestamp
  ///
  ///@to                  *- string - to unix timestamp

  getCoinMarketChartRanged() {}

  //! contract
  //? /coins/{id}/contract/{contract_address}
  //? /coins/{id}/contract/{contract_address}/market_chart
  //? /coins/{id}/contract/{contract_address}/market_chart/range
  //
  //! exchanges(beta)
  //? /exchanges
  //
  //! events
  //? /events
  //? /events/countries
  //? /events/types
  //
  //! exchange rates
  //? /exchange_rates
  //
  //! trending
  //? /search/trending
  //
  //! global
  //? /global
  //? /global/decentralized_finance_defi

}

//enums

enum CoinCategories { ALL, DEFI, STABLECOIN }

extension CoinCategoriesExt on CoinCategories {
  String get asString {
    switch (this) {
      case CoinCategories.ALL:
        return "all";
      case CoinCategories.DEFI:
        return "decentralized_finance_defi";
      case CoinCategories.STABLECOIN:
        return "stablecoins";
    }
  }
}

//market_cap_desc, gecko_desc, gecko_asc, market_cap_asc, market_cap_desc, volume_asc, volume_desc, id_asc, id_desc
enum CoinMarketOrder {
  DESC,
  ASC,
  MARKET_CAP_DESC,
  MARKET_CAP_ASC,
  VOLUME_DESC,
  VOLUME_ASC,
  ID_ASC,
  ID_DESC
}

extension CoinMarketOrderExt on CoinMarketOrder {
  String get asString {
    switch (this) {
      case CoinMarketOrder.DESC:
        return "DESC";
      case CoinMarketOrder.ASC:
        return "ASC";
      case CoinMarketOrder.ID_ASC:
        return "ID_ASC";
      case CoinMarketOrder.ID_DESC:
        return "ID_DESC";
      case CoinMarketOrder.VOLUME_ASC:
        return "VOLUME_ASC";
      case CoinMarketOrder.VOLUME_DESC:
        return "VOLUME_DESC";
      case CoinMarketOrder.MARKET_CAP_ASC:
        return "MARKET_CAP_ASC";
      case CoinMarketOrder.MARKET_CAP_DESC:
      default:
        return "MARKET_CAP_DESC";
    }
  }
}
