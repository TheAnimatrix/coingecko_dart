import 'package:coingecko_dart/dataClasses/PricedCoin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coingecko_dart/coingecko_dart.dart';

void main() async {
/*   test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
  }); */
  CoinGeckoApi api = CoinGeckoApi();
  test('call /ping and checkk for 200', () async {
    expect(await api.ping(), true);
  });
  await Future.delayed(Duration(seconds: 3));

  test('call /coins/list and check if list contains btc', () async {
    var result = await api.listCoins(includePlatformFlag: false);
    bool testResult = !result.isError &&
        (result.data.any((element) => element.symbol.toUpperCase() == "BTC"));
    expect(testResult, true);
    // print(api.progressiveResult.coinList.sublist(100, 110));
    // print(api.progressiveResult.coinList.firstWhere((element) => element.symbol.toUpperCase()=="BTC"));
  });
  await Future.delayed(Duration(seconds: 3));

  test('call /simple/supported_vs_currencies and check if result contains usd', () async {
    var result = await api.simpleSupportedVsCurrencies();
    bool testResult = !result.isError && result.data.toString().contains("usd");
    expect(testResult,true);
  });

  await Future.delayed(Duration(seconds: 3));

  test('call /simple/price and check if iota price > 0.1 usd', () async {
    var result = await api.simplePrice(ids: ["iota"], vs_currencies: ["usd","inr","jpy"],includeLastUpdatedAt: true,includeMarketCap: true);
    print(result.data[0].data);
    print(result.data[0].lastUpdatedAtTimeStamp);
    bool testResult = result.data[0].getPriceIn("usd") > 0.1;
    expect(testResult,true);
  });

  await Future.delayed(Duration(seconds: 3));

  test('call /simple/token_price/{id} with id for aave and check result',() async {
    var result = await api.simpleTokenPrice(id: 'ethereum', contractAddresses: ['0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9'], vs_currencies: ['inr','usd','eth']);
    print(result.data[0].data);
  });

}
