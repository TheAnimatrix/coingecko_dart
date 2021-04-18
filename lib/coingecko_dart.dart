library coingecko_dart;

import 'package:coingecko_dart/dataClasses/coins/CoinTicker.dart';
import 'package:coingecko_dart/dataClasses/coins/FullCoin.dart';
import 'package:coingecko_dart/dataClasses/coins/SimpleToken.dart';
import 'package:coingecko_dart/dataClasses/contracts/ContractToken.dart';
import 'package:coingecko_dart/dataClasses/exchange_rates/exchange_rates.dart';
import 'package:coingecko_dart/dataClasses/exchanges/exchange.dart';
import 'package:coingecko_dart/dataClasses/global/global_coins.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'dataClasses/coins/Coin.dart';
import 'dataClasses/coins/CoinDataPoint.dart';
import 'dataClasses/coins/PricedCoin.dart';
import 'dataClasses/global/global_defi.dart';
import 'dataClasses/search/search_trending.dart';
import 'helperClass/GeckoRateLimitException.dart';

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
  int requestCount = 0;
  DateTime _firstRequest = DateTime.now();
  bool enableLogging = true;

  /**
   * ***Init() Initialize API***
   * 
   * used to initialize the http client
   * * [connectTimeout] specified in ms controls how long before connection request is timed out
   * * [receiveTimeout] specified in ms controls how long before server sends response once request is accepted
   */

  CoinGeckoApi(
      {int connectTimeout = 30000,
      int receiveTimeout = 10000,
      bool? rateLimitManagement = true,
      bool enableLogging = true}) {
    var options = BaseOptions(
        baseUrl: 'http://api.coingecko.com/api/v3',
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        validateStatus: (code) => true,
        responseType: ResponseType.json);
    dio = Dio(options);
    if (rateLimitManagement != null)
      dio!.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          requestCount++;
          if (requestCount == 1) _firstRequest = DateTime.now();
          if (requestCount >= GeckoRateLimitException.GECKO_REQ_PER_MINUTE &&
              DateTime.now().difference(_firstRequest).inSeconds <= 60) {
            if (rateLimitManagement == false)
              throw new GeckoRateLimitException();

            while (DateTime.now().difference(_firstRequest).inSeconds <= 60) {
              if (enableLogging)
                print(
                    'holding all requests for 2 seconds, difference is ${DateTime.now().difference(_firstRequest).inSeconds}');
              await Future.delayed(
                  Duration(seconds: 2)); //hold all requests for 2 seconds.
            }
            if (enableLogging) print('requests may pass');

            requestCount = 0;
          }
          return handler.next(options);
        },
      ));
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
      CoinCategories category = CoinCategories.ALL,

      ///filtering by category ignores coinIds.
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
    if (category != CoinCategories.ALL)
      queryParams['category'] = category.asString;
    if (coinIds.isNotEmpty) queryParams['ids'] = coinIds.join(',');
    if (priceChangePercentage.isNotEmpty)
      queryParams['price_change_percentage'] = priceChangePercentage.join(',');
    Response response =
        await dio!.get('/coins/markets', queryParameters: queryParams);

    if (response.statusCode == 200) {
      List<FullCoin> fullDataCoinList = [];
      for (var fullCoinJson in response.data) {
        fullDataCoinList.add(FullCoin.fromJson(fullCoinJson));
      }

      if (category != CoinCategories.ALL && coinIds.length > 0)
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
  ///@localization     -boolean(d:T)  - include all localized languages in response
  ///@tickers          -boolean(d:T) - include ticker data
  ///@market_data      -boolean(d:T) - include market data
  ///@community_data   -boolean(d:T) - include community data
  ///@developer_data   -boolean(d:T) - include developer data
  ///@sparkline        -boolean(d:F) - inmclude sparkline 7 days data

  Future<CoinGeckoResult<Coin>> getCoinData(
      {required String id,
      bool localization = false,
      bool tickers = true,
      bool marketData = true,
      bool communityData = true,
      bool developerData = true,
      bool sparkline = false}) async {
    assert(id.isNotEmpty, "coin id cannot be empty");
    Response response = await dio!.get('/coins/$id', queryParameters: {
      'id': id,
      'localization': localization,
      'tickers': tickers,
      'market_data': marketData,
      'community_data': communityData,
      'developer_data': developerData,
      'sparkline': sparkline
    });

    if (response.statusCode == 200) {
      return CoinGeckoResult(Coin.fromJson(response.data));
    } else {
      return CoinGeckoResult(Coin(),

          ///initializing Coin() is essentially a null coin, Coin().isNull = true
          errorCode: response.statusCode ?? -1,
          errorMessage: (response.statusMessage ?? "") + " " + response.data,
          isError: true);
    }
  }

  //? /coins/{id}/tickers

  ///Get coin tickers
  ///@id                   *- string - coin id ex : bitcoin
  ///@exchange_ids          - string - exchange ids separate by comma
  ///@include_exchange_logo - boolean- true/false
  ///@page                  - 100 tickers per page, page no.
  ///@order                 - valid values: trust_score_desc (default), trust_score_asc and volume_desc
  ///@depth                 - flag to show 2% orderbook depth. valid values: true, false

  Future<CoinGeckoResult<List<CoinTicker>>> getCoinTickers(
      {required String id,
      List<String> exchangeIds = const [],
      bool includeExchangeLogo = true,
      int page = 1,
      TickerOrdering order = TickerOrdering.TRUST_SCORE_DESC,
      bool depth = true}) async {
    Response response = await dio!.get('/coins/$id/tickers', queryParameters: {
      'id': id,
      'exchange_ids': exchangeIds,
      'include_exchange_logo': includeExchangeLogo,
      'page': page,
      'order': order.asString,
      'depth': depth
    });

    if (response.statusCode == 200) {
      List<CoinTicker> coinTickers = [];
      for (dynamic tickerJson in response.data["tickers"])
        coinTickers.add(CoinTicker.fromJson(tickerJson));
      return CoinGeckoResult(coinTickers);
    } else {
      return CoinGeckoResult([],
          errorCode: response.statusCode ?? -1,
          errorMessage: (response.statusMessage ?? "") + " " + response.data,
          isError: true);
    }
  }

  //? /coins/{id}/history

  ///Get historical data (name, price, market, stats) at a given date for a coin
  ///@id                   *- string - coin id, ex : bitcoin
  ///@date                 *- string - dd-mm-yyyy
  ///@localization           - boolean- set false to exclude localized languages

  Future<CoinGeckoResult<Coin>> getCoinHistory(
      {required String id,
      required DateTime date,
      bool localization = true}) async {
    Response response = await dio!.get('/coins/$id/history', queryParameters: {
      'date': DateFormat('dd-MM-yyyy').format(date),
      'localization': localization
    });

    if (response.statusCode == 200) {
      return CoinGeckoResult(Coin.fromJson(response.data));
    } else {
      print(response);
      return CoinGeckoResult(Coin(),
          errorCode: response.statusCode ?? -1,
          errorMessage: (response.statusMessage ?? "") + " " + response.data,
          isError: true);
    }
  }
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
  Future<CoinGeckoResult<List<CoinDataPoint>>> getCoinMarketChart(
      {required String id,
      required String vsCurrency,
      required int days,
      ChartTimeInterval interval = ChartTimeInterval.EMPTY}) async {
    Map<String, dynamic> queryParams = {
      'vs_currency': vsCurrency,
      'days': days,
    };
    if (interval.isNotEmpty) queryParams['interval'] = interval.asString;
    Response response =
        await dio!.get('/coins/$id/market_chart', queryParameters: queryParams);
    if (response.statusCode == 200) {
      List<CoinDataPoint> coinDataPoints = [];
      for (dynamic priceJson in response.data["prices"]) {
        coinDataPoints.add(CoinDataPoint.fromArray(priceJson));
      }
      return CoinGeckoResult(coinDataPoints);
    } else {
      return CoinGeckoResult([],
          errorCode: response.statusCode ?? -1,
          errorMessage: (response.statusMessage ?? "") + " " + response.data,
          isError: true);
    }
  }

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

  Future<CoinGeckoResult<List<CoinDataPoint>>> getCoinMarketChartRanged(
      {required String id,
      required String vsCurrency,
      required DateTime from,
      required DateTime to}) async {
    assert(to.isAfter(from), "To Date is before From Date!!");
    Response response =
        await dio!.get('/coins/$id/market_chart/range', queryParameters: {
      'vs_currency': vsCurrency,
      'from': (from.millisecondsSinceEpoch / 1000).round(),
      'to': (to.millisecondsSinceEpoch / 1000).round()
    });

    if (response.statusCode == 200) {
      List<CoinDataPoint> coinDataPoints = [];
      for (dynamic priceJson in response.data["prices"]) {
        coinDataPoints.add(CoinDataPoint.fromArray(priceJson));
      }
      return CoinGeckoResult(coinDataPoints);
    } else {
      return CoinGeckoResult([],
          errorCode: response.statusCode ?? -1,
          errorMessage: (response.statusMessage ?? "") + " " + response.data,
          isError: true);
    }
  }

  //! contract
  //? /coins/{id}/contract/{contract_address}
  //@id               *- id
  //@contract_address *- contract_address
  Future<CoinGeckoResult<ContractToken>> getContractTokenData(
      {required String id, required String contract_address}) async {
    Response response = await dio!.get('/coins/$id/contract/$contract_address');
    if (response.statusCode == 200) {
      return CoinGeckoResult(ContractToken.fromJson(response.data));
    } else {
      return CoinGeckoResult(ContractToken(),
          errorCode: response.statusCode ?? -1,
          errorMessage: (response.statusMessage ?? "") + " " + response.data,
          isError: true);
    }
  }

  //? /coins/{id}/contract/{contract_address}/market_chart
  ///@id               *- id
  ///@contract_address *- string
  ///@vs_currency      *- string
  ///@days             *- int
  Future<CoinGeckoResult<List<CoinDataPoint>>> getContractMarketChart(
      {required String id,
      required String contract_address,
      required String vsCurrency,
      required int days}) async {
    Map<String, dynamic> queryParams = {
      'vs_currency': vsCurrency,
      'days': days,
    };
    Response response = await dio!.get(
        '/coins/$id/contract/$contract_address/market_chart',
        queryParameters: queryParams);
    if (response.statusCode == 200) {
      List<CoinDataPoint> coinDataPoints = [];
      for (dynamic priceJson in response.data["prices"]) {
        coinDataPoints.add(CoinDataPoint.fromArray(priceJson));
      }
      return CoinGeckoResult(coinDataPoints);
    } else {
      return CoinGeckoResult([],
          errorCode: response.statusCode ?? -1,
          errorMessage: (response.statusMessage ?? "") + " " + response.data,
          isError: true);
    }
  }

  //? /coins/{id}/contract/{contract_address}/market_chart/range
  ///@id                *- String   - (only ethereum allowed for now) otherwise 500 error
  ///@contract_address  *- String
  ///@vs_currency       *- String
  ///@from              *- int
  ///@to                *- int
  Future<CoinGeckoResult<List<CoinDataPoint>>> getContractMarketChartRanged(
      {required String id,
      required String contract_address,
      required String vsCurrency,
      required DateTime from,
      required DateTime to}) async {
    assert(to.isAfter(from), "To Date is before From Date!!");
    Response response = await dio!.get(
        '/coins/$id/contract/$contract_address/market_chart/range',
        queryParameters: {
          'vs_currency': vsCurrency,
          'from': (from.millisecondsSinceEpoch / 1000).round(),
          'to': (to.millisecondsSinceEpoch / 1000).round()
        });

    if (response.statusCode == 200) {
      List<CoinDataPoint> coinDataPoints = [];
      for (dynamic priceJson in response.data["prices"]) {
        coinDataPoints.add(CoinDataPoint.fromArray(priceJson));
      }
      return CoinGeckoResult(coinDataPoints);
    } else {
      return CoinGeckoResult([],
          errorCode: response.statusCode ?? -1,
          errorMessage: (response.statusMessage ?? "") + " " + response.data,
          isError: true);
    }
  }

  //! exchanges(beta)
  //? /exchanges

  //? /exchanges
  ///@page     - int
  ///@per_page - int
  Future<CoinGeckoResult<List<Exchange>>> getExchanges(
      {int page = 1, int per_page = 100}) async {
    Response response = await dio!.get('/exchanges',
        queryParameters: {"page": page, "per_page": per_page});

    if (response.statusCode == 200) {
      List<Exchange> exchangeList = [];
      for (dynamic exchangeJson in response.data) {
        exchangeList.add(Exchange.fromJson(exchangeJson));
      }
      return CoinGeckoResult(exchangeList);
    } else {
      return CoinGeckoResult([],
          errorCode: response.statusCode ?? -1,
          errorMessage: (response.statusMessage ?? "") + " " + response.data,
          isError: true);
    }
  }

  //! exchange rates
  //? /exchange_rates
  ///no params
  ///Get BTC-to-Currency exchange rates
  ///
  ///use returnedValue.getVsList() to obtain other currency names available in list
  ///
  ///use returnedValue.getRateOf(input_currency) to obtain btc's value in the input currency as an instance of `ExchangeRate`
  Future<CoinGeckoResult<ExchangeRates>> getExchangeRatesBtc() async {
    Response response = await dio!.get('/exchange_rates');
    if (response.statusCode == 200) {
      return CoinGeckoResult(ExchangeRates.fromJson(response.data));
    } else {
      return CoinGeckoResult(ExchangeRates(),
          errorCode: response.statusCode ?? -1,
          errorMessage: (response.statusMessage ?? "") + " " + response.data,
          isError: true);
    }
  }

  //! trending
  //? /search/trending
  //
  Future<CoinGeckoResult<SearchTrending>> getSearchTrending() async {
    Response response = await dio!.get('/search/trending');
    if (response.statusCode == 200) {
      return CoinGeckoResult(SearchTrending.fromJson(response.data));
    } else {
      return CoinGeckoResult(SearchTrending(),
          errorCode: response.statusCode ?? -1,
          errorMessage: (response.statusMessage ?? "") + " " + response.data,
          isError: true);
    }
  }

  //
  //! global
  //? /global
  Future<CoinGeckoResult<GlobalCoins>> getGlobalCoins() async {
    Response response = await dio!.get('/global');

    if (response.statusCode == 200) {
      return CoinGeckoResult(GlobalCoins.fromJson(response.data));
    } else {
      return CoinGeckoResult(GlobalCoins(),
          errorCode: response.statusCode ?? -1,
          errorMessage: (response.statusMessage ?? "") + " " + response.data,
          isError: true);
    }
  }

  //? /global/decentralized_finance_defi
  Future<CoinGeckoResult<GlobalDefi>> getGlobalDefi() async {
    Response response = await dio!.get('/global');

    if (response.statusCode == 200) {
      return CoinGeckoResult(GlobalDefi.fromJson(response.data));
    } else {
      return CoinGeckoResult(GlobalDefi(),
          errorCode: response.statusCode ?? -1,
          errorMessage: (response.statusMessage ?? "") + " " + response.data,
          isError: true);
    }
  }
}

//enums

enum TickerOrdering { TRUST_SCORE_ASC, TRUST_SCORE_DESC, VOLUME_DESC }

extension TickerOrderingExt on TickerOrdering {
  String get asString => this.toString().toLowerCase();
}

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

enum ChartTimeInterval { MINUTELY, HOURLY, DAILY, EMPTY }

extension ChartTimeIntervalExt on ChartTimeInterval {
  String get asString => this.toString().toLowerCase().capitalize();
  bool get isNotEmpty => this != ChartTimeInterval.EMPTY;
}

extension StringExt on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
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
