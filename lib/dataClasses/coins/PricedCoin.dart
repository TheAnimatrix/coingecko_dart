
import 'Coin.dart';
import 'PricedCoinBase.dart';

class PricedCoin extends PricedCoinBase {

  Coin? coinData;

  PricedCoin.fromJson(Coin coin,Map<String, dynamic> json) : super.fromJson(json) {
    coinData = coin;
  }

}