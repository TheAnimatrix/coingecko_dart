import 'package:coingecko_dart/helperClass/staticHelpers.dart';

import 'Coin.dart';

class FullCoin extends Coin {
  final Map<String, dynamic> json;
  final String? image;
  final double? currentPrice,
      marketCap,
      fullyDilutedValuation,
      totalVolume,
      high24h,
      low24h,
      priceChange24h,
      priceChangePercentage24h,
      marketCapChange24h,
      marketCapChangePercentage24h,
      circulatingSupply,
      totalSupply,
      maxSupply,
      ath,
      athChangePercentage,
      atl,
      atlChangePercentage,
      priceChangePercentage14dInCurrency,
      priceChangePercentage1hInCurrency,
      priceChangePercentage24hInCurrency,
      priceChangePercentage7dInCurrency,
      priceChangePercentage30dInCurrency,
      priceChangePercentage200dInCurrency,
      priceChangePercentage1yInCurrency;
  final int? marketCapRank;
  DateTime? athDate, atlDate, lastUpdated;
  List<double> sparkline7d = const[];

  FullCoin.fromJson(Map<String, dynamic> json)
      : json = json,
        image = json['image'],
        currentPrice = StaticHelpers.checkDouble(json['current_price'], -1.0),
        marketCap = StaticHelpers.checkDouble(json['market_cap'], -1.0),
        marketCapRank = json['market_cap_rank'],
        fullyDilutedValuation =
            StaticHelpers.checkDouble(json['fully_diluted_valuation'], -1.0),
        circulatingSupply =
            StaticHelpers.checkDouble(json['circulating_supply'], -1.0),
        maxSupply = StaticHelpers.checkDouble(json['max_supply'], -1.0),
        totalSupply = StaticHelpers.checkDouble(json['total_supply'], -1.0),
        totalVolume = StaticHelpers.checkDouble(json['total_volume'], -1.0),
        high24h = StaticHelpers.checkDouble(json['high_24h'], null),
        low24h = StaticHelpers.checkDouble(json['low_24h'], null),
        priceChange24h =
            StaticHelpers.checkDouble(json['price_change_24h'], null),
        priceChangePercentage24h = StaticHelpers.checkDouble(
            json['price_change_percentage_24h'], null),
        marketCapChange24h =
            StaticHelpers.checkDouble(json['market_cap_change_24h'], null),
        marketCapChangePercentage24h = StaticHelpers.checkDouble(
            json['market_cap_percentage_change_24h'], null),
        priceChangePercentage1hInCurrency = StaticHelpers.checkDouble(
            json['price_change_percentage_1h_in_currency'], null),
        priceChangePercentage24hInCurrency = StaticHelpers.checkDouble(
            json['price_change_percentage_24h_in_currency'], null),
        priceChangePercentage7dInCurrency = StaticHelpers.checkDouble(
            json['price_change_percentage_7d_in_currency'], null),
        priceChangePercentage14dInCurrency = StaticHelpers.checkDouble(
            json['price_change_percentage_14d_in_currency'], null),
        priceChangePercentage30dInCurrency = StaticHelpers.checkDouble(
            json['price_change_percentage_30d_in_currency'], null),
        priceChangePercentage200dInCurrency = StaticHelpers.checkDouble(
            json['price_change_percentage_200d_in_currency'], null),
        priceChangePercentage1yInCurrency = StaticHelpers.checkDouble(
            json['price_change_percentage_1y_in_currency'], null),
        atl = StaticHelpers.checkDouble(json['atl'], null),
        ath = StaticHelpers.checkDouble(json['ath'], null),
        atlChangePercentage =
            StaticHelpers.checkDouble(json['atl_change_percentage'], null),
        athChangePercentage =
            StaticHelpers.checkDouble(json['ath_change_percentage'], null),
        super.fromJson(json) {
    athDate =
        (json['ath_date'] != null) ? DateTime.tryParse(json['ath_date']) : null;
    atlDate =
        (json['atl_date'] != null) ? DateTime.tryParse(json['atl_date']) : null;
    lastUpdated = (json['last_updated'] != null)
        ? DateTime.tryParse(json['last_updated'])
        : null;

    //decode sparkline
    List<double> sparkline7d = [];
    if (json['sparkline_in_7d'] != null &&
        json['sparkline_in_7d']['price'] != null) {
      for (double price in json['sparkline_in_7d']['price'])
        sparkline7d.add(price);
    }
    this.sparkline7d = sparkline7d;
  }

  @override
  String toString() {
    String sparkline5;
    if (sparkline7d.length==0)
      sparkline5 = "sparkline empty/disabled";
    else
      sparkline5 = sparkline7d
          .sublist(0, sparkline7d.length > 5 ? 5 : sparkline7d.length)
          .join(',');

    String perChange = priceChangePercentage1hInCurrency.toString() +
        " - " +
        priceChangePercentage24hInCurrency.toString() +
        " - " +
        priceChangePercentage7dInCurrency.toString() +
        " - " +
        priceChangePercentage30dInCurrency.toString() +
        " - " +
        priceChangePercentage200dInCurrency.toString() +
        "- ";
    return "id: $id, symbol: $symbol, current_price: $currentPrice, market_cap: $marketCap, lastupdated: $lastUpdated, sparkline: $sparkline5, per_change_1h_1d_7d_30d_200d: $perChange";
  }
}

//Sample Data:
/* "id": "tether",
    "symbol": "usdt",
    "name": "Tether",price_change_percentage_14d_in_currency
    "image": "https://assets.coingecko.com/coins/images/325/large/Tether-logo.png?1598003707",
    "current_price": 1,
    "market_cap": 47960932828,
    "market_cap_rank": 5,
    "fully_diluted_valuation": null,
    "total_volume": 219580126027,
    "high_24h": 1.01,
    "low_24h": 0.994353,
    "price_change_24h": 0.00320946,
    "price_change_percentage_24h": 0.32167,
    "market_cap_change_24h": 1084047919,
    "market_cap_change_percentage_24h": 2.31254,
    "circulating_supply": 47915791499.3274,
    "total_supply": 47915791499.3274,
    "max_supply": null,
    "ath": 1.32,
    "ath_change_percentage": -24.34845,
    "ath_date": "2018-07-24T00:00:00.000Z",
    "atl": 0.572521,
    "atl_change_percentage": 74.83063,
    "atl_date": "2015-03-02T00:00:00.000Z",
    "roi": null,
    "last_updated": "2021-04-17T09:07:00.318Z",
    "sparkline_in_7d": {
      "price": [
        price1,
        price2,
        ..
        priceX
      ]
    },
    "price_change_percentage_14d_in_currency": 0.03808313888541255,
    "price_change_percentage_1h_in_currency": 0.0719637338459427,
    "price_change_percentage_1y_in_currency": -0.19126533483736746,
    "price_change_percentage_200d_in_currency": 0.08532963364728875,
    "price_change_percentage_24h_in_currency": 0.3216749747346479,
    "price_change_percentage_30d_in_currency": -0.30922846345094457,
    "price_change_percentage_7d_in_currency": 0.14401106093533683 */
