
import 'package:coingecko_dart/dataClasses/PricedCoinBase.dart';

import 'Coin.dart';

class PricedCoin extends PricedCoinBase {

  Coin? coinData;

  PricedCoin.fromJson(Coin coin,Map<String, dynamic> json) : super.fromJson(json) {
    coinData = coin;
  }

}