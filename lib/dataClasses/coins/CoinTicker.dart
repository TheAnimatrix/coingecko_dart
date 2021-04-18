import 'package:coingecko_dart/helperClass/staticHelpers.dart';

class CoinTicker {
  String? base, target, tradeUrl, tokenInfoUrl, coinId;
  Market? market;
  double? last,
      volume,
      bidAskSpreadPercentage,
      costToMoveUpUSD,
      costToMoveDownUSD;
  Converted? convertedLast, convertedVolume;
  DateTime? timestamp, lastTradedAt, lastFetchAt;
  bool? isAnomaly, isState;

  CoinTicker.fromJson(Map<String, dynamic> json) {
    base = json['base'];
    target = json['target'];
    tradeUrl = json['trade_url'];
    tokenInfoUrl = json['token_info_url'];
    coinId = json['coin_id'];
    market = Market.fromJson(json['market']);
    last = StaticHelpers.checkDouble(json['last'],-1.0);
    volume = StaticHelpers.checkDouble(json['volume'],-1.0);
    bidAskSpreadPercentage = StaticHelpers.checkDouble(json['bid_ask_spread_percentage'],-1.0);
    costToMoveDownUSD = StaticHelpers.checkDouble(json['cost_to_move_down_usd'],-1.0);
    costToMoveUpUSD = StaticHelpers.checkDouble(json['cost_to_move_up_usd'],-1.0);
    convertedLast = Converted.fromJson(json['converted_last']);
    convertedVolume = Converted.fromJson(json['converted_volume']);
    timestamp = DateTime.tryParse(json['timestamp'].toString());
    lastTradedAt = DateTime.tryParse(json['last_traded_at'].toString());
    lastFetchAt = DateTime.tryParse(json['last_fetch_at'].toString());
    isAnomaly = json['is_anomaly'];
    isState = json['is_state'];
  }

  @override
  String toString() {
    return "Base: $base, Target: $target, Last: $last, LastTradedAt: $lastTradedAt, CostToMoveUpUSD: $costToMoveUpUSD, Market: ${market?.identifier}, ${market?.name}, ConvertedLast: btc ${convertedLast?.btc} usd ${convertedLast?.usd}";
  }

}

class Market {
  String? name, identifier;
  bool? hasTradingIncentive;
  String? logo;

  Market.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    identifier = json['identifier'];
    hasTradingIncentive = json['has_trading_incentive'];
    logo = json['logo'];
  }
}

class Converted {
  double btc = -1.0, eth = -1.0, usd = -1.0;

  Converted.fromJson(Map<String, dynamic> json) {
    btc = StaticHelpers.checkDoubleN(json['btc'], -1.0);
    eth = StaticHelpers.checkDoubleN(json['eth'], -1.0);
    usd = StaticHelpers.checkDoubleN(json['usd'], -1.0);
  }
}

/*       "base": "BTC",
      "target": "EUR",
      "market": {
        "name": "Bitfinex",
        "identifier": "bitfinex",
        "has_trading_incentive": false,
        "logo": "https://assets.coingecko.com/markets/images/4/small/BItfinex.png?1615895883"
      },
      "last": 49834.14379715,
      "volume": 513.3287969,
      "cost_to_move_up_usd": 27513937.67644827,
      "cost_to_move_down_usd": 85939855.23510967,
      "converted_last": {
        "btc": 0.98925945,
        "eth": 25.344821,
        "usd": 59711
      },
      "converted_volume": {
        "btc": 507.815,
        "eth": 13010,
        "usd": 30651376
      },
      "trust_score": "green",
      "bid_ask_spread_percentage": 0.020064,
      "timestamp": "2021-04-17T17:59:15+00:00",
      "last_traded_at": "2021-04-17T17:59:15+00:00",
      "last_fetch_at": "2021-04-17T18:00:28+00:00",
      "is_anomaly": false,
      "is_stale": false,
      "trade_url": "https://www.bitfinex.com/t/BTCEUR",
      "token_info_url": null,
      "coin_id": "bitcoin" */
