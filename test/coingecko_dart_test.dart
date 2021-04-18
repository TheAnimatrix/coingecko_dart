import 'package:coingecko_dart/coingecko_dart.dart';
import 'package:coingecko_dart/dataClasses/coins/CoinDataPoint.dart';
import 'package:coingecko_dart/helperClass/GeckoRateLimitException.dart';
import 'package:test/test.dart';

void main() async {
  CoinGeckoApi api = CoinGeckoApi(rateLimitManagement: false);
  test('call /ping and check for 200', () async {
    expect(await api.ping(), true);
  });

  test('call /simple/supported_vs_currencies and check if result contains usd',
      () async {
    var result = await api.simpleSupportedVsCurrencies();
    bool testResult = !result.isError && result.data.toString().contains("usd");
    expect(testResult, true);
  });

  test('call /simple/price and check if iota price > 0.1 usd', () async {
    var result = await api.simplePrice(
        ids: ["iota"],
        vs_currencies: ["usd", "inr", "jpy"],
        includeLastUpdatedAt: true,
        includeMarketCap: true);
    print(result.data[0].data);
    print(result.data[0].lastUpdatedAtTimeStamp);
    bool testResult = result.data[0].getPriceIn("usd") > 0.1;
    expect(testResult, true);
  });

  test('call /simple/token_price/{id} with id for aave and check result',
      () async {
    var result = await api.simpleTokenPrice(
        id: 'ethereum',
        contractAddresses: ['0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9'],
        vs_currencies: ['inr', 'usd', 'eth']);
    print(result.data[0].data);
  });

  test('call /coins/list and check if list contains btc', () async {
    var result = await api.listCoins(includePlatformFlag: false);
    bool testResult = !result.isError &&
        (result.data.any((element) => element.symbol.toUpperCase() == "BTC"));
    expect(testResult, true);
    // print(api.progressiveResult.coinList.sublist(100, 110));
    // print(api.progressiveResult.coinList.firstWhere((element) => element.symbol.toUpperCase()=="BTC"));
  });
  test(
      'call /coins/markets with bitcoin and tether, stablecoin filter on and see if tether is the only result.',
      () async {
    var result = await api.getCoinMarkets(
        vsCurrency: 'usd',
        coinIds: ['bitcoin', 'iota', 'tether'],
        category: CoinCategories.STABLECOIN,
        sparkline: true,
        priceChangePercentage: ['1h', '30d']);
    var testResult = !result.isError &&
        result.data.length == 1 &&
        result.data[0].id == "tether";
    expect(testResult, true);
  });

  test(
      'call /coins/{id} with "bitcoin" as the id and verify block time in minutes is 10',
      () async {
    var result = await api.getCoinData(
        id: 'bitcoin', localization: true, sparkline: true);
    expect(result.data.raw['block_time_in_minutes'], 10);
  });

  test('call /coins/{id}/tickers with "bitcoin and check if base is BTC',
      () async {
    var result = await api.getCoinTickers(
      id: "bitcoin",
      includeExchangeLogo: true,
    );
    bool testResult = !result.isError && result.data[0].base == "BTC";
    expect(testResult, true);
  });

  test(
      'call /coins/{id}/history and check current price on 02/04/19 and see if it matches with actual value',
      () async {
    var result = await api.getCoinHistory(
        id: 'bitcoin', date: DateTime(2019, 4, 2)); //02/04/2019
    bool testResult = !result.isError &&
        result.data.raw['market_data']['current_price']['usd'] ==
            4146.321927706636; //actual value
    expect(testResult, true);
  });

  test(
      'call /coins/{id}/market_chart and see if the 30th day data point contains a date of 30 days before now',
      () async {
    var result = await api.getCoinMarketChart(
        id: "bitcoin", vsCurrency: "usd", days: 30);
    expect(
        result.data[0].date?.add(Duration(days: 30)).day, DateTime.now().day);
  });

  test(
      'call /coins/{id}/market_chart/range and check the price on the 10th data point b/w a well defined range',
      () async {
    var result = await api.getCoinMarketChartRanged(
        id: "bitcoin",
        vsCurrency: "usd",
        from: DateTime(2021, 4, 2),
        to: DateTime(2021, 4, 10));
    expect(
        result.data[10],
        CoinDataPoint.fromArray([
          1617339741861,
          59632.02613531098
        ])); //10th data point value known already
  });

  test('call /coins/{id}/contract_address/{contract_address} for AAVE and check data',()async {
    var result = await api.getContractTokenData(id: "ethereum", contract_address: "0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9");
    expect(result.data.json['id'],'aave');
  });

  test('call /contract/market_chart for AAVE and check if 30th day data point is 30 days before now', () async {
    var result = await api.getContractMarketChart(id: 'ethereum', contract_address: '0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9', vsCurrency: 'usd', days: 30);
    expect(
        result.data[0].date?.add(Duration(days: 30)).day, DateTime.now().day);
  });

  test('call /contract/market_chart/range for AAVE between 10/10/2018 and 11/12/2018 and check data', () async {
    var result = await api.getContractMarketChartRanged(id: 'ethereum', contract_address: '0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9', vsCurrency: 'usd', from: DateTime(2020,12,10), to: DateTime(2020,12,11));
    expect(result.data[0].price,83.6540712096516);
  });

  test('call /exchanges/list',() async {
    var result = await api.getExchanges(page: 1,per_page: 10);
    expect(result.data[0].id,'binance');
    expect(result.data[1].id,'gdax');
    expect(result.data.length,10);
  });
  
  test('call /exchange_rates and check if Indian Rupee is part of the rate list',() async {
    var result = await api.getExchangeRatesBtc();
    expect(result.data.getVsList().contains("Indian Rupee"),true);
  });
  
  test('call /search/trending',() async {
    var result = await api.getSearchTrending();
    bool testResult = !result.isError && result.data.coins.length > 0;
    expect(testResult,true);
  });
  
  test('call /global',() async {
    var result = await api.getGlobalCoins();
    expect(result.data.activeCryptocurrencies>0,true);
  });
  
  test('call /global/defi',() async {
    var result = await api.getGlobalDefi();
    expect(result.data.ethMarketCap!>0,true);
  });
  

  test('gecko rate limit test', () async {
    expect(()=> spamApiPing(api),throwsA(const TypeMatcher<GeckoRateLimitException>()));
  }, timeout: Timeout(Duration(minutes: 1)));
}

Future<void> spamApiPing(CoinGeckoApi api) async {
  while (true) {
    print("pinging @ ${DateTime.now()} ${api.requestCount}");
    await api.ping();
  }
}
