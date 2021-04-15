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
  test('check server api ping 200', () async {
    expect((await api.ping()).isSuccess, true);
  });

  test('get coin list and check if list contains btc', () async {
    await api.listCoins(includePlatformFlag: false);
    bool testResult = api.progressiveResult.isSuccess &&
        (api.progressiveResult.coinList
            .any((element) => element.symbol.toUpperCase() == "BTC"));
    expect(testResult, true);
    // print(api.progressiveResult.coinList.sublist(100, 110));
    // print(api.progressiveResult.coinList.firstWhere((element) => element.symbol.toUpperCase()=="BTC"));
  });
}
